abstract class NotesFileService {
  Future<String?> pickImportFile();

  Future<bool> saveExportFile(String encryptedPayload);
}
