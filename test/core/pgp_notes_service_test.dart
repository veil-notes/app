import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/data.dart';
import 'package:uuid/uuid.dart';
import 'package:veil/core/crypto/crypto_service.dart';
import 'package:veil/core/crypto/domain/crypto_key_pair.dart';
import 'package:veil/core/crypto/domain/encrypted_data.dart';
import 'package:veil/features/notes/domain/note.dart';
import 'package:veil/features/notes/domain/note_file.dart';
import 'package:veil/features/notes/domain/notes_repository.dart';
import 'package:veil/features/notes/infra/pgp_notes_service.dart';
import 'package:veil/features/veil/domain/vault_key_provider.dart';

void main() {
  final createdAt = DateTime(2026, 4, 10, 9, 0);
  final updatedAt = DateTime(2026, 4, 10, 9, 30);

  group('PgpNotesService', () {
    test('creates an empty note with a generated id', () async {
      final service = PgpNotesService(
        repository: _FakeNotesRepository(),
        cryptoService: _FakeCryptoService(),
        vaultKeyProvider: _FakeVaultKeyProvider(),
        uuid: const _FixedUuid('generated-id'),
      );

      final note = await service.createEmpty();

      expect(note.id, 'generated-id');
      expect(note.content, '');
      expect(note.createdAt, isNotNull);
      expect(note.updatedAt, isNotNull);
    });

    test('encrypts and saves note payloads', () async {
      final repository = _FakeNotesRepository();
      final crypto = _FakeCryptoService();
      final keys = _FakeVaultKeyProvider();
      final service = PgpNotesService(
        repository: repository,
        cryptoService: crypto,
        vaultKeyProvider: keys,
      );

      final note = Note(
        id: 'note-1',
        content: 'Body',
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      await service.save(note);

      expect(crypto.lastEncryptedPlainText, jsonEncode(note.toJson()));
      expect(crypto.lastEncryptPublicKey, 'public-key');
      expect(repository.savedFiles.single.id, 'note-1');
      expect(repository.savedFiles.single.encryptedPayload, startsWith('enc:'));
    });

    test('opens and decrypts a stored note', () async {
      final note = Note(
        id: 'note-1',
        content: 'Body',
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
      final repository = _FakeNotesRepository(
        storedFile: NoteFile(
          id: 'note-1',
          encryptedPayload: 'enc:${jsonEncode(note.toJson())}',
        ),
      );
      final crypto = _FakeCryptoService();
      final keys = _FakeVaultKeyProvider();
      final service = PgpNotesService(
        repository: repository,
        cryptoService: crypto,
        vaultKeyProvider: keys,
      );

      final opened = await service.open('note-1');

      expect(opened.id, note.id);
      expect(opened.content, note.content);
      expect(crypto.lastDecryptPrivateKey, 'private-key');
      expect(
        crypto.lastDecryptedPayload,
        repository.storedFile!.encryptedPayload,
      );
    });

    test('throws when opening a missing note', () async {
      final service = PgpNotesService(
        repository: _FakeNotesRepository(),
        cryptoService: _FakeCryptoService(),
        vaultKeyProvider: _FakeVaultKeyProvider(),
      );

      await expectLater(() => service.open('missing'), throwsException);
    });

    test('lists decrypted notes sorted by updatedAt descending', () async {
      final older = Note(
        id: 'older',
        content: 'Older',
        createdAt: createdAt,
        updatedAt: DateTime(2026, 4, 10, 9, 0),
      );
      final newer = Note(
        id: 'newer',
        content: 'Newer',
        createdAt: createdAt,
        updatedAt: DateTime(2026, 4, 10, 10, 0),
      );
      final repository = _FakeNotesRepository(
        files: [
          NoteFile(
            id: older.id,
            encryptedPayload: 'enc:${jsonEncode(older.toJson())}',
          ),
          NoteFile(
            id: newer.id,
            encryptedPayload: 'enc:${jsonEncode(newer.toJson())}',
          ),
        ],
      );
      final service = PgpNotesService(
        repository: repository,
        cryptoService: _FakeCryptoService(),
        vaultKeyProvider: _FakeVaultKeyProvider(),
      );

      final notes = await service.list();

      expect(notes.map((note) => note.id).toList(), ['newer', 'older']);
    });

    test('delegates delete to the repository', () async {
      final repository = _FakeNotesRepository();
      final service = PgpNotesService(
        repository: repository,
        cryptoService: _FakeCryptoService(),
        vaultKeyProvider: _FakeVaultKeyProvider(),
      );

      await service.delete('note-1');

      expect(repository.deletedIds, ['note-1']);
    });
  });
}

class _FakeNotesRepository implements NotesRepository {
  final List<NoteFile> savedFiles = [];
  final List<String> deletedIds = [];
  final List<NoteFile> files;
  final NoteFile? storedFile;

  _FakeNotesRepository({this.storedFile, List<NoteFile>? files})
    : files = files ?? const [];

  @override
  Future<void> save(NoteFile file) async {
    savedFiles.add(file);
  }

  @override
  Future<NoteFile?> findById(String id) async {
    if (storedFile != null && storedFile!.id == id) {
      return storedFile;
    }

    return null;
  }

  @override
  Future<List<NoteFile>> findAll() async => files;

  @override
  Future<void> delete(String id) async {
    deletedIds.add(id);
  }
}

class _FakeCryptoService implements CryptoService {
  String? lastEncryptedPlainText;
  String? lastEncryptPublicKey;
  String? lastDecryptedPayload;
  String? lastDecryptPrivateKey;

  @override
  Future<CryptoKeyPair> generateKeys() {
    throw UnimplementedError();
  }

  @override
  Future<EncryptedData> encrypt(String plainText, String publicKey) async {
    lastEncryptedPlainText = plainText;
    lastEncryptPublicKey = publicKey;
    return EncryptedData('enc:$plainText');
  }

  @override
  Future<EncryptedData> encryptSymmetric(String plainText, String passphrase) {
    throw UnimplementedError();
  }

  @override
  Future<String> decrypt(EncryptedData data, String privateKey) async {
    lastDecryptedPayload = data.payload;
    lastDecryptPrivateKey = privateKey;
    return data.payload.replaceFirst('enc:', '');
  }

  @override
  Future<String> decryptSymmetric(EncryptedData data, String passphrase) {
    throw UnimplementedError();
  }
}

class _FakeVaultKeyProvider implements VaultKeyProvider {
  @override
  Future<String> getPublicKey() async => 'public-key';

  @override
  Future<String> getUnlockedPrivateKey() async => 'private-key';
}

class _FixedUuid extends Uuid {
  final String value;

  const _FixedUuid(this.value);

  @override
  String v7({V7Options? config}) => value;
}
