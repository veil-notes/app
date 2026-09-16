import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/data.dart';
import 'package:uuid/uuid.dart';
import 'package:veil/core/crypto/crypto_service.dart';
import 'package:veil/core/crypto/domain/crypto_key_pair.dart';
import 'package:veil/core/crypto/domain/encrypted_data.dart';
import 'package:veil/features/notes/application/notes_service.dart';
import 'package:veil/features/notes/domain/note.dart';
import 'package:veil/features/notes/domain/note_file.dart';
import 'package:veil/features/notes/domain/notes_repository.dart';
import 'package:veil/features/notes/domain/notes_transfer_result.dart';
import 'package:veil/features/notes/infra/pgp_notes_transfer_service.dart';
import 'package:veil/features/veil/domain/password/default_password_validator.dart';
import 'package:veil/features/veil/domain/veil_exception.dart';
import 'package:veil/features/veil/domain/vault_key_provider.dart';

void main() {
  final note = Note(
    id: 'note-1',
    content: '# A note',
    createdAt: DateTime(2026, 4, 10, 9),
    updatedAt: DateTime(2026, 4, 10, 9, 30),
  );

  group('PgpNotesTransferService', () {
    test('exports a versioned encrypted envelope', () async {
      final crypto = _FakeCryptoService();
      final service = _buildService(notes: [note], crypto: crypto);

      final result = await service.exportNotes('ExportPass1!');

      expect(result.noteCount, 1);
      expect(result.encryptedPayload, startsWith('symmetric:'));
      expect(crypto.symmetricPassphrase, 'ExportPass1!');
      expect(jsonDecode(crypto.symmetricPlainText!)['formatVersion'], 1);
      expect(
        (jsonDecode(crypto.symmetricPlainText!)['notes'] as List).single,
        note.toJson(),
      );
    });

    test('exports an empty notes list', () async {
      final crypto = _FakeCryptoService();
      final service = _buildService(crypto: crypto);

      final result = await service.exportNotes('ExportPass1!');

      expect(result.noteCount, 0);
      expect(jsonDecode(crypto.symmetricPlainText!)['notes'], isEmpty);
    });

    test('rejects an export password that does not meet vault rules', () async {
      final crypto = _FakeCryptoService();
      final service = _buildService(crypto: crypto);

      await expectLater(
        () => service.exportNotes('weak'),
        throwsA(
          isA<VeilException>().having(
            (error) => error.code,
            'code',
            VeilExceptionCode.passwordValidation,
          ),
        ),
      );
      expect(crypto.symmetricPlainText, isNull);
    });

    test('imports notes while preserving content and timestamps', () async {
      final repository = _FakeNotesRepository();
      final crypto = _FakeCryptoService(symmetricPlainText: _envelope([note]));
      final service = _buildService(repository: repository, crypto: crypto);

      final result = await service.importNotes(
        encryptedPayload: 'file',
        password: 'file-password',
      );

      expect(result.importedCount, 1);
      expect(result.conflictCount, 0);
      expect(repository.savedFiles.single.id, note.id);
      expect(
        jsonDecode(repository.savedFiles.single.encryptedPayload)['content'],
        note.content,
      );
      expect(
        jsonDecode(repository.savedFiles.single.encryptedPayload)['createdAt'],
        note.createdAt.toIso8601String(),
      );
      expect(crypto.lastPublicKey, 'public-key');
    });

    test('assigns new ids for existing and repeated ids', () async {
      final duplicate = note.copyWith(content: 'duplicate');
      final repository = _FakeNotesRepository(
        files: [const NoteFile(id: 'note-1', encryptedPayload: 'stored')],
      );
      final crypto = _FakeCryptoService(
        symmetricPlainText: _envelope([note, duplicate]),
      );
      final service = _buildService(
        repository: repository,
        crypto: crypto,
        uuid: _FixedUuid(['new-id-1', 'new-id-2']),
      );

      final result = await service.importNotes(
        encryptedPayload: 'file',
        password: 'file-password',
      );

      expect(result.importedCount, 2);
      expect(result.conflictCount, 2);
      expect(repository.savedFiles.map((file) => file.id), [
        'new-id-1',
        'new-id-2',
      ]);
    });

    test('does not write anything when a note is invalid', () async {
      final repository = _FakeNotesRepository();
      final crypto = _FakeCryptoService(
        symmetricPlainText: jsonEncode({
          'formatVersion': 1,
          'notes': [
            note.toJson(),
            {'id': 'missing-fields'},
          ],
        }),
      );
      final service = _buildService(repository: repository, crypto: crypto);

      await expectLater(
        () => service.importNotes(
          encryptedPayload: 'file',
          password: 'file-password',
        ),
        throwsA(
          isA<NotesTransferException>().having(
            (error) => error.code,
            'code',
            NotesTransferExceptionCode.invalidPayload,
          ),
        ),
      );
      expect(repository.savedFiles, isEmpty);
    });

    test('rejects unsupported envelope versions before writing', () async {
      final repository = _FakeNotesRepository();
      final crypto = _FakeCryptoService(
        symmetricPlainText: jsonEncode({
          'formatVersion': 2,
          'notes': [note.toJson()],
        }),
      );
      final service = _buildService(repository: repository, crypto: crypto);

      await expectLater(
        () => service.importNotes(
          encryptedPayload: 'file',
          password: 'file-password',
        ),
        throwsA(
          isA<NotesTransferException>().having(
            (error) => error.code,
            'code',
            NotesTransferExceptionCode.unsupportedFormatVersion,
          ),
        ),
      );
      expect(repository.savedFiles, isEmpty);
    });

    test(
      'maps symmetric decryption failures to an invalid file error',
      () async {
        final service = _buildService(
          crypto: _FakeCryptoService(throwOnSymmetricDecrypt: true),
        );

        await expectLater(
          () => service.importNotes(
            encryptedPayload: 'file',
            password: 'wrong-password',
          ),
          throwsA(
            isA<NotesTransferException>().having(
              (error) => error.code,
              'code',
              NotesTransferExceptionCode.invalidFileOrPassword,
            ),
          ),
        );
      },
    );

    test('rolls back imported files when persistence fails', () async {
      final repository = _FakeNotesRepository(failOnSaveId: 'second');
      final second = note.copyWith(id: 'second', content: 'Second');
      final crypto = _FakeCryptoService(
        symmetricPlainText: _envelope([note, second]),
      );
      final service = _buildService(repository: repository, crypto: crypto);

      await expectLater(
        () => service.importNotes(
          encryptedPayload: 'file',
          password: 'file-password',
        ),
        throwsException,
      );

      expect(repository.savedFiles, isEmpty);
      expect(repository.deletedIds, ['second', 'note-1']);
    });
  });
}

PgpNotesTransferService _buildService({
  List<Note>? notes,
  _FakeNotesRepository? repository,
  _FakeCryptoService? crypto,
  Uuid? uuid,
}) {
  final resolvedRepository = repository ?? _FakeNotesRepository();
  final resolvedCrypto = crypto ?? _FakeCryptoService();

  return PgpNotesTransferService(
    notesService: _FakeNotesService(notes ?? const []),
    repository: resolvedRepository,
    cryptoService: resolvedCrypto,
    vaultKeyProvider: _FakeVaultKeyProvider(),
    passwordValidator: DefaultPasswordValidator(),
    uuid: uuid,
  );
}

String _envelope(List<Note> notes) {
  return jsonEncode({
    'formatVersion': 1,
    'notes': notes.map((note) => note.toJson()).toList(),
  });
}

class _FakeNotesService implements NotesService {
  final List<Note> notes;

  _FakeNotesService(this.notes);

  @override
  Future<Note> createEmpty() => throw UnimplementedError();

  @override
  Future<void> delete(String id) => throw UnimplementedError();

  @override
  Future<List<Note>> list() async => notes;

  @override
  Future<Note> open(String id) => throw UnimplementedError();

  @override
  Future<void> save(Note note) => throw UnimplementedError();
}

class _FakeNotesRepository implements NotesRepository {
  final List<NoteFile> files;
  final String? failOnSaveId;
  final List<NoteFile> savedFiles = [];
  final List<String> deletedIds = [];

  _FakeNotesRepository({List<NoteFile>? files, this.failOnSaveId})
    : files = [...?files];

  @override
  Future<void> delete(String id) async {
    deletedIds.add(id);
    savedFiles.removeWhere((file) => file.id == id);
  }

  @override
  Future<List<NoteFile>> findAll() async => files;

  @override
  Future<NoteFile?> findById(String id) async => null;

  @override
  Future<void> save(NoteFile file) async {
    savedFiles.add(file);
    if (file.id == failOnSaveId) {
      throw Exception('write failed');
    }
  }
}

class _FakeCryptoService implements CryptoService {
  final String? symmetricDecryptedPlainText;
  final bool throwOnSymmetricDecrypt;
  String? symmetricPlainText;
  String? symmetricPassphrase;
  String? lastPublicKey;

  _FakeCryptoService({
    String? symmetricPlainText,
    this.throwOnSymmetricDecrypt = false,
  }) : symmetricDecryptedPlainText = symmetricPlainText;

  @override
  Future<CryptoKeyPair> generateKeys() => throw UnimplementedError();

  @override
  Future<EncryptedData> encrypt(String plainText, String publicKey) async {
    lastPublicKey = publicKey;
    return EncryptedData(plainText);
  }

  @override
  Future<EncryptedData> encryptSymmetric(
    String plainText,
    String passphrase,
  ) async {
    symmetricPlainText = plainText;
    symmetricPassphrase = passphrase;
    return EncryptedData('symmetric:$plainText');
  }

  @override
  Future<String> decrypt(EncryptedData data, String privateKey) =>
      throw UnimplementedError();

  @override
  Future<String> decryptSymmetric(EncryptedData data, String passphrase) async {
    if (throwOnSymmetricDecrypt) {
      throw Exception('wrong password');
    }
    return symmetricDecryptedPlainText!;
  }
}

class _FakeVaultKeyProvider implements VaultKeyProvider {
  @override
  Future<String> getPublicKey() async => 'public-key';

  @override
  Future<String> getUnlockedPrivateKey() => throw UnimplementedError();
}

class _FixedUuid extends Uuid {
  final List<String> values;
  int _index = 0;

  _FixedUuid(this.values);

  @override
  String v7({V7Options? config}) => values[_index++];
}
