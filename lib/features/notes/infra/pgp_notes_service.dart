import 'dart:convert';

import 'package:uuid/uuid.dart';
import 'package:veil/core/crypto/crypto_service.dart';
import 'package:veil/core/crypto/domain/encrypted_data.dart';
import 'package:veil/features/notes/application/notes_service.dart';
import 'package:veil/features/notes/domain/note.dart';
import 'package:veil/features/notes/domain/note_file.dart';
import 'package:veil/features/notes/domain/notes_repository.dart';
import 'package:veil/features/veil/domain/vault_key_provider.dart';

class PgpNotesService implements NotesService {
  final NotesRepository _repository;
  final CryptoService _cryptoService;
  final VaultKeyProvider _vaultKeyProvider;
  final Uuid _uuid;

  PgpNotesService({
    required NotesRepository repository,
    required CryptoService cryptoService,
    required VaultKeyProvider vaultKeyProvider,
    Uuid? uuid,
  }) : _repository = repository,
       _cryptoService = cryptoService,
       _vaultKeyProvider = vaultKeyProvider,
       _uuid = uuid ?? const Uuid();

  @override
  Future<Note> createEmpty() async {
    final now = DateTime.now();

    return Note(id: _uuid.v7(), content: '', createdAt: now, updatedAt: now);
  }

  @override
  Future<void> save(Note note) async {
    final publicKey = await _vaultKeyProvider.getPublicKey();
    final payload = jsonEncode(note.toJson());

    final encrypted = await _cryptoService.encrypt(payload, publicKey);

    await _repository.save(
      NoteFile(id: note.id, encryptedPayload: encrypted.payload),
    );
  }

  @override
  Future<Note> open(String id) async {
    final file = await _repository.findById(id);
    if (file == null) {
      throw Exception('Note not found.');
    }

    final privateKey = await _vaultKeyProvider.getUnlockedPrivateKey();
    final payload = await _cryptoService.decrypt(
      EncryptedData(file.encryptedPayload),
      privateKey,
    );

    final json = jsonDecode(payload) as Map<String, dynamic>;
    return Note.fromJson(json);
  }

  @override
  Future<List<Note>> list() async {
    final files = await _repository.findAll();
    final privateKey = await _vaultKeyProvider.getUnlockedPrivateKey();

    final notes = <Note>[];

    for (final file in files) {
      final payload = await _cryptoService.decrypt(
        EncryptedData(file.encryptedPayload),
        privateKey,
      );

      final json = jsonDecode(payload) as Map<String, dynamic>;
      notes.add(Note.fromJson(json));
    }

    notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return notes;
  }

  @override
  Future<void> delete(String id) {
    return _repository.delete(id);
  }
}
