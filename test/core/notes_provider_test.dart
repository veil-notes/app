import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veil/core/crypto/crypto_service.dart';
import 'package:veil/core/crypto/domain/crypto_key_pair.dart';
import 'package:veil/core/crypto/domain/encrypted_data.dart';
import 'package:veil/core/storage/local_file_storage_service.dart';
import 'package:veil/features/notes/application/notes_service.dart';
import 'package:veil/features/notes/domain/note.dart';
import 'package:veil/features/notes/domain/note_file.dart';
import 'package:veil/features/notes/domain/notes_repository.dart';
import 'package:veil/features/notes/infra/file_notes_repository.dart';
import 'package:veil/features/notes/infra/pgp_notes_service.dart';
import 'package:veil/features/notes/providers/notes_provider.dart';
import 'package:veil/features/veil/domain/vault_key_provider.dart';
import 'package:veil/features/veil/providers/veil_provider.dart';

void main() {
  group('notes providers', () {
    test('localFileStorageServiceProvider exposes IO implementation', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final service = container.read(localFileStorageServiceProvider);

      expect(service, isNotNull);
    });

    test('notesRepositoryProvider builds a FileNotesRepository', () {
      final container = ProviderContainer(
        overrides: [
          localFileStorageServiceProvider.overrideWithValue(
            _FakeLocalFileStorageService(),
          ),
        ],
      );
      addTearDown(container.dispose);

      final repository = container.read(notesRepositoryProvider);

      expect(repository, isA<FileNotesRepository>());
    });

    test('notesServiceProvider builds a PgpNotesService', () {
      final container = ProviderContainer(
        overrides: [
          notesRepositoryProvider.overrideWithValue(_FakeNotesRepository()),
          cryptoServiceProvider.overrideWithValue(_FakeCryptoService()),
          vaultKeyProviderProvider.overrideWithValue(_FakeVaultKeyProvider()),
        ],
      );
      addTearDown(container.dispose);

      final service = container.read(notesServiceProvider);

      expect(service, isA<PgpNotesService>());
    });

    test('noteProvider creates an empty note when id is null', () async {
      final notesService = _FakeNotesService();
      final container = ProviderContainer(
        overrides: [
          notesServiceProvider.overrideWithValue(notesService),
        ],
      );
      addTearDown(container.dispose);

      final note = await container.read(noteProvider(null).future);

      expect(note.id, 'new-note');
      expect(notesService.createEmptyCalls, 1);
      expect(notesService.openedIds, isEmpty);
    });

    test('noteProvider opens a note when id is provided', () async {
      final notesService = _FakeNotesService();
      final container = ProviderContainer(
        overrides: [
          notesServiceProvider.overrideWithValue(notesService),
        ],
      );
      addTearDown(container.dispose);

      final note = await container.read(noteProvider('note-1').future);

      expect(note.id, 'note-1');
      expect(notesService.openedIds, ['note-1']);
    });

    test('notesListProvider lists notes from the service', () async {
      final notesService = _FakeNotesService();
      final container = ProviderContainer(
        overrides: [
          notesServiceProvider.overrideWithValue(notesService),
        ],
      );
      addTearDown(container.dispose);

      final notes = await container.read(notesListProvider.future);

      expect(notes, hasLength(2));
      expect(notesService.listCalls, 1);
    });
  });
}

class _FakeNotesService implements NotesService {
  int createEmptyCalls = 0;
  int listCalls = 0;
  final List<String> openedIds = [];

  @override
  Future<Note> createEmpty() async {
    createEmptyCalls++;
    return Note(
      id: 'new-note',
      content: '',
      createdAt: DateTime(2026, 4, 10, 9, 0),
      updatedAt: DateTime(2026, 4, 10, 9, 0),
    );
  }

  @override
  Future<void> delete(String id) async {}

  @override
  Future<List<Note>> list() async {
    listCalls++;
    return [
      Note(
        id: 'note-1',
        content: 'First',
        createdAt: DateTime(2026, 4, 10, 9, 0),
        updatedAt: DateTime(2026, 4, 10, 9, 0),
      ),
      Note(
        id: 'note-2',
        content: 'Second',
        createdAt: DateTime(2026, 4, 10, 9, 0),
        updatedAt: DateTime(2026, 4, 10, 9, 0),
      ),
    ];
  }

  @override
  Future<Note> open(String id) async {
    openedIds.add(id);
    return Note(
      id: id,
      content: 'Opened',
      createdAt: DateTime(2026, 4, 10, 9, 0),
      updatedAt: DateTime(2026, 4, 10, 9, 0),
    );
  }

  @override
  Future<void> save(Note note) async {}
}

class _FakeLocalFileStorageService implements LocalFileStorageService {
  @override
  Future<void> delete({
    required String directory,
    required String fileName,
  }) async {}

  @override
  Future<List<String>> listFileNames({required String directory}) async => [];

  @override
  Future<String?> read({
    required String directory,
    required String fileName,
  }) async => null;

  @override
  Future<void> write({
    required String directory,
    required String fileName,
    required String content,
  }) async {}
}

class _FakeNotesRepository implements NotesRepository {
  @override
  Future<void> delete(String id) async {}

  @override
  Future<List<NoteFile>> findAll() async => [];

  @override
  Future<NoteFile?> findById(String id) async => null;

  @override
  Future<void> save(NoteFile file) async {}
}

class _FakeCryptoService implements CryptoService {
  @override
  Future<CryptoKeyPair> generateKeys() {
    throw UnimplementedError();
  }

  @override
  Future<EncryptedData> encrypt(String plainText, String publicKey) {
    throw UnimplementedError();
  }

  @override
  Future<EncryptedData> encryptSymmetric(String plainText, String passphrase) {
    throw UnimplementedError();
  }

  @override
  Future<String> decrypt(EncryptedData data, String privateKey) {
    throw UnimplementedError();
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
