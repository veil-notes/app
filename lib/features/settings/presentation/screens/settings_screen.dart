import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../veil/domain/biometrics/biometric_auth_exception.dart';
import '../../../veil/domain/session/auto_lock_option.dart';
import '../../../veil/providers/veil_provider.dart';
import '../../../veil/application/veil_service.dart';

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
    final topInset = MediaQuery.paddingOf(context).top + kToolbarHeight + 8;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leadingWidth: 72,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
          child: Material(
            elevation: 0,
            color: const Color(0xFF2A2448),
            shape: const CircleBorder(),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: const BackButton(color: Colors.white),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(8, topInset, 8, 8),
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
                    'Locks the app after ${option.label.toLowerCase()}.',
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
      return 'Use biometrics to unlock app faster.';
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

    final password = passwordController.text;
    passwordController.dispose();

    if (!mounted) {
      return false;
    }

    setState(() => _isLoading = true);

    try {
      await veilService.enableBiometricUnlock(password);
      return true;
    } catch (error) {
      if (error is BiometricCanceledException) {
        return false;
      }

      _showError(error);
      return false;
    } finally {
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
      backgroundColor: const Color(0xFF171336),
      barrierColor: Colors.black.withValues(alpha: 0.45),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ...options.map((option) {
                  final isSelected = option.id == current.id;

                  return Column(
                    children: [
                      ListTile(
                        title: Text(option.label),
                        trailing: isSelected
                            ? Icon(
                                Icons.check,
                                color: Theme.of(context).colorScheme.primary,
                              )
                            : null,
                        onTap: () => Navigator.of(context).pop(option),
                      ),
                      const SizedBox(height: 8),
                      if (option.id != options.last.id) ...[
                        Divider(
                          height: 1,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.05),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ],
                  );
                }),
              ],
            ),
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
