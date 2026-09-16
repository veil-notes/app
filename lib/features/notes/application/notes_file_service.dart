import '../domain/notes_import_file.dart';

abstract class NotesFileService {
  Future<NotesImportFile?> pickImportFile();

  Future<bool> saveExportFile(String encryptedPayload);
}
