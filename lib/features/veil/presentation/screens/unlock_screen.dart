import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/app_error_mapper.dart';
import '../../../../i18n/translations.g.dart';
import '../../application/veil_controller.dart';
import '../../providers/veil_provider.dart';

class UnlockScreen extends ConsumerStatefulWidget {
  const UnlockScreen({super.key});

  @override
  ConsumerState<UnlockScreen> createState() => _UnlockScreenState();
}

class _UnlockScreenState extends ConsumerState<UnlockScreen> {
  static const _errorMapper = AppErrorMapper();

  final TextEditingController _passwordController = TextEditingController();

  ProviderSubscription<AsyncValue<bool>>? _biometricSubscription;
  bool _autoBiometricTriggered = false;

  @override
  void initState() {
    super.initState();

    _biometricSubscription = ref.listenManual<AsyncValue<bool>>(
      canUseBiometricUnlockProvider,
      (_, next) {
        next.whenData((enabled) {
          if (!enabled || _autoBiometricTriggered || !mounted) {
            return;
          }

          _autoBiometricTriggered = true;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) {
              return;
            }

            final controller = ref.read(veilControllerProvider.notifier);
            _unlockWithBiometrics(controller);
          });
        });
      },
    );
  }

  @override
  void dispose() {
    _biometricSubscription?.close();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(veilControllerProvider.notifier);
    final canUseBiometrics = ref.watch(canUseBiometricUnlockProvider);
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
              decoration: InputDecoration(hintText: t.veil.unlock.passwordHint),
              onSubmitted: (_) => _unlock(controller),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _unlock(controller),
                child: Text(t.veil.unlock.cta),
              ),
            ),
            const SizedBox(height: 48),
            canUseBiometrics.when(
              data: (enabled) {
                if (!enabled) {
                  return const SizedBox.shrink();
                }

                return IconButton(
                  icon: const Icon(Icons.fingerprint),
                  iconSize: 46,
                  tooltip: t.veil.unlock.biometricTooltip,
                  onPressed: () => _unlockWithBiometrics(controller),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _unlock(VeilController controller) async {
    try {
      await controller.unlock(_passwordController.text);
    } catch (error) {
      if (!mounted) {
        return;
      }
      _showError(error);
    }
  }

  Future<void> _unlockWithBiometrics(VeilController controller) async {
    try {
      await controller.unlockWithBiometrics();
    } catch (error) {
      if (!mounted) {
        return;
      }
      _showError(error);
    }
  }

  void _showError(Object error) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(_errorMapper.map(context.t, error))));
  }
}
