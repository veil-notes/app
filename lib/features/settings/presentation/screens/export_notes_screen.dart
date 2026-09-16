import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_error_mapper.dart';
import '../../../../i18n/translations.g.dart';
import '../../../notes/providers/notes_provider.dart';
import '../../../veil/domain/password/default_password_validator.dart';
import '../../../veil/domain/states/unlocked_state.dart';
import '../../../veil/domain/veil_exception.dart';
import '../../../veil/providers/veil_provider.dart';
import 'settings_feature_scaffold.dart';

class ExportNotesScreen extends ConsumerStatefulWidget {
  const ExportNotesScreen({super.key});

  @override
  ConsumerState<ExportNotesScreen> createState() => _ExportNotesScreenState();
}

class _ExportNotesScreenState extends ConsumerState<ExportNotesScreen> {
  static const _errorMapper = AppErrorMapper();
  static final _passwordValidator = DefaultPasswordValidator();

  final _passwordController = TextEditingController();
  final _confirmationController = TextEditingController();

  String? _validationMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isLoading) {
      return;
    }

    if (_passwordController.text != _confirmationController.text) {
      setState(() {
        _validationMessage = context.t.veil.setup.passwordsDoNotMatch;
      });
      return;
    }

    final validation = _passwordValidator.validate(_passwordController.text);
    final error = validation.error;
    if (!validation.isValid && error != null) {
      setState(() {
        _validationMessage = _errorMapper.map(
          context.t,
          VeilException.passwordValidation(error),
        );
      });
      return;
    }

    setState(() {
      _validationMessage = null;
      _isLoading = true;
    });

    try {
      final export = await ref
          .read(notesTransferServiceProvider)
          .exportNotes(_passwordController.text);
      final saved = await ref
          .read(notesFileServiceProvider)
          .saveExportFile(export.encryptedPayload);

      if (!_refreshSessionAfterFilePicker()) {
        return;
      }

      if (saved && mounted) {
        final messenger = ScaffoldMessenger.of(context);
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              context.t.settings.notesTransfer.exportSuccess(
                count: export.noteCount,
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
      title: t.settings.notesTransfer.exportPassword.title,
      body: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          TextField(
            controller: _passwordController,
            obscureText: true,
            autofocus: true,
            decoration: InputDecoration(
              hintText: t.settings.notesTransfer.exportPassword.passwordHint,
              errorText: _validationMessage,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _confirmationController,
            obscureText: true,
            decoration: InputDecoration(
              hintText:
                  t.settings.notesTransfer.exportPassword.confirmPasswordHint,
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
