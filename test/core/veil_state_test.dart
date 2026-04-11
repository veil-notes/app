import 'package:flutter_test/flutter_test.dart';
import 'package:veil/features/veil/application/veil_service.dart';
import 'package:veil/features/veil/domain/biometrics/biometric_auth_exception.dart';
import 'package:veil/features/veil/domain/session/auto_lock_option.dart';
import 'package:veil/features/veil/domain/states/bootstrapping_state.dart';
import 'package:veil/features/veil/domain/states/locked_state.dart';
import 'package:veil/features/veil/domain/states/uninitialized_state.dart';
import 'package:veil/features/veil/domain/states/unlocked_state.dart';

void main() {
  group('BootstrappingState', () {
    test('goes to uninitialized when veil is not configured', () async {
      final service = _FakeVeilService(isConfiguredResult: false);

      final next = await BootstrappingState(service).bootstrap();

      expect(next, isA<UninitializedState>());
    });

    test('goes to locked when veil is configured', () async {
      final service = _FakeVeilService(isConfiguredResult: true);

      final next = await BootstrappingState(service).bootstrap();

      expect(next, isA<LockedState>());
    });

    test('unlocks with password when service accepts it', () async {
      final service = _FakeVeilService(unlockResult: true);

      final next = await BootstrappingState(service).unlockWithPassword('123');

      expect(next, isA<UnlockedState>());
      expect(service.lastUnlockedPassword, '123');
    });

    test('throws when password unlock fails', () async {
      final service = _FakeVeilService(unlockResult: false);

      await expectLater(
        () => BootstrappingState(service).unlockWithPassword('123'),
        throwsA(isA<Exception>()),
      );
    });

    test('unlocks with biometrics when service accepts it', () async {
      final service = _FakeVeilService(unlockWithBiometricsResult: true);

      final next = await BootstrappingState(service).unlockWithBiometrics();

      expect(next, isA<UnlockedState>());
    });

    test('throws when biometric unlock fails', () async {
      final service = _FakeVeilService(unlockWithBiometricsResult: false);

      await expectLater(
        () => BootstrappingState(service).unlockWithBiometrics(),
        throwsA(isA<Exception>()),
      );
    });

    test('rejects create and remains inaccessible across timeout', () async {
      final state = BootstrappingState(_FakeVeilService());

      await expectLater(
        () => state.create('secret'),
        throwsA(isA<Exception>()),
      );
      expect(state.onTimeout(), same(state));
      expect(state.isAccessible, isFalse);
    });
  });

  group('UninitializedState', () {
    test('creates the veil and transitions to unlocked', () async {
      final service = _FakeVeilService();

      final next = await UninitializedState(service).create('secret');

      expect(next, isA<UnlockedState>());
      expect(service.createdWithPassword, 'secret');
    });

    test('throws when trying to unlock before configuration', () async {
      final state = UninitializedState(_FakeVeilService());

      await expectLater(
        () => state.unlockWithPassword('secret'),
        throwsA(isA<Exception>()),
      );
      await expectLater(state.unlockWithBiometrics, throwsA(isA<Exception>()));
    });

    test('keeps bootstrap and timeout idempotent while inaccessible', () async {
      final state = UninitializedState(_FakeVeilService());

      expect(await state.bootstrap(), same(state));
      expect(state.onTimeout(), same(state));
      expect(state.isAccessible, isFalse);
    });
  });

  group('LockedState', () {
    test('returns unlocked when password is correct', () async {
      final service = _FakeVeilService(unlockResult: true);

      final next = await LockedState(service).unlockWithPassword('secret');

      expect(next, isA<UnlockedState>());
      expect(service.lastUnlockedPassword, 'secret');
    });

    test('throws when password is invalid', () async {
      final service = _FakeVeilService(unlockResult: false);

      await expectLater(
        () => LockedState(service).unlockWithPassword('secret'),
        throwsA(isA<Exception>()),
      );
    });

    test('returns same state when biometric auth is canceled', () async {
      final service = _FakeVeilService(
        biometricException: const BiometricCanceledException(),
      );
      final state = LockedState(service);

      final next = await state.unlockWithBiometrics();

      expect(identical(next, state), isTrue);
    });

    test(
      'maps biometric availability failures to user-facing exceptions',
      () async {
        final unavailable = LockedState(
          _FakeVeilService(
            biometricException: const BiometricUnavailableException(),
          ),
        );
        final lockedOut = LockedState(
          _FakeVeilService(
            biometricException: const BiometricLockedOutException(),
          ),
        );
        final failed = LockedState(
          _FakeVeilService(
            biometricException: const BiometricFailedException(),
          ),
        );

        await expectLater(
          unavailable.unlockWithBiometrics,
          throwsA(isA<Exception>()),
        );
        await expectLater(
          lockedOut.unlockWithBiometrics,
          throwsA(isA<Exception>()),
        );
        await expectLater(
          failed.unlockWithBiometrics,
          throwsA(isA<Exception>()),
        );
      },
    );

    test('returns unlocked when biometric auth succeeds', () async {
      final service = _FakeVeilService(unlockWithBiometricsResult: true);

      final next = await LockedState(service).unlockWithBiometrics();

      expect(next, isA<UnlockedState>());
    });

    test('rejects create and stays locked for bootstrap and timeout', () async {
      final state = LockedState(_FakeVeilService());

      await expectLater(
        () => state.create('secret'),
        throwsA(isA<Exception>()),
      );
      expect(await state.bootstrap(), same(state));
      expect(state.onTimeout(), same(state));
      expect(state.isAccessible, isFalse);
    });
  });

  group('UnlockedState', () {
    test('keeps unlock calls idempotent', () async {
      final state = UnlockedState(_FakeVeilService());

      expect(await state.unlockWithPassword('secret'), same(state));
      expect(await state.unlockWithBiometrics(), same(state));
    });

    test('locks the service when timing out', () {
      final service = _FakeVeilService();
      final state = UnlockedState(service);

      final next = state.onTimeout();

      expect(next, isA<LockedState>());
      expect(service.lockCalled, isTrue);
    });

    test('rejects create, bootstraps to itself and stays accessible', () async {
      final state = UnlockedState(_FakeVeilService());

      await expectLater(
        () => state.create('secret'),
        throwsA(isA<Exception>()),
      );
      expect(await state.bootstrap(), same(state));
      expect(state.isAccessible, isTrue);
    });
  });
}

class _FakeVeilService implements VeilService {
  final bool isConfiguredResult;
  final bool unlockResult;
  final bool unlockWithBiometricsResult;
  final Exception? biometricException;

  String? createdWithPassword;
  String? lastUnlockedPassword;
  bool lockCalled = false;

  _FakeVeilService({
    this.isConfiguredResult = false,
    this.unlockResult = false,
    this.unlockWithBiometricsResult = false,
    this.biometricException,
  });

  @override
  Future<bool> isConfigured() async => isConfiguredResult;

  @override
  Future<void> create(String password) async {
    createdWithPassword = password;
  }

  @override
  Future<bool> unlock(String password) async {
    lastUnlockedPassword = password;
    return unlockResult;
  }

  @override
  Future<bool> unlockWithBiometrics() async {
    if (biometricException != null) {
      throw biometricException!;
    }

    return unlockWithBiometricsResult;
  }

  @override
  Future<bool> isBiometricEnabled() async => false;

  @override
  Future<bool> canUseBiometricUnlock() async => false;

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
  void lock() {
    lockCalled = true;
  }
}
