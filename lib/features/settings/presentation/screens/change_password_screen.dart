import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_error_mapper.dart';
import '../../../../i18n/translations.g.dart';
import '../../../veil/providers/veil_provider.dart';
import 'settings_feature_scaffold.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  static const _errorMapper = AppErrorMapper();

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmationController = TextEditingController();

  String? _validationMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isLoading) {
      return;
    }

    if (_newPasswordController.text != _confirmationController.text) {
      setState(() {
        _validationMessage = context.t.veil.setup.passwordsDoNotMatch;
      });
      return;
    }

    setState(() {
      _validationMessage = null;
      _isLoading = true;
    });

    try {
      await ref
          .read(veilServiceProvider)
          .changePassword(
            _currentPasswordController.text,
            _newPasswordController.text,
          );

      ref.invalidate(isBiometricEnabledProvider);
      ref.invalidate(canUseBiometricUnlockProvider);

      if (mounted) {
        final messenger = ScaffoldMessenger.of(context);
        messenger.showSnackBar(
          SnackBar(content: Text(context.t.settings.changePassword.success)),
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
      title: t.settings.changePassword.sheetTitle,
      body: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          TextField(
            controller: _currentPasswordController,
            obscureText: true,
            autofocus: true,
            decoration: InputDecoration(
              hintText: t.settings.changePassword.currentPasswordHint,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _newPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: t.settings.changePassword.newPasswordHint,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _confirmationController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: t.settings.changePassword.confirmPasswordHint,
              errorText: _validationMessage,
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

  void _showError(Object error) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(_errorMapper.map(context.t, error))));
  }
}
