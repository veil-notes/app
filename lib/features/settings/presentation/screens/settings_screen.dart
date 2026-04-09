import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../veil/domain/biometrics/biometric_auth_exception.dart';
import '../../../veil/domain/session/auto_lock_option.dart';
import '../../../veil/presentation/providers/veil_provider.dart';
import '../../../veil/veil_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final veilService = ref.read(veilServiceProvider);
    final biometricEnabledAsync = ref.watch(isBiometricEnabledProvider);
    final canUseBiometricsAsync = ref.watch(canUseBiometricUnlockProvider);
    final autoLockOptionAsync = ref.watch(autoLockOptionProvider);

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBiometricTile(
              veilService,
              biometricEnabledAsync,
              canUseBiometricsAsync,
            ),
            autoLockOptionAsync.when(
              data: (option) {
                return ListTile(
                  title: const Text(
                    'Auto-lock',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Locks the vault after ${option.label.toLowerCase()}.',
                    style: TextStyle(fontSize: 12),
                  ),
                  onTap: _isLoading ? null : _selectAutoLockOption,
                );
              },
              loading: () => const ListTile(
                title: Text('Auto-lock'),
                subtitle: Text('Loading...'),
              ),
              error: (error, _) => ListTile(
                leading: const Icon(Icons.timer_outlined),
                title: const Text('Auto-lock'),
                subtitle: Text(error.toString()),
              ),
            ),
            ListTile(
              title: const Text(
                'Lock',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                "Clears the current session. You will need to unlock again...",
                style: TextStyle(fontSize: 12),
              ),
              onTap: () {
                ref.read(veilControllerProvider.notifier).lock();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBiometricTile(
    VeilService veilService,
    AsyncValue<bool> biometricEnabledAsync,
    AsyncValue<bool> canUseBiometricsAsync,
  ) {
    return biometricEnabledAsync.when(
      data: (isEnabled) {
        return canUseBiometricsAsync.when(
          data: (canUseBiometrics) {
            return SwitchListTile(
              value: isEnabled,
              onChanged: _isLoading
                  ? null
                  : (value) => _onBiometricChanged(value, veilService),
              title: const Text(
                'Biometrics',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                _biometricSubtitle(
                  isEnabled: isEnabled,
                  canUseBiometrics: canUseBiometrics,
                ),
                style: const TextStyle(fontSize: 12),
              ),
            );
          },
          loading: () => _buildBiometricLoadingTile(
            isEnabled: isEnabled,
            subtitle: 'Checking biometric availability...',
          ),
          error: (error, _) => _buildBiometricLoadingTile(
            isEnabled: isEnabled,
            subtitle: error.toString(),
          ),
        );
      },
      loading: () => _buildBiometricLoadingTile(
        isEnabled: false,
        subtitle: 'Loading biometric settings...',
      ),
      error: (error, _) => _buildBiometricLoadingTile(
        isEnabled: false,
        subtitle: error.toString(),
      ),
    );
  }

  Widget _buildBiometricLoadingTile({
    required bool isEnabled,
    required String subtitle,
  }) {
    return SwitchListTile(
      value: isEnabled,
      onChanged: null,
      title: const Text(
        'Biometrics',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
    );
  }

  String _biometricSubtitle({
    required bool isEnabled,
    required bool canUseBiometrics,
  }) {
    if (canUseBiometrics) {
      return 'Use biometrics to unlock your vault faster.';
    }

    if (isEnabled) {
      return 'Biometrics is enabled, but is not currently available on this device.';
    }

    return 'Enable biometrics for faster unlock.';
  }

  Future<void> _onBiometricChanged(bool value, VeilService veilService) async {
    final changed = value
        ? await _enableBiometrics(veilService)
        : await _disableBiometrics(veilService);

    if (!mounted || !changed) {
      return;
    }

    ref.invalidate(isBiometricEnabledProvider);
    ref.invalidate(canUseBiometricUnlockProvider);
  }

  Future<bool> _enableBiometrics(VeilService veilService) async {
    final passwordController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm password'),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: 'Type your password...',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      passwordController.dispose();
      return false;
    }

    if (!mounted) {
      passwordController.dispose();
      return false;
    }

    setState(() => _isLoading = true);

    try {
      await veilService.enableBiometricUnlock(passwordController.text);
      return true;
    } catch (error) {
      if (error is BiometricCanceledException) {
        return false;
      }

      _showError(error);
      return false;
    } finally {
      passwordController.dispose();

      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<bool> _disableBiometrics(VeilService veilService) async {
    setState(() => _isLoading = true);

    try {
      await veilService.disableBiometricUnlock();
      return true;
    } catch (error) {
      _showError(error);
      return false;
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _selectAutoLockOption() async {
    final options = AutoLockOption.options;
    final current = await ref.read(veilServiceProvider).getAutoLockOption();

    if (!mounted) return;

    final selected = await showModalBottomSheet<AutoLockOption>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options.map((option) {
              final isSelected = option.id == current.id;

              return ListTile(
                title: Text(option.label),
                trailing: isSelected
                    ? Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () => Navigator.of(context).pop(option),
              );
            }).toList(),
          ),
        );
      },
    );

    if (selected == null) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final veilService = ref.read(veilServiceProvider);
      await veilService.setAutoLockOption(selected);

      ref.invalidate(autoLockOptionProvider);

      final sessionController = ref.read(veilSessionControllerProvider);
      sessionController.updateTimeout(selected.duration);
    } catch (error) {
      if (!mounted) return;
      _showError(error);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(Object error) {
    if (!mounted) return;

    final message = error.toString().replaceFirst('Exception: ', '');

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
