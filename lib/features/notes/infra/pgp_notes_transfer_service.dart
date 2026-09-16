import 'dart:convert';

import 'package:uuid/uuid.dart';
import 'package:veil/core/crypto/crypto_service.dart';
import 'package:veil/core/crypto/domain/encrypted_data.dart';
import 'package:veil/features/notes/application/notes_service.dart';
import 'package:veil/features/notes/application/notes_transfer_service.dart';
import 'package:veil/features/notes/domain/note.dart';
import 'package:veil/features/notes/domain/note_file.dart';
import 'package:veil/features/notes/domain/notes_repository.dart';
import 'package:veil/features/notes/domain/notes_transfer_result.dart';
import 'package:veil/features/veil/domain/password/password_validator.dart';
import 'package:veil/features/veil/domain/veil_exception.dart';
import 'package:veil/features/veil/domain/vault_key_provider.dart';

class PgpNotesTransferService implements NotesTransferService {
  static const _formatVersion = 1;

  final NotesService _notesService;
  final NotesRepository _repository;
  final CryptoService _cryptoService;
  final VaultKeyProvider _vaultKeyProvider;
  final PasswordValidator _passwordValidator;
  final Uuid _uuid;

  PgpNotesTransferService({
    required NotesService notesService,
    required NotesRepository repository,
    required CryptoService cryptoService,
    required VaultKeyProvider vaultKeyProvider,
    required PasswordValidator passwordValidator,
    Uuid? uuid,
  }) : _notesService = notesService,
       _repository = repository,
       _cryptoService = cryptoService,
       _vaultKeyProvider = vaultKeyProvider,
       _passwordValidator = passwordValidator,
       _uuid = uuid ?? const Uuid();

  @override
  Future<NotesExport> exportNotes(String password) async {
    _validateExportPassword(password);

    final notes = await _notesService.list();
    final envelope = jsonEncode({
      'formatVersion': _formatVersion,
      'notes': notes.map((note) => note.toJson()).toList(),
    });
    final encrypted = await _cryptoService.encryptSymmetric(envelope, password);

    return NotesExport(
      encryptedPayload: encrypted.payload,
      noteCount: notes.length,
    );
  }

  @override
  Future<NotesImportResult> importNotes({
    required String encryptedPayload,
    required String password,
  }) async {
    final envelope = await _decodeEnvelope(encryptedPayload, password);
    final notes = _decodeNotes(envelope);
    final existingFiles = await _repository.findAll();
    final reservedIds = existingFiles.map((file) => file.id).toSet();
    final resolvedNotes = <Note>[];
    var conflictCount = 0;

    for (final note in notes) {
      var resolvedId = note.id;
      if (reservedIds.contains(resolvedId)) {
        do {
          resolvedId = _uuid.v7();
        } while (reservedIds.contains(resolvedId));
        conflictCount++;
      }

      reservedIds.add(resolvedId);
      resolvedNotes.add(note.copyWith(id: resolvedId));
    }

    final publicKey = await _vaultKeyProvider.getPublicKey();
    final filesToSave = <NoteFile>[];

    for (final note in resolvedNotes) {
      final encrypted = await _cryptoService.encrypt(
        jsonEncode(note.toJson()),
        publicKey,
      );
      filesToSave.add(
        NoteFile(id: note.id, encryptedPayload: encrypted.payload),
      );
    }

    final attemptedIds = <String>[];
    try {
      for (final file in filesToSave) {
        attemptedIds.add(file.id);
        await _repository.save(file);
      }
    } catch (_) {
      for (final id in attemptedIds.reversed) {
        try {
          await _repository.delete(id);
        } catch (_) {
          // Preserve the original write failure.
        }
      }
      rethrow;
    }

    return NotesImportResult(
      importedCount: resolvedNotes.length,
      conflictCount: conflictCount,
    );
  }

  void _validateExportPassword(String password) {
    final result = _passwordValidator.validate(password);
    final error = result.error;
    if (!result.isValid && error != null) {
      throw VeilException.passwordValidation(error);
    }

    if (!result.isValid) {
      throw const NotesTransferException(
        NotesTransferExceptionCode.invalidPayload,
      );
    }
  }

  Future<Map<String, dynamic>> _decodeEnvelope(
    String encryptedPayload,
    String password,
  ) async {
    late final String payload;
    try {
      payload = await _cryptoService.decryptSymmetric(
        EncryptedData(encryptedPayload),
        password,
      );
    } catch (_) {
      throw const NotesTransferException(
        NotesTransferExceptionCode.invalidFileOrPassword,
      );
    }

    late final dynamic decoded;
    try {
      decoded = jsonDecode(payload);
    } catch (_) {
      throw const NotesTransferException(
        NotesTransferExceptionCode.invalidPayload,
      );
    }

    if (decoded is! Map<String, dynamic>) {
      throw const NotesTransferException(
        NotesTransferExceptionCode.invalidPayload,
      );
    }

    final version = decoded['formatVersion'];
    if (version != _formatVersion) {
      throw const NotesTransferException(
        NotesTransferExceptionCode.unsupportedFormatVersion,
      );
    }

    return decoded;
  }

  List<Note> _decodeNotes(Map<String, dynamic> envelope) {
    final rawNotes = envelope['notes'];
    if (rawNotes is! List) {
      throw const NotesTransferException(
        NotesTransferExceptionCode.invalidPayload,
      );
    }

    try {
      return rawNotes.map((rawNote) {
        if (rawNote is! Map<String, dynamic>) {
          throw const FormatException();
        }
        return Note.fromJson(rawNote);
      }).toList();
    } catch (_) {
      throw const NotesTransferException(
        NotesTransferExceptionCode.invalidPayload,
      );
    }
  }
}
