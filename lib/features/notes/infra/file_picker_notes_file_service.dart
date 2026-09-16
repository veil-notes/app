import 'dart:convert';
import 'dart:typed_data';

import '../../../core/app_lifecycle_lock_guard.dart';
import '../application/notes_file_service.dart';
import '../application/notes_file_picker_client.dart';
import '../domain/notes_import_file.dart';
import '../domain/notes_transfer_result.dart';
import 'file_picker_notes_file_picker_client.dart';

class FilePickerNotesFileService implements NotesFileService {
  static const _suggestedFileName = 'veil-notes-export.pgp';

  final NotesFilePickerClient _pickerClient;
  final AppLifecycleLockGuard _lifecycleLockGuard;

  FilePickerNotesFileService({
    NotesFilePickerClient? pickerClient,
    AppLifecycleLockGuard? lifecycleLockGuard,
  }) : _pickerClient = pickerClient ?? FilePickerNotesFilePickerClient(),
       _lifecycleLockGuard =
           lifecycleLockGuard ?? DefaultAppLifecycleLockGuard();

  @override
  Future<NotesImportFile?> pickImportFile() async {
    try {
      final pickedFile = await _lifecycleLockGuard.run(
        _pickerClient.pickPgpFile,
      );

      return pickedFile == null
          ? null
          : NotesImportFile(
              encryptedPayload: utf8.decode(pickedFile.bytes),
              fileName: pickedFile.fileName,
            );
    } catch (_) {
      throw const NotesTransferException(
        NotesTransferExceptionCode.fileOperationFailed,
      );
    }
  }

  @override
  Future<bool> saveExportFile(String encryptedPayload) async {
    try {
      return await _lifecycleLockGuard.run(
        () => _pickerClient.savePgpFile(
          bytes: Uint8List.fromList(utf8.encode(encryptedPayload)),
          fileName: _suggestedFileName,
        ),
      );
    } catch (_) {
      throw const NotesTransferException(
        NotesTransferExceptionCode.fileOperationFailed,
      );
    }
  }
}
