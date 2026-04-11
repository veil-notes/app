abstract class LocalFileStorageService {
  Future<void> write({
    required String directory,
    required String fileName,
    required String content,
  });

  Future<String?> read({required String directory, required String fileName});

  Future<List<String>> listFileNames({required String directory});

  Future<void> delete({required String directory, required String fileName});
}
