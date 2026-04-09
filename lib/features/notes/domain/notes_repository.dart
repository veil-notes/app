import 'note_file.dart';

abstract class NotesRepository {
  Future<void> save(NoteFile file);
  Future<NoteFile?> findById(String id);
  Future<List<NoteFile>> findAll();
  Future<void> delete(String id);
}
