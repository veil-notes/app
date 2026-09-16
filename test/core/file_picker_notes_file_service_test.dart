import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:veil/core/app_lifecycle_lock_guard.dart';
import 'package:veil/features/notes/application/notes_file_picker_client.dart';
import 'package:veil/features/notes/domain/notes_transfer_result.dart';
import 'package:veil/features/notes/infra/file_picker_notes_file_service.dart';

void main() {
  test(
    'protects the native import picker and releases after success',
    () async {
      final guard = DefaultAppLifecycleLockGuard();
      final picker = _FakeNotesFilePickerClient();
      final service = FilePickerNotesFileService(
        pickerClient: picker,
        lifecycleLockGuard: guard,
      );

      final operation = service.pickImportFile();

      expect(guard.isActive, isTrue);
      picker.pickCompleter.complete(Uint8List.fromList('payload'.codeUnits));

      await expectLater(operation, completion('payload'));
      expect(guard.isActive, isFalse);
    },
  );

  test('releases the guard when import is cancelled', () async {
    final guard = DefaultAppLifecycleLockGuard();
    final picker = _FakeNotesFilePickerClient();
    final service = FilePickerNotesFileService(
      pickerClient: picker,
      lifecycleLockGuard: guard,
    );

    final operation = service.pickImportFile();
    picker.pickCompleter.complete();

    await expectLater(operation, completion(isNull));
    expect(guard.isActive, isFalse);
  });

  test('maps import errors and releases the guard', () async {
    final guard = DefaultAppLifecycleLockGuard();
    final picker = _FakeNotesFilePickerClient();
    final service = FilePickerNotesFileService(
      pickerClient: picker,
      lifecycleLockGuard: guard,
    );

    final operation = service.pickImportFile();
    picker.pickCompleter.completeError(StateError('failed'));

    await expectLater(
      operation,
      throwsA(
        isA<NotesTransferException>().having(
          (error) => error.code,
          'code',
          NotesTransferExceptionCode.fileOperationFailed,
        ),
      ),
    );
    expect(guard.isActive, isFalse);
  });

  test(
    'protects the native export picker and releases after cancellation',
    () async {
      final guard = DefaultAppLifecycleLockGuard();
      final picker = _FakeNotesFilePickerClient();
      final service = FilePickerNotesFileService(
        pickerClient: picker,
        lifecycleLockGuard: guard,
      );

      final operation = service.saveExportFile('payload');

      expect(guard.isActive, isTrue);
      picker.saveCompleter.complete(false);

      await expectLater(operation, completion(isFalse));
      expect(picker.savedPayload, 'payload');
      expect(guard.isActive, isFalse);
    },
  );

  test('releases the guard when export throws', () async {
    final guard = DefaultAppLifecycleLockGuard();
    final picker = _FakeNotesFilePickerClient();
    final service = FilePickerNotesFileService(
      pickerClient: picker,
      lifecycleLockGuard: guard,
    );

    final operation = service.saveExportFile('payload');
    picker.saveCompleter.completeError(StateError('failed'));

    await expectLater(operation, throwsA(isA<NotesTransferException>()));
    expect(guard.isActive, isFalse);
  });
}

class _FakeNotesFilePickerClient implements NotesFilePickerClient {
  final pickCompleter = Completer<Uint8List?>();
  final saveCompleter = Completer<bool>();
  String? savedPayload;

  @override
  Future<Uint8List?> pickPgpFile() => pickCompleter.future;

  @override
  Future<bool> savePgpFile({
    required Uint8List bytes,
    required String fileName,
  }) {
    savedPayload = String.fromCharCodes(bytes);
    return saveCompleter.future;
  }
}
