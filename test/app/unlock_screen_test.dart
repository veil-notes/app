import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veil/app/app_theme.dart';
import 'package:veil/features/veil/application/veil_service.dart';
import 'package:veil/features/veil/domain/biometrics/biometric_auth_exception.dart';
import 'package:veil/features/veil/domain/session/auto_lock_option.dart';
import 'package:veil/features/veil/domain/veil_exception.dart';
import 'package:veil/features/veil/presentation/screens/unlock_screen.dart';
import 'package:veil/features/veil/providers/veil_provider.dart';

import '../test_localized_app.dart';

void main() {
  Widget wrap({
    required VeilService service,
    Future<bool> Function(Ref ref)? biometricsBuilder,
    AsyncValue<bool>? biometricsValue,
  }) {
    return ProviderScope(
      overrides: [
        veilServiceProvider.overrideWithValue(service),
        if (biometricsValue != null)
          canUseBiometricUnlockProvider.overrideWithValue(biometricsValue)
        else
          canUseBiometricUnlockProvider.overrideWith(
            biometricsBuilder ?? (ref) async => false,
          ),
      ],
      child: buildLocalizedApp(
        theme: AppTheme.darkTheme,
        home: const UnlockScreen(),
      ),
    );
  }

  group('UnlockScreen', () {
    testWidgets('submits password through the controller', (tester) async {
      final service = _FakeVeilService();

      await tester.pumpWidget(
        wrap(service: service, biometricsBuilder: (ref) async => false),
      );
      await tester.pump();
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'abc12345');
      await tester.tap(find.text('Unlock'));
      await tester.pumpAndSettle();

      expect(service.lastUnlockPassword, 'abc12345');
    });

    testWidgets('shows biometric button and triggers unlock', (tester) async {
      final service = _FakeVeilService();

      await tester.pumpWidget(
        wrap(service: service, biometricsBuilder: (ref) async => true),
      );
      await tester.pump();
      await tester.pump();
      await tester.pump();

      expect(find.byIcon(Icons.fingerprint), findsOneWidget);

      await tester.tap(find.byIcon(Icons.fingerprint));
      await tester.pumpAndSettle();

      expect(service.biometricUnlockCalls, greaterThanOrEqualTo(1));
    });

    testWidgets('auto-triggers biometrics once when enabled', (tester) async {
      final service = _FakeVeilService();

      await tester.pumpWidget(
        wrap(service: service, biometricsBuilder: (ref) async => true),
      );
      await tester.pump();
      await tester.pump();
      await tester.pump();

      expect(service.biometricUnlockCalls, 1);
    });

    testWidgets('shows snackbar when password unlock fails', (tester) async {
      final service = _FakeVeilService(
        throwOnUnlock: const VeilException(VeilExceptionCode.invalidPassword),
      );

      await tester.pumpWidget(
        wrap(service: service, biometricsBuilder: (ref) async => false),
      );
      await tester.pump();
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'wrong');
      await tester.tap(find.text('Unlock'));
      await tester.pumpAndSettle();

      expect(find.text('Invalid password.'), findsOneWidget);
    });

    testWidgets('submits password from the keyboard action', (tester) async {
      final service = _FakeVeilService();

      await tester.pumpWidget(
        wrap(service: service, biometricsBuilder: (ref) async => false),
      );
      await tester.pump();
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'typed-on-submit');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(service.lastUnlockPassword, 'typed-on-submit');
    });

    testWidgets('hides biometric button when provider errors', (tester) async {
      final service = _FakeVeilService();

      await tester.pumpWidget(
        wrap(
          service: service,
          biometricsValue: AsyncError<bool>(
            Exception('provider failed'),
            StackTrace.empty,
          ),
        ),
      );
      await tester.pump();

      expect(find.byIcon(Icons.fingerprint), findsNothing);
    });

    testWidgets('shows snackbar when biometric unlock fails', (tester) async {
      final service = _FakeVeilService(
        throwOnBiometricUnlock: const BiometricFailedException(),
      );

      await tester.pumpWidget(
        wrap(service: service, biometricsBuilder: (ref) async => true),
      );
      await tester.pump();
      await tester.pump();
      await tester.pump();

      await tester.tap(find.byIcon(Icons.fingerprint));
      await tester.pumpAndSettle();

      expect(find.text('Biometric authentication failed.'), findsOneWidget);
    });

    testWidgets('auto-triggers biometrics when provider is already true', (
      tester,
    ) async {
      final service = _FakeVeilService();

      await tester.pumpWidget(
        wrap(service: service, biometricsValue: const AsyncData<bool>(true)),
      );
      await tester.pump();
      await tester.pump();

      expect(service.biometricUnlockCalls, 1);
    });
  });
}

class _FakeVeilService implements VeilService {
  final Object? throwOnUnlock;
  final Object? throwOnBiometricUnlock;
  String? lastUnlockPassword;
  int biometricUnlockCalls = 0;

  _FakeVeilService({this.throwOnUnlock, this.throwOnBiometricUnlock});

  @override
  Future<bool> isConfigured() async => true;

  @override
  Future<void> create(String password) async {}

  @override
  Future<bool> unlock(String password) async {
    lastUnlockPassword = password;
    if (throwOnUnlock != null) {
      throw throwOnUnlock!;
    }
    return true;
  }

  @override
  Future<bool> unlockWithBiometrics() async {
    biometricUnlockCalls++;
    if (throwOnBiometricUnlock != null) {
      throw throwOnBiometricUnlock!;
    }
    return true;
  }

  @override
  Future<bool> isBiometricEnabled() async => true;

  @override
  Future<bool> canUseBiometricUnlock() async => true;

  @override
  Future<void> enableBiometricUnlock(String password) async {}

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
