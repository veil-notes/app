import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_error_mapper.dart';
import '../../../../i18n/translations.g.dart';
import '../../../notes/domain/notes_import_file.dart';
import '../../../notes/providers/notes_provider.dart';
import '../../../veil/domain/states/unlocked_state.dart';
import '../../../veil/providers/veil_provider.dart';
import 'import_file_selector.dart';
import 'settings_feature_scaffold.dart';

class ImportNotesScreen extends ConsumerStatefulWidget {
  const ImportNotesScreen({super.key});

  @override
  ConsumerState<ImportNotesScreen> createState() => _ImportNotesScreenState();
}

class _ImportNotesScreenState extends ConsumerState<ImportNotesScreen> {
  static const _errorMapper = AppErrorMapper();

  final _passwordController = TextEditingController();

  NotesImportFile? _selectedFile;
  bool _isPickingFile = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    if (!mounted || _isPickingFile || _isLoading) {
      return;
    }

    setState(() => _isPickingFile = true);

    try {
      final file = await ref.read(notesFileServiceProvider).pickImportFile();

      if (!mounted || !_refreshSessionAfterFilePicker()) {
        return;
      }

      if (file != null) {
        setState(() {
          _selectedFile = file;
          _passwordController.clear();
        });
      }
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showError(error);
    } finally {
      if (mounted) {
        setState(() => _isPickingFile = false);
      }
    }
  }

  Future<void> _submit() async {
    final payload = _selectedFile?.encryptedPayload;
    if (_isLoading || payload == null) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await ref
          .read(notesTransferServiceProvider)
          .importNotes(
            encryptedPayload: payload,
            password: _passwordController.text,
          );
      ref.invalidate(notesListProvider);

      if (mounted) {
        final messenger = ScaffoldMessenger.of(context);
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              context.t.settings.notesTransfer.importSuccess(
                count: result.importedCount,
              ),
            ),
          ),
        );
        context.pop();
      }
    } catch (error) {
      _showError(error);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    return SettingsFeatureScaffold(
      title: t.settings.notesTransfer.importPassword.title,
      body: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          ImportFileSelector(
            fileName: _selectedFile?.fileName,
            isLoading: _isPickingFile,
            onTap: _pickFile,
            selectTitle: t.settings.notesTransfer.filePicker.selectTitle,
            selectSubtitle: t.settings.notesTransfer.filePicker.selectSubtitle,
            changeSubtitle: t.settings.notesTransfer.filePicker.changeSubtitle,
            loadingLabel: t.common.loading,
          ),
          if (_selectedFile != null) ...[
            const SizedBox(height: 24),
            TextField(
              controller: _passwordController,
              obscureText: true,
              autofocus: !_isPickingFile,
              decoration: InputDecoration(
                hintText: t.settings.notesTransfer.importPassword.hint,
              ),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 24),
            SettingsFeatureActionButtons(
              t: t,
              isLoading: _isLoading,
              onConfirm: _submit,
              onCancel: () => context.pop(),
            ),
          ],
        ],
      ),
    );
  }

  bool _refreshSessionAfterFilePicker() {
    if (!mounted || ref.read(veilControllerProvider) is! UnlockedState) {
      return false;
    }

    ref.read(veilSessionControllerProvider).refresh();
    return true;
  }

  void _showError(Object error) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(_errorMapper.map(context.t, error))));
  }
}
