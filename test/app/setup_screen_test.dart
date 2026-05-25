import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veil/app/app_theme.dart';
import 'package:veil/features/veil/application/veil_service.dart';
import 'package:veil/features/veil/domain/session/auto_lock_option.dart';
import 'package:veil/features/veil/presentation/screens/setup_screen.dart';
import 'package:veil/features/veil/providers/veil_provider.dart';
import 'package:veil/features/veil/domain/password/password_validation_result.dart';
import 'package:veil/features/veil/domain/veil_exception.dart';

import '../test_localized_app.dart';

void main() {
  Widget wrap(VeilService service) {
    return ProviderScope(
      overrides: [veilServiceProvider.overrideWithValue(service)],
      child: Consumer(
        builder: (context, ref, _) {
          ref.watch(veilControllerProvider);

          return buildLocalizedApp(
            theme: AppTheme.darkTheme,
            home: const SetupScreen(),
          );
        },
      ),
    );
  }

  group('SetupScreen', () {
    testWidgets('submits the typed password', (tester) async {
      final service = _FakeVeilService();

      await tester.pumpWidget(wrap(service));
      await tester.pump();
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'abc12345');
      await tester.tap(find.text("Let's start!"));
      await tester.pumpAndSettle();

      expect(service.createdPassword, 'abc12345');
    });

    testWidgets('shows snackbar when create throws', (tester) async {
      final service = _FakeVeilService(
        throwOnCreate: const VeilException.passwordValidation(
          PasswordValidationError.required,
        ),
      );

      await tester.pumpWidget(wrap(service));
      await tester.pump();
      await tester.pump();

      await tester.tap(find.text("Let's start!"));
      await tester.pumpAndSettle();

      expect(find.text('Password is required.'), findsOneWidget);
    });

    testWidgets('enables biometrics during onboarding by default', (
      tester,
    ) async {
      final service = _FakeVeilService();

      await tester.pumpWidget(wrap(service));
      await tester.pump();
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'abc12345');
      await tester.tap(find.text("Let's start!"));
      await tester.pumpAndSettle();

      expect(service.createdPassword, 'abc12345');
      expect(service.enableBiometricCalls, 1);
      expect(service.enabledPassword, 'abc12345');
    });

    testWidgets('does not enable biometrics when user opts out', (
      tester,
    ) async {
      final service = _FakeVeilService();

      await tester.pumpWidget(wrap(service));
      await tester.pump();
      await tester.pump();

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'abc12345');
      await tester.tap(find.text("Let's start!"));
      await tester.pumpAndSettle();

      expect(service.createdPassword, 'abc12345');
      expect(service.enableBiometricCalls, 0);
      expect(service.enabledPassword, isNull);
    });
  });
}

class _FakeVeilService implements VeilService {
  final Object? throwOnCreate;
  String? createdPassword;
  final Object? throwOnEnableBiometric;
  String? enabledPassword;
  int enableBiometricCalls = 0;

  _FakeVeilService({this.throwOnCreate, this.throwOnEnableBiometric});

  @override
  Future<bool> isConfigured() async => false;

  @override
  Future<void> create(String password) async {
    createdPassword = password;
    if (throwOnCreate != null) {
      throw throwOnCreate!;
    }
  }

  @override
  Future<bool> unlock(String password) async => true;

  @override
  Future<bool> unlockWithBiometrics() async => false;

  @override
  Future<bool> isBiometricEnabled() async => false;

  @override
  Future<bool> canUseBiometricUnlock() async => false;

  @override
  Future<void> enableBiometricUnlock(String password) async {
    enabledPassword = password;
    enableBiometricCalls++;
    if (throwOnEnableBiometric != null) {
      throw throwOnEnableBiometric!;
    }
  }

  @override
  Future<void> disableBiometricUnlock() async {}

  @override
  Future<AutoLockOption> getAutoLockOption() async =>
      AutoLockOption.fiveMinutes;

  @override
  Future<void> setAutoLockOption(AutoLockOption option) async {}

  @override
  void lock() {}
}
