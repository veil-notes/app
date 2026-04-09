import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../local_file_storage_service.dart';

class IOLocalFileStorageService implements LocalFileStorageService {
  @override
  Future<void> write({
    required String directory,
    required String fileName,
    required String content,
  }) async {
    final file = await _resolveFile(directory: directory, fileName: fileName);

    await file.writeAsString(content, flush: true);
  }

  @override
  Future<String?> read({
    required String directory,
    required String fileName,
  }) async {
    final file = await _resolveFile(directory: directory, fileName: fileName);

    if (!await file.exists()) {
      return null;
    }

    return file.readAsString();
  }

  @override
  Future<List<String>> listFileNames({required String directory}) async {
    final resolvedDirectory = await _resolveDirectory(directory);

    if (!await resolvedDirectory.exists()) {
      return const [];
    }

    final entities = await resolvedDirectory.list().toList();
    return entities
        .whereType<File>()
        .map((file) => file.uri.pathSegments.last)
        .toList();
  }

  @override
  Future<void> delete({
    required String directory,
    required String fileName,
  }) async {
    final file = await _resolveFile(directory: directory, fileName: fileName);

    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<Directory> _resolveDirectory(String directoryName) async {
    final appDirectory = await getApplicationDocumentsDirectory();
    final directory = Directory('${appDirectory.path}/$directoryName');

    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    return directory;
  }

  Future<File> _resolveFile({
    required String directory,
    required String fileName,
  }) async {
    final resolvedDirectory = await _resolveDirectory(directory);
    return File('${resolvedDirectory.path}/$fileName');
  }
}
