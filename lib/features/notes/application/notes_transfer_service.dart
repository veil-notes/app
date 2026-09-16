import '../domain/notes_transfer_result.dart';

abstract class NotesTransferService {
  Future<NotesExport> exportNotes(String password);

  Future<NotesImportResult> importNotes({
    required String encryptedPayload,
    required String password,
  });
}
