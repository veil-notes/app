class NoteFile {
  final String id;
  final String encryptedPayload;

  const NoteFile({
    required this.id,
    required this.encryptedPayload,
  });

  String get fileName => '$id.pgp';
}