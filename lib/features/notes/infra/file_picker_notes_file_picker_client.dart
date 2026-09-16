import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

import '../application/notes_file_picker_client.dart';

class FilePickerNotesFilePickerClient implements NotesFilePickerClient {
  @override
  Future<Uint8List?> pickPgpFile() async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['pgp'],
    );

    if (file == null) {
      return null;
    }

    return file.readAsBytes();
  }

  @override
  Future<bool> savePgpFile({
    required Uint8List bytes,
    required String fileName,
  }) async {
    final uri = await FilePicker.saveFile(
      fileName: fileName,
      bytes: bytes,
      mimeType: 'application/pgp-encrypted',
      type: FileType.custom,
      allowedExtensions: ['pgp'],
    );

    return uri != null;
  }
}
