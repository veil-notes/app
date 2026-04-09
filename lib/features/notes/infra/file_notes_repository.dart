import '../../../core/storage/local_file_storage_service.dart';
import '../domain/note_file.dart';
import '../domain/notes_repository.dart';

class FileNotesRepository implements NotesRepository {
  static const _notesDirectoryName = 'notes';
  static const _fileExtension = '.pgp';

  final LocalFileStorageService _storage;

  FileNotesRepository(this._storage);

  @override
  Future<void> save(NoteFile file) {
    return _storage.write(
      directory: _notesDirectoryName,
      fileName: file.fileName,
      content: file.encryptedPayload,
    );
  }

  @override
  Future<NoteFile?> findById(String id) async {
    final fileName = _fileNameFor(id);

    final encryptedPayload = await _storage.read(
      directory: _notesDirectoryName,
      fileName: fileName,
    );

    if (encryptedPayload == null) {
      return null;
    }

    return NoteFile(id: id, encryptedPayload: encryptedPayload);
  }

  @override
  Future<List<NoteFile>> findAll() async {
    final fileNames = await _storage.listFileNames(
      directory: _notesDirectoryName,
    );

    final noteFiles = <NoteFile>[];

    for (final fileName in fileNames.where(
      (name) => name.endsWith(_fileExtension),
    )) {
      final encryptedPayload = await _storage.read(
        directory: _notesDirectoryName,
        fileName: fileName,
      );

      if (encryptedPayload == null) {
        continue;
      }

      final id = fileName.replaceFirst(_fileExtension, '');

      noteFiles.add(NoteFile(id: id, encryptedPayload: encryptedPayload));
    }

    return noteFiles;
  }

  @override
  Future<void> delete(String id) {
    return _storage.delete(
      directory: _notesDirectoryName,
      fileName: _fileNameFor(id),
    );
  }

  String _fileNameFor(String id) => '$id$_fileExtension';
}
