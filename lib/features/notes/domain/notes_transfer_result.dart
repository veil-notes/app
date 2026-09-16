class NotesExport {
  final String encryptedPayload;
  final int noteCount;

  const NotesExport({required this.encryptedPayload, required this.noteCount});
}

class NotesImportResult {
  final int importedCount;
  final int conflictCount;

  const NotesImportResult({
    required this.importedCount,
    required this.conflictCount,
  });
}

enum NotesTransferExceptionCode {
  invalidFileOrPassword,
  unsupportedFormatVersion,
  invalidPayload,
  fileOperationFailed,
}

class NotesTransferException implements Exception {
  final NotesTransferExceptionCode code;

  const NotesTransferException(this.code);

  @override
  String toString() => 'NotesTransferException(code: $code)';
}
