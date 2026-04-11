import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veil/features/veil/application/veil_service.dart';
import 'package:veil/features/veil/domain/session/auto_lock_option.dart';
import 'package:veil/features/veil/domain/states/bootstrapping_state.dart';
import 'package:veil/features/veil/domain/states/locked_state.dart';
import 'package:veil/features/veil/domain/states/uninitialized_state.dart';
import 'package:veil/features/veil/domain/states/unlocked_state.dart';
import 'package:veil/features/veil/providers/veil_provider.dart';

void main() {
  group('VeilController', () {
    test(
      'bootstraps to uninitialized when the veil is not configured',
      () async {
        final container = ProviderContainer(
          overrides: [
            veilServiceProvider.overrideWithValue(
              _FakeVeilService(isConfiguredResult: false),
            ),
          ],
        );
        addTearDown(container.dispose);

        expect(
          container.read(veilControllerProvider),
          isA<BootstrappingState>(),
        );

        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        expect(
          container.read(veilControllerProvider),
          isA<UninitializedState>(),
        );
      },
    );

    test('bootstraps to locked when the veil is configured', () async {
      final container = ProviderContainer(
        overrides: [
          veilServiceProvider.overrideWithValue(
            _FakeVeilService(isConfiguredResult: true),
          ),
        ],
      );
      addTearDown(container.dispose);

      container.read(veilControllerProvider);
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      expect(container.read(veilControllerProvider), isA<LockedState>());
    });

    test('create transitions to unlocked state', () async {
      final service = _FakeVeilService(isConfiguredResult: false);
      final container = ProviderContainer(
        overrides: [veilServiceProvider.overrideWithValue(service)],
      );
      addTearDown(container.dispose);

      container.read(veilControllerProvider);
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      await container.read(veilControllerProvider.notifier).create('secret');

      expect(container.read(veilControllerProvider), isA<UnlockedState>());
      expect(service.createdWithPassword, 'secret');
    });

    test('unlock transitions from locked to unlocked', () async {
      final service = _FakeVeilService(
        isConfiguredResult: true,
        unlockResult: true,
      );
      final container = ProviderContainer(
        overrides: [veilServiceProvider.overrideWithValue(service)],
      );
      addTearDown(container.dispose);

      container.read(veilControllerProvider);
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      await container.read(veilControllerProvider.notifier).unlock('secret');

      expect(container.read(veilControllerProvider), isA<UnlockedState>());
      expect(service.lastUnlockedPassword, 'secret');
    });

    test('lock triggers timeout behavior on the current state', () async {
      final service = _FakeVeilService(
        isConfiguredResult: true,
        unlockResult: true,
      );
      final container = ProviderContainer(
        overrides: [veilServiceProvider.overrideWithValue(service)],
      );
      addTearDown(container.dispose);

      container.read(veilControllerProvider);
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);
      await container.read(veilControllerProvider.notifier).unlock('secret');

      container.read(veilControllerProvider.notifier).lock();

      expect(container.read(veilControllerProvider), isA<LockedState>());
      expect(service.lockCalled, isTrue);
    });
  });
}

class _FakeVeilService implements VeilService {
  final bool isConfiguredResult;
  final bool unlockResult;

  String? createdWithPassword;
  String? lastUnlockedPassword;
  bool lockCalled = false;

  _FakeVeilService({
    required this.isConfiguredResult,
    this.unlockResult = false,
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
  Future<bool> unlockWithBiometrics() async => false;

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
