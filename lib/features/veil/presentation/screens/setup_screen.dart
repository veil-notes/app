import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/app_error_mapper.dart';
import '../../../../i18n/translations.g.dart';
import '../../providers/veil_provider.dart';

class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key});

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  static const _errorMapper = AppErrorMapper();

  final TextEditingController _passwordController = TextEditingController();

  bool _enableBiometricsOnboarding = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(hintText: t.veil.setup.passwordHint),
            ),
            const SizedBox(height: 24),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _enableBiometricsOnboarding,
              onChanged: _isSubmitting
                  ? null
                  : (value) {
                      setState(() => _enableBiometricsOnboarding = value);
                    },
              title: Text(t.veil.setup.biometricsOptInTitle),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submit,
              child: Text(t.veil.setup.cta),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_isSubmitting) {
      return;
    }

    setState(() => _isSubmitting = true);

    final controller = ref.read(veilControllerProvider.notifier);
    final password = _passwordController.text;

    try {
      await controller.createWithOnboardingBiometrics(
        password: password,
        enableBiometrics: _enableBiometricsOnboarding,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMapper.map(context.t, error))),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}
