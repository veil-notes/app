import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/app_error_mapper.dart';
import '../../../../app/locale/app_locale_provider.dart';
import '../../../../i18n/translations.g.dart';
import '../../../veil/application/veil_service.dart';
import '../../../veil/domain/biometrics/biometric_auth_exception.dart';
import '../../../veil/domain/session/auto_lock_option.dart';
import '../../../veil/providers/veil_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  static const _errorMapper = AppErrorMapper();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final veilService = ref.read(veilServiceProvider);
    final biometricEnabledAsync = ref.watch(isBiometricEnabledProvider);
    final canUseBiometricsAsync = ref.watch(canUseBiometricUnlockProvider);
    final autoLockOptionAsync = ref.watch(autoLockOptionProvider);
    final currentLocale = ref.watch(appLocaleControllerProvider);
    final topInset = MediaQuery.paddingOf(context).top + kToolbarHeight + 8;
    final t = context.t;

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
              context: context,
              veilService: veilService,
              biometricEnabledAsync: biometricEnabledAsync,
              canUseBiometricsAsync: canUseBiometricsAsync,
            ),
            autoLockOptionAsync.when(
              data: (option) {
                return ListTile(
                  title: Text(
                    t.settings.autoLock.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    t.settings.autoLock.subtitle(
                      duration: _autoLockLabel(t, option),
                    ),
                    style: const TextStyle(fontSize: 12),
                  ),
                  onTap: _isLoading ? null : _selectAutoLockOption,
                );
              },
              loading: () => ListTile(
                title: Text(t.settings.autoLock.title),
                subtitle: Text(t.common.loading),
              ),
              error: (_, _) => ListTile(
                leading: const Icon(Icons.timer_outlined),
                title: Text(t.settings.autoLock.title),
                subtitle: Text(t.common.errors.loadFailed),
              ),
            ),
            ListTile(
              title: Text(
                t.settings.language.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                t.settings.language.subtitle(
                  language: _languageLabel(t, currentLocale),
                ),
                style: const TextStyle(fontSize: 12),
              ),
              onTap: _isLoading ? null : _selectLanguage,
            ),
            ListTile(
              title: Text(
                t.settings.lock.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                t.settings.lock.subtitle,
                style: const TextStyle(fontSize: 12),
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

  Widget _buildBiometricTile({
    required BuildContext context,
    required VeilService veilService,
    required AsyncValue<bool> biometricEnabledAsync,
    required AsyncValue<bool> canUseBiometricsAsync,
  }) {
    final t = context.t;

    return biometricEnabledAsync.when(
      data: (isEnabled) {
        return canUseBiometricsAsync.when(
          data: (canUseBiometrics) {
            return SwitchListTile(
              value: isEnabled,
              onChanged: _isLoading
                  ? null
                  : (value) => _onBiometricChanged(value, veilService),
              title: Text(
                t.settings.biometrics.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                _biometricSubtitle(
                  t,
                  isEnabled: isEnabled,
                  canUseBiometrics: canUseBiometrics,
                ),
                style: const TextStyle(fontSize: 12),
              ),
            );
          },
          loading: () => _buildBiometricLoadingTile(
            context: context,
            isEnabled: isEnabled,
            subtitle: t.settings.biometrics.checkingAvailability,
          ),
          error: (_, _) => _buildBiometricLoadingTile(
            context: context,
            isEnabled: isEnabled,
            subtitle: t.common.errors.loadFailed,
          ),
        );
      },
      loading: () => _buildBiometricLoadingTile(
        context: context,
        isEnabled: false,
        subtitle: t.settings.biometrics.loading,
      ),
      error: (_, _) => _buildBiometricLoadingTile(
        context: context,
        isEnabled: false,
        subtitle: t.common.errors.loadFailed,
      ),
    );
  }

  Widget _buildBiometricLoadingTile({
    required BuildContext context,
    required bool isEnabled,
    required String subtitle,
  }) {
    return SwitchListTile(
      value: isEnabled,
      onChanged: null,
      title: Text(
        context.t.settings.biometrics.title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
    );
  }

  String _biometricSubtitle(
    Translations t, {
    required bool isEnabled,
    required bool canUseBiometrics,
  }) {
    if (canUseBiometrics) {
      return t.settings.biometrics.subtitleAvailable;
    }

    if (isEnabled) {
      return t.settings.biometrics.subtitleEnabledUnavailable;
    }

    return t.settings.biometrics.subtitleDisabledUnavailable;
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
    final password = await _showConfirmPasswordSheet();

    if (password == null) {
      return false;
    }

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

    if (!mounted) {
      return;
    }

    final t = context.t;
    final selected = await _showSelectionSheet<AutoLockOption>(
      options: options,
      current: current,
      labelFor: (option) => _autoLockLabel(t, option),
      isSelected: (option, selectedOption) => option.id == selectedOption.id,
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
      if (!mounted) {
        return;
      }
      _showError(error);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _selectLanguage() async {
    final currentLocale = ref.read(appLocaleControllerProvider);
    final t = context.t;

    final selected = await _showSelectionSheet<AppLocale>(
      options: const [
        AppLocale.ptBr,
        AppLocale.en,
        AppLocale.es,
        AppLocale.de,
        AppLocale.ru,
        AppLocale.ko,
        AppLocale.zh,
        AppLocale.fr,
        AppLocale.ja,
      ],
      current: currentLocale,
      labelFor: (locale) => _languageLabel(t, locale),
      isSelected: (locale, selectedLocale) => locale == selectedLocale,
    );

    if (selected == null || selected == currentLocale) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(appLocaleControllerProvider.notifier).setLocale(selected);
    } catch (error) {
      if (!mounted) {
        return;
      }
      _showError(error);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<T?> _showSelectionSheet<T>({
    required List<T> options,
    required T current,
    required String Function(T option) labelFor,
    required bool Function(T option, T current) isSelected,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: const Color(0xFF171336),
      barrierColor: Colors.black.withValues(alpha: 0.45),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        final maxSheetHeight = MediaQuery.of(context).size.height * 0.75;

        return SafeArea(
          top: false,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: maxSheetHeight,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 4,
                      decoration: BoxDecoration(
                        color: colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Flexible(
                    child: ListView.separated(
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final option = options[index];
                        final selected = isSelected(option, current);

                        return ListTile(
                          title: Text(labelFor(option)),
                          trailing: selected
                              ? Icon(Icons.check, color: colorScheme.primary)
                              : null,
                          onTap: () => Navigator.of(context).pop(option),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Column(
                          children: [
                            const SizedBox(height: 8),
                            Divider(
                              height: 1,
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.05,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<String?> _showConfirmPasswordSheet() {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF171336),
      barrierColor: Colors.black.withValues(alpha: 0.45),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: _ConfirmPasswordSheet(t: context.t),
        );
      },
    );
  }

  String _autoLockLabel(Translations t, AutoLockOption option) {
    switch (option.id) {
      case '1m':
        return t.settings.autoLock.options.oneMinute;
      case '5m':
        return t.settings.autoLock.options.fiveMinutes;
      case '15m':
        return t.settings.autoLock.options.fifteenMinutes;
      case '30m':
        return t.settings.autoLock.options.thirtyMinutes;
      default:
        return t.settings.autoLock.options.fiveMinutes;
    }
  }

  String _languageLabel(Translations t, AppLocale locale) {
    switch (locale) {
      case AppLocale.ptBr:
        return t.common.languageNames.ptBr;
      case AppLocale.en:
        return t.common.languageNames.en;
      case AppLocale.es:
        return t.common.languageNames.es;
      case AppLocale.de:
        return t.common.languageNames.de;
      case AppLocale.ru:
        return t.common.languageNames.ru;
      case AppLocale.ko:
        return t.common.languageNames.ko;
      case AppLocale.zh:
        return t.common.languageNames.zh;
      case AppLocale.fr:
        return t.common.languageNames.fr;
      case AppLocale.ja:
        return t.common.languageNames.ja;
    }
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


class _ConfirmPasswordSheet extends StatefulWidget {
  final Translations t;

  const _ConfirmPasswordSheet({required this.t});

  @override
  State<_ConfirmPasswordSheet> createState() => _ConfirmPasswordSheetState();
}

class _ConfirmPasswordSheetState extends State<_ConfirmPasswordSheet> {
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
                  color: colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                widget.t.settings.confirmPassword.title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              autofocus: true,
              decoration: InputDecoration(
                hintText: widget.t.settings.confirmPassword.hint,
              ),
              onSubmitted: (_) => Navigator.of(
                context,
              ).pop(_passwordController.text),
            ),
            const SizedBox(height: 16),
            Divider(height: 1, color: colorScheme.onSurface.withValues(alpha: 0.05)),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(_passwordController.text),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      widget.t.common.actions.confirm,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Divider(height: 1, color: colorScheme.onSurface.withValues(alpha: 0.05)),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      widget.t.common.actions.cancel,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}