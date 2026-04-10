import 'package:flutter_test/flutter_test.dart';
import 'package:veil/core/storage/local_file_storage_service.dart';
import 'package:veil/features/notes/domain/note_file.dart';
import 'package:veil/features/notes/infra/file_notes_repository.dart';

void main() {
  group('FileNotesRepository', () {
    test('saves encrypted payloads in the notes directory', () async {
      final storage = _FakeLocalFileStorageService();
      final repository = FileNotesRepository(storage);

      await repository.save(
        const NoteFile(id: 'note-1', encryptedPayload: 'encrypted'),
      );

      expect(storage.writes, hasLength(1));
      expect(storage.writes.single.directory, 'notes');
      expect(storage.writes.single.fileName, 'note-1.pgp');
      expect(storage.writes.single.content, 'encrypted');
    });

    test('finds files by id and returns null when missing', () async {
      final storage = _FakeLocalFileStorageService(
        files: {'notes/note-1.pgp': 'encrypted'},
      );
      final repository = FileNotesRepository(storage);

      final found = await repository.findById('note-1');
      final missing = await repository.findById('missing');

      expect(found, isNotNull);
      expect(found!.id, 'note-1');
      expect(found.encryptedPayload, 'encrypted');
      expect(missing, isNull);
    });

    test('lists only pgp files that can be read', () async {
      final storage = _FakeLocalFileStorageService(
        files: {
          'notes/one.pgp': 'payload-1',
          'notes/two.pgp': 'payload-2',
          'notes/missing.pgp': null,
          'notes/readme.txt': 'ignore',
        },
      );
      final repository = FileNotesRepository(storage);

      final files = await repository.findAll();

      expect(files, hasLength(2));
      expect(files.map((file) => file.id), containsAll(['one', 'two']));
    });

    test('deletes pgp files by derived file name', () async {
      final storage = _FakeLocalFileStorageService();
      final repository = FileNotesRepository(storage);

      await repository.delete('note-1');

      expect(storage.deletes, hasLength(1));
      expect(storage.deletes.single.directory, 'notes');
      expect(storage.deletes.single.fileName, 'note-1.pgp');
    });
  });
}

class _FakeLocalFileStorageService implements LocalFileStorageService {
  final Map<String, String?> files;
  final List<_WriteCall> writes = [];
  final List<_DeleteCall> deletes = [];

  _FakeLocalFileStorageService({Map<String, String?>? files})
    : files = files ?? {};

  @override
  Future<void> write({
    required String directory,
    required String fileName,
    required String content,
  }) async {
    writes.add(_WriteCall(directory, fileName, content));
    files['$directory/$fileName'] = content;
  }

  @override
  Future<String?> read({
    required String directory,
    required String fileName,
  }) async {
    return files['$directory/$fileName'];
  }

  @override
  Future<List<String>> listFileNames({required String directory}) async {
    return files.keys
        .where((path) => path.startsWith('$directory/'))
        .map((path) => path.substring(directory.length + 1))
        .toList();
  }

  @override
  Future<void> delete({
    required String directory,
    required String fileName,
  }) async {
    deletes.add(_DeleteCall(directory, fileName));
    files.remove('$directory/$fileName');
  }
}

class _WriteCall {
  final String directory;
  final String fileName;
  final String content;

  _WriteCall(this.directory, this.fileName, this.content);
}

class _DeleteCall {
  final String directory;
  final String fileName;

  _DeleteCall(this.directory, this.fileName);
}
