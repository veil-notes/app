import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:veil/app/app.dart';
import 'package:veil/app/router.dart';
import 'package:veil/features/veil/application/veil_controller.dart';
import 'package:veil/features/veil/application/veil_service.dart';
import 'package:veil/features/veil/application/veil_session_controller.dart';
import 'package:veil/features/veil/domain/session/auto_lock_option.dart';
import 'package:veil/features/veil/domain/states/locked_state.dart';
import 'package:veil/features/veil/domain/states/unlocked_state.dart';
import 'package:veil/features/veil/domain/states/veil_state.dart';
import 'package:veil/features/veil/providers/veil_provider.dart';

void main() {
  testWidgets('should instantiate App widget', (WidgetTester tester) async {
    final harness = _AppHarness(
      initialStateBuilder: (service) => LockedState(service),
    );
    addTearDown(harness.dispose);

    await tester.pumpWidget(harness.build());

    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('starts the session timer when veil becomes unlocked', (
    WidgetTester tester,
  ) async {
    final harness = _AppHarness(
      initialStateBuilder: (service) => LockedState(service),
    );
    addTearDown(harness.dispose);

    await tester.pumpWidget(harness.build());
    harness.controller.emit(UnlockedState(harness.service));
    await tester.pump();
    await tester.pump();

    expect(
      harness.sessionController.lastUpdatedTimeout,
      AutoLockOption.fifteenMinutes.duration,
    );
    expect(harness.sessionController.startCalls, 1);
  });

  testWidgets('stops the session timer when veil leaves unlocked state', (
    WidgetTester tester,
  ) async {
    final harness = _AppHarness(
      initialStateBuilder: (service) => LockedState(service),
    );
    addTearDown(harness.dispose);

    await tester.pumpWidget(harness.build());
    harness.controller.emit(UnlockedState(harness.service));
    await tester.pump();
    await tester.pump();

    harness.controller.emit(LockedState(harness.service));
    await tester.pump();

    expect(harness.sessionController.stopCalls, 1);
  });

  testWidgets('locks the veil when app is paused while unlocked', (
    WidgetTester tester,
  ) async {
    final harness = _AppHarness(
      initialStateBuilder: (service) => UnlockedState(service),
    );
    addTearDown(harness.dispose);

    await tester.pumpWidget(harness.build());
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pump();

    expect(harness.controller.lockCalls, 1);
  });

  testWidgets('locks the veil when app becomes inactive or detached', (
    WidgetTester tester,
  ) async {
    final harness = _AppHarness(
      initialStateBuilder: (service) => UnlockedState(service),
    );
    addTearDown(harness.dispose);

    await tester.pumpWidget(harness.build());
    await tester.pump();
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.detached);
    await tester.pump();

    expect(harness.controller.lockCalls, 1);
  });

  testWidgets('does not lock while biometric prompt is in progress', (
    WidgetTester tester,
  ) async {
    final harness = _AppHarness(
      initialStateBuilder: (service) => UnlockedState(service),
      biometricPromptInProgress: true,
    );
    addTearDown(harness.dispose);

    await tester.pumpWidget(harness.build());
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pump();

    expect(harness.controller.lockCalls, 0);
  });

  testWidgets(
    'refreshes the session timer on pointer interaction when unlocked',
    (WidgetTester tester) async {
      final harness = _AppHarness(
        initialStateBuilder: (service) => UnlockedState(service),
      );
      addTearDown(harness.dispose);

      await tester.pumpWidget(harness.build());
      await tester.tapAt(const Offset(20, 20));
      await tester.pump();

      expect(harness.sessionController.refreshCalls, 1);
    },
  );

  testWidgets('ignores pointer interaction when veil is locked', (
    WidgetTester tester,
  ) async {
    final harness = _AppHarness(
      initialStateBuilder: (service) => LockedState(service),
    );
    addTearDown(harness.dispose);

    await tester.pumpWidget(harness.build());
    await tester.tapAt(const Offset(20, 20));
    await tester.pump();

    expect(harness.sessionController.refreshCalls, 0);
  });
}

class _AppHarness {
  final _FakeVeilService service = _FakeVeilService();
  late final _FakeVeilSessionController sessionController;
  late final _FakeVeilController controller;
  late final GoRouter router;
  late final ProviderContainer container;

  _AppHarness({
    required VeilState Function(_FakeVeilService service) initialStateBuilder,
    bool biometricPromptInProgress = false,
  }) {
    sessionController = _FakeVeilSessionController(
      timeout: const Duration(minutes: 5),
    );
    controller = _FakeVeilController(initialStateBuilder(service));
    router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) =>
              const SizedBox.expand(child: ColoredBox(color: Colors.black)),
        ),
      ],
    );
    container = ProviderContainer(
      overrides: [
        routerProvider.overrideWithValue(router),
        veilServiceProvider.overrideWithValue(service),
        autoLockOptionProvider.overrideWith(
          (ref) async => AutoLockOption.fifteenMinutes,
        ),
        veilSessionControllerProvider.overrideWithValue(sessionController),
        biometricPromptInProgressProvider.overrideWith(
          () => _FakeBiometricPromptNotifier(biometricPromptInProgress),
        ),
        veilControllerProvider.overrideWith(() => controller),
      ],
    );
  }

  Widget build() {
    return UncontrolledProviderScope(container: container, child: const App());
  }

  void dispose() {
    router.dispose();
    container.dispose();
  }
}

class _FakeVeilController extends VeilController {
  final VeilState initialState;
  int lockCalls = 0;

  _FakeVeilController(this.initialState);

  @override
  VeilState build() => initialState;

  void emit(VeilState next) {
    state = next;
  }

  @override
  void lock() {
    lockCalls++;
    state = state.onTimeout();
  }
}

class _FakeBiometricPromptNotifier extends BiometricPromptInProgressNotifier {
  final bool _initialValue;

  _FakeBiometricPromptNotifier(this._initialValue);

  @override
  bool build() => _initialValue;
}

class _FakeVeilSessionController extends VeilSessionController {
  int startCalls = 0;
  int stopCalls = 0;
  int refreshCalls = 0;
  Duration? lastUpdatedTimeout;

  _FakeVeilSessionController({required super.timeout})
    : super(onTimeout: () {});

  @override
  void refresh() {
    refreshCalls++;
  }

  @override
  void start() {
    startCalls++;
  }

  @override
  void stop() {
    stopCalls++;
  }

  @override
  void updateTimeout(Duration timeout) {
    lastUpdatedTimeout = timeout;
  }
}

class _FakeVeilService implements VeilService {
  int lockCalls = 0;

  @override
  Future<bool> canUseBiometricUnlock() async => false;

  @override
  Future<void> create(String password) async {}

  @override
  Future<void> disableBiometricUnlock() async {}

  @override
  Future<void> enableBiometricUnlock(String password) async {}

  @override
  Future<AutoLockOption> getAutoLockOption() async =>
      AutoLockOption.fiveMinutes;

  @override
  Future<bool> isBiometricEnabled() async => false;

  @override
  Future<bool> isConfigured() async => true;

  @override
  void lock() {
    lockCalls++;
  }

  @override
  Future<void> setAutoLockOption(AutoLockOption option) async {}

  @override
  Future<bool> unlock(String password) async => true;

  @override
  Future<bool> unlockWithBiometrics() async => true;
}
