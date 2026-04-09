import '../domain/note.dart';

abstract class NotesService {
  Future<Note> createEmpty();
  Future<Note> open(String id);
  Future<List<Note>> list();
  Future<void> save(Note note);
  Future<void> delete(String id);
}
