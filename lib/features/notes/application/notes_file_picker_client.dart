import 'dart:typed_data';

abstract class NotesFilePickerClient {
  Future<Uint8List?> pickPgpFile();

  Future<bool> savePgpFile({
    required Uint8List bytes,
    required String fileName,
  });
}
