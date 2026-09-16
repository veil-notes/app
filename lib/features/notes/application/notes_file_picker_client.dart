import 'dart:typed_data';

class NotesPickedFile {
  final Uint8List bytes;
  final String fileName;

  const NotesPickedFile({required this.bytes, required this.fileName});
}

abstract class NotesFilePickerClient {
  Future<NotesPickedFile?> pickPgpFile();

  Future<bool> savePgpFile({
    required Uint8List bytes,
    required String fileName,
  });
}
