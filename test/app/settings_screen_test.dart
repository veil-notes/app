import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veil/app/locale/app_locale_provider.dart';
import 'package:veil/app/locale/app_locale_service.dart';
import 'package:veil/app/app_theme.dart';
import 'package:veil/core/storage/secure_storage_service.dart';
import 'package:veil/features/veil/application/veil_controller.dart';
import 'package:veil/features/settings/presentation/screens/settings_screen.dart';
import 'package:veil/features/veil/application/veil_service.dart';
import 'package:veil/features/veil/application/veil_session_controller.dart';
import 'package:veil/features/veil/domain/biometrics/biometric_auth_exception.dart';
import 'package:veil/features/veil/domain/session/auto_lock_option.dart';
import 'package:veil/features/veil/domain/states/locked_state.dart';
import 'package:veil/features/veil/domain/veil_exception.dart';
import 'package:veil/features/veil/providers/veil_provider.dart';
import 'package:veil/i18n/translations.g.dart';

import '../test_localized_app.dart';

void main() {
  Widget wrap({
    required _FakeVeilService service,
    _FakeVeilSessionController? sessionController,
    AsyncValue<bool>? biometricEnabledValue,
    AsyncValue<bool>? canUseBiometricsValue,
    AsyncValue<AutoLockOption>? autoLockOptionValue,
    _FakeVeilController? controller,
    AppLocale initialLocale = AppLocale.en,
    AppLocaleService? localeService,
  }) {
    return ProviderScope(
      overrides: [
        veilServiceProvider.overrideWithValue(service),
        if (biometricEnabledValue != null)
          isBiometricEnabledProvider.overrideWithValue(biometricEnabledValue)
        else
          isBiometricEnabledProvider.overrideWith(
            (ref) async => service.isBiometricEnabled(),
          ),
        if (canUseBiometricsValue != null)
          canUseBiometricUnlockProvider.overrideWithValue(canUseBiometricsValue)
        else
          canUseBiometricUnlockProvider.overrideWith(
            (ref) async => service.canUseBiometricUnlock(),
          ),
        if (autoLockOptionValue != null)
          autoLockOptionProvider.overrideWithValue(autoLockOptionValue)
        else
          autoLockOptionProvider.overrideWith(
            (ref) async => service.getAutoLockOption(),
          ),
        initialAppLocaleProvider.overrideWithValue(initialLocale),
        appLocaleServiceProvider.overrideWithValue(
          localeService ?? AppLocaleService(_FakeSecureStorageService()),
        ),
        veilSessionControllerProvider.overrideWithValue(
          sessionController ??
              _FakeVeilSessionController(timeout: const Duration(minutes: 5)),
        ),
        veilControllerProvider.overrideWith(
          () => controller ?? _FakeVeilController(service),
        ),
      ],
      child: buildLocalizedApp(
        theme: AppTheme.darkTheme,
        locale: initialLocale,
        home: const SettingsScreen(),
      ),
    );
  }

  group('SettingsScreen', () {
    testWidgets('renders biometrics and auto-lock state from providers', (
      tester,
    ) async {
      final service = _FakeVeilService(
        biometricEnabled: false,
        canUseBiometrics: false,
        autoLockOption: AutoLockOption.fiveMinutes,
      );

      await tester.pumpWidget(wrap(service: service));
      await tester.pump();
      await tester.pump();

      expect(find.text('Biometrics'), findsOneWidget);
      expect(find.text('Enable biometrics for faster unlock.'), findsOneWidget);
      expect(find.text('Auto-lock'), findsOneWidget);
      expect(find.text('Locks the app after 5 minutes.'), findsOneWidget);
    });

    testWidgets('enables biometrics after password confirmation', (
      tester,
    ) async {
      final service = _FakeVeilService(
        biometricEnabled: false,
        canUseBiometrics: false,
        autoLockOption: AutoLockOption.fiveMinutes,
      );

      await tester.pumpWidget(wrap(service: service));
      await tester.pump();
      await tester.pump();

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(find.text('Confirm password'), findsOneWidget);

      await tester.tap(find.text('Confirm'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(service.enabledPassword, '');
      expect(service.biometricEnabled, isTrue);
    });

    testWidgets('shows loading and error states for async settings', (
      tester,
    ) async {
      final service = _FakeVeilService(
        biometricEnabled: false,
        canUseBiometrics: false,
        autoLockOption: AutoLockOption.fiveMinutes,
      );

      await tester.pumpWidget(
        wrap(
          service: service,
          biometricEnabledValue: const AsyncLoading<bool>(),
          canUseBiometricsValue: AsyncError<bool>(
            Exception('Biometrics unavailable'),
            StackTrace.empty,
          ),
          autoLockOptionValue: AsyncError<AutoLockOption>(
            Exception('Auto-lock failed'),
            StackTrace.empty,
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Loading biometric settings...'), findsOneWidget);
      expect(find.text('Could not load the information.'), findsOneWidget);
    });

    testWidgets('shows loading state while checking biometric availability', (
      tester,
    ) async {
      final service = _FakeVeilService(
        biometricEnabled: true,
        canUseBiometrics: false,
        autoLockOption: AutoLockOption.fiveMinutes,
      );

      await tester.pumpWidget(
        wrap(
          service: service,
          biometricEnabledValue: const AsyncData<bool>(true),
          canUseBiometricsValue: const AsyncLoading<bool>(),
        ),
      );
      await tester.pump();

      expect(find.text('Checking biometric availability...'), findsOneWidget);
    });

    testWidgets('shows error state while checking biometric availability', (
      tester,
    ) async {
      final service = _FakeVeilService(
        biometricEnabled: true,
        canUseBiometrics: false,
        autoLockOption: AutoLockOption.fiveMinutes,
      );

      await tester.pumpWidget(
        wrap(
          service: service,
          biometricEnabledValue: const AsyncData<bool>(true),
          canUseBiometricsValue: AsyncError<bool>(
            Exception('Sensor error'),
            StackTrace.empty,
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Could not load the information.'), findsOneWidget);
    });

    testWidgets('shows error state while loading biometric settings', (
      tester,
    ) async {
      final service = _FakeVeilService(
        biometricEnabled: false,
        canUseBiometrics: false,
        autoLockOption: AutoLockOption.fiveMinutes,
      );

      await tester.pumpWidget(
        wrap(
          service: service,
          biometricEnabledValue: AsyncError<bool>(
            Exception('Biometrics failed'),
            StackTrace.empty,
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Could not load the information.'), findsOneWidget);
    });

    testWidgets('disables biometrics through the switch', (tester) async {
      final service = _FakeVeilService(
        biometricEnabled: true,
        canUseBiometrics: true,
        autoLockOption: AutoLockOption.fiveMinutes,
      );

      await tester.pumpWidget(wrap(service: service));
      await tester.pump();
      await tester.pump();

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(service.disableBiometricsCalls, 1);
      expect(service.biometricEnabled, isFalse);
    });

    testWidgets('shows error snackbar when enabling biometrics fails', (
      tester,
    ) async {
      final service = _FakeVeilService(
        biometricEnabled: false,
        canUseBiometrics: false,
        autoLockOption: AutoLockOption.fiveMinutes,
        enableException: const VeilException(VeilExceptionCode.invalidPassword),
      );

      await tester.pumpWidget(wrap(service: service));
      await tester.pump();
      await tester.pump();

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Confirm'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Invalid password.'), findsOneWidget);
    });

    testWidgets(
      'does not enable biometrics when password dialog is cancelled',
      (tester) async {
        final service = _FakeVeilService(
          biometricEnabled: false,
          canUseBiometrics: false,
          autoLockOption: AutoLockOption.fiveMinutes,
        );

        await tester.pumpWidget(wrap(service: service));
        await tester.pump();
        await tester.pump();

        await tester.tap(find.byType(Switch));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        expect(service.enabledPassword, isNull);
        expect(service.biometricEnabled, isFalse);
      },
    );

    testWidgets('shows snackbar when disabling biometrics fails', (
      tester,
    ) async {
      final service = _FakeVeilService(
        biometricEnabled: true,
        canUseBiometrics: true,
        autoLockOption: AutoLockOption.fiveMinutes,
        disableException: Exception('Disable failed'),
      );

      await tester.pumpWidget(wrap(service: service));
      await tester.pump();
      await tester.pump();

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(find.text('An unexpected error occurred.'), findsOneWidget);
    });

    testWidgets(
      'selects a new auto-lock option and updates the session timer',
      (tester) async {
        final service = _FakeVeilService(
          biometricEnabled: false,
          canUseBiometrics: false,
          autoLockOption: AutoLockOption.fiveMinutes,
        );
        final sessionController = _FakeVeilSessionController(
          timeout: const Duration(minutes: 5),
        );

        await tester.pumpWidget(
          wrap(service: service, sessionController: sessionController),
        );
        await tester.pump();
        await tester.pump();

        await tester.tap(find.text('Auto-lock'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('15 minutes').last);
        await tester.pumpAndSettle();

        expect(service.autoLockOption, AutoLockOption.fifteenMinutes);
        expect(
          sessionController.lastTimeout,
          AutoLockOption.fifteenMinutes.duration,
        );
      },
    );

    testWidgets('shows snackbar when changing auto-lock fails', (tester) async {
      final service = _FakeVeilService(
        biometricEnabled: false,
        canUseBiometrics: false,
        autoLockOption: AutoLockOption.fiveMinutes,
        autoLockException: Exception('Could not update auto-lock'),
      );
      final sessionController = _FakeVeilSessionController(
        timeout: const Duration(minutes: 5),
      );

      await tester.pumpWidget(
        wrap(service: service, sessionController: sessionController),
      );
      await tester.pump();
      await tester.pump();

      await tester.tap(find.text('Auto-lock'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('15 minutes').last);
      await tester.pumpAndSettle();

      expect(find.text('An unexpected error occurred.'), findsOneWidget);
      expect(sessionController.lastTimeout, isNull);
    });

    testWidgets('locks the app when tapping the lock tile', (tester) async {
      final service = _FakeVeilService(
        biometricEnabled: false,
        canUseBiometrics: false,
        autoLockOption: AutoLockOption.fiveMinutes,
      );
      final controller = _FakeVeilController(service);

      await tester.pumpWidget(wrap(service: service, controller: controller));
      await tester.pump();
      await tester.pump();

      await tester.tap(find.text('Lock'));
      await tester.pump();

      expect(controller.lockCalls, 1);
    });

    testWidgets('cancels biometric enable silently on biometric cancel', (
      tester,
    ) async {
      final service = _FakeVeilService(
        biometricEnabled: false,
        canUseBiometrics: false,
        autoLockOption: AutoLockOption.fiveMinutes,
        enableException: const BiometricCanceledException(),
      );

      await tester.pumpWidget(wrap(service: service));
      await tester.pump();
      await tester.pump();

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Confirm'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('changes the app language from the settings bottom sheet', (
      tester,
    ) async {
      final storage = _FakeSecureStorageService();
      final localeService = AppLocaleService(storage);
      final service = _FakeVeilService(
        biometricEnabled: false,
        canUseBiometrics: false,
        autoLockOption: AutoLockOption.fiveMinutes,
      );

      await tester.pumpWidget(
        wrap(
          service: service,
          initialLocale: AppLocale.en,
          localeService: localeService,
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.text('Language'), findsOneWidget);
      expect(find.text('Current language: English.'), findsOneWidget);

      await tester.tap(find.text('Language'));
      await tester.pumpAndSettle();

      expect(find.text('English'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);

      await tester.tap(find.text('Portuguese (Brazil)'));
      await tester.pumpAndSettle();

      expect(find.text('Idioma'), findsOneWidget);
      expect(find.text('Idioma atual: Português (Brasil).'), findsOneWidget);
      expect(storage.values[AppLocaleService.localeStorageKey], 'pt-BR');
    });
  });
}

class _FakeVeilService implements VeilService {
  bool biometricEnabled;
  bool canUseBiometrics;
  AutoLockOption autoLockOption;
  final Object? enableException;
  final Object? disableException;
  final Object? autoLockException;

  String? enabledPassword;
  int disableBiometricsCalls = 0;

  _FakeVeilService({
    required this.biometricEnabled,
    required this.canUseBiometrics,
    required this.autoLockOption,
    this.enableException,
    this.disableException,
    this.autoLockException,
  });

  @override
  Future<bool> canUseBiometricUnlock() async => canUseBiometrics;

  @override
  Future<void> create(String password) async {}

  @override
  Future<void> disableBiometricUnlock() async {
    if (disableException != null) {
      throw disableException!;
    }
    disableBiometricsCalls++;
    biometricEnabled = false;
    canUseBiometrics = false;
  }

  @override
  Future<void> enableBiometricUnlock(String password) async {
    enabledPassword = password;
    if (enableException != null) {
      throw enableException!;
    }
    biometricEnabled = true;
    canUseBiometrics = true;
  }

  @override
  Future<AutoLockOption> getAutoLockOption() async => autoLockOption;

  @override
  Future<bool> isBiometricEnabled() async => biometricEnabled;

  @override
  Future<bool> isConfigured() async => true;

  @override
  void lock() {}

  @override
  Future<void> setAutoLockOption(AutoLockOption option) async {
    if (autoLockException != null) {
      throw autoLockException!;
    }
    autoLockOption = option;
  }

  @override
  Future<bool> unlock(String password) async => true;

  @override
  Future<bool> unlockWithBiometrics() async => true;
}

class _FakeVeilSessionController extends VeilSessionController {
  Duration? lastTimeout;

  _FakeVeilSessionController({required super.timeout})
    : super(onTimeout: () {});

  @override
  void updateTimeout(Duration timeout) {
    lastTimeout = timeout;
  }
}

class _FakeVeilController extends VeilController {
  final _FakeVeilService service;
  int lockCalls = 0;

  _FakeVeilController(this.service);

  @override
  LockedState build() => LockedState(service);

  @override
  void lock() {
    lockCalls++;
  }
}

class _FakeSecureStorageService implements SecureStorageService {
  final Map<String, String> values = {};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async {
    values[key] = value;
  }
}
