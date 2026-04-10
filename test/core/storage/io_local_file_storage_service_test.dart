import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:veil/core/storage/infra/io_local_file_storage_service.dart';

void main() {
  late Directory tempDirectory;
  late IOLocalFileStorageService service;

  setUp(() async {
    tempDirectory = await Directory.systemTemp.createTemp('veil-storage-test');
    service = IOLocalFileStorageService(
      applicationDocumentsDirectoryResolver: () async => tempDirectory,
    );
  });

  tearDown(() async {
    if (await tempDirectory.exists()) {
      await tempDirectory.delete(recursive: true);
    }
  });

  test('writes and reads file contents from the app documents directory', () async {
    await service.write(
      directory: 'notes',
      fileName: 'alpha.txt',
      content: 'hello',
    );

    final content = await service.read(
      directory: 'notes',
      fileName: 'alpha.txt',
    );

    expect(content, 'hello');
  });

  test('returns null when the file does not exist', () async {
    final content = await service.read(
      directory: 'notes',
      fileName: 'missing.txt',
    );

    expect(content, isNull);
  });

  test('lists only file names inside the requested directory', () async {
    await service.write(
      directory: 'notes',
      fileName: 'alpha.txt',
      content: 'a',
    );
    await service.write(
      directory: 'notes',
      fileName: 'beta.txt',
      content: 'b',
    );
    await Directory('${tempDirectory.path}/notes/nested').create(recursive: true);

    final fileNames = await service.listFileNames(directory: 'notes');

    expect(fileNames, containsAll(['alpha.txt', 'beta.txt']));
    expect(fileNames, isNot(contains('nested')));
  });

  test('returns an empty list when the directory has no files yet', () async {
    final fileNames = await service.listFileNames(directory: 'empty');

    expect(fileNames, isEmpty);
  });

  test('deletes an existing file and ignores a missing one', () async {
    await service.write(
      directory: 'notes',
      fileName: 'delete-me.txt',
      content: 'bye',
    );

    await service.delete(directory: 'notes', fileName: 'delete-me.txt');
    await service.delete(directory: 'notes', fileName: 'delete-me.txt');

    final content = await service.read(
      directory: 'notes',
      fileName: 'delete-me.txt',
    );

    expect(content, isNull);
  });
}
