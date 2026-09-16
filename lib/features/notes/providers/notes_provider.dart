import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/infra/io_local_file_storage_service.dart';
import '../../../core/storage/local_file_storage_service.dart';
import '../../veil/providers/veil_provider.dart';
import '../application/notes_service.dart';
import '../application/notes_file_service.dart';
import '../application/notes_file_picker_client.dart';
import '../application/notes_transfer_service.dart';
import '../domain/note.dart';
import '../domain/notes_repository.dart';
import '../infra/file_notes_repository.dart';
import '../infra/file_picker_notes_file_picker_client.dart';
import '../infra/file_picker_notes_file_service.dart';
import '../infra/pgp_notes_service.dart';
import '../infra/pgp_notes_transfer_service.dart';
import '../../veil/domain/password/default_password_validator.dart';

final localFileStorageServiceProvider = Provider<LocalFileStorageService>((
  ref,
) {
  return IOLocalFileStorageService();
});

final notesRepositoryProvider = Provider<NotesRepository>((ref) {
  final storage = ref.read(localFileStorageServiceProvider);
  return FileNotesRepository(storage);
});

final notesServiceProvider = Provider<NotesService>((ref) {
  final repository = ref.read(notesRepositoryProvider);
  final cryptoService = ref.read(cryptoServiceProvider);
  final vaultKeyProvider = ref.read(vaultKeyProviderProvider);

  return PgpNotesService(
    repository: repository,
    cryptoService: cryptoService,
    vaultKeyProvider: vaultKeyProvider,
  );
});

final notesTransferServiceProvider = Provider<NotesTransferService>((ref) {
  return PgpNotesTransferService(
    notesService: ref.read(notesServiceProvider),
    repository: ref.read(notesRepositoryProvider),
    cryptoService: ref.read(cryptoServiceProvider),
    vaultKeyProvider: ref.read(vaultKeyProviderProvider),
    passwordValidator: DefaultPasswordValidator(),
  );
});

final notesFileServiceProvider = Provider<NotesFileService>((ref) {
  return FilePickerNotesFileService(
    pickerClient: ref.read(notesFilePickerClientProvider),
    lifecycleLockGuard: ref.read(appLifecycleLockGuardProvider),
  );
});

final notesFilePickerClientProvider = Provider<NotesFilePickerClient>((ref) {
  return FilePickerNotesFilePickerClient();
});

final noteProvider = FutureProvider.autoDispose.family<Note, String?>((
  ref,
  id,
) async {
  final notesService = ref.read(notesServiceProvider);

  if (id == null) {
    return notesService.createEmpty();
  }

  return notesService.open(id);
});

final notesListProvider = FutureProvider<List<Note>>((ref) async {
  final notesService = ref.read(notesServiceProvider);
  return notesService.list();
});
