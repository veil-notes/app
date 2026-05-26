import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:veil/app/app_theme.dart';
import 'package:veil/app/router.dart';
import 'package:veil/features/notes/application/notes_service.dart';
import 'package:veil/features/notes/domain/note.dart';
import 'package:veil/features/notes/presentation/screens/note_list_screen.dart';
import 'package:veil/features/notes/providers/notes_provider.dart';
import 'package:veil/features/veil/application/veil_controller.dart';
import 'package:veil/features/veil/application/veil_service.dart';
import 'package:veil/features/veil/domain/session/auto_lock_option.dart';
import 'package:veil/features/veil/domain/states/bootstrapping_state.dart';
import 'package:veil/features/veil/domain/states/locked_state.dart';
import 'package:veil/features/veil/domain/states/uninitialized_state.dart';
import 'package:veil/features/veil/domain/states/unlocked_state.dart';
import 'package:veil/features/veil/domain/states/veil_state.dart';
import 'package:veil/features/veil/providers/veil_provider.dart';

import '../test_localized_app.dart';

void main() {
  group('routerProvider', () {
    testWidgets('keeps bootstrapping users on the splash route', (
      tester,
    ) async {
      final harness = _RouterHarness(
        state: (service) => BootstrappingState(service),
      );
      addTearDown(harness.dispose);

      await tester.pumpWidget(harness.build());
      await _pumpRouter(tester);

      expect(find.text('Loading...'), findsOneWidget);
      expect(harness.router.state.matchedLocation, '/');
    });

    testWidgets('redirects uninitialized users to setup', (tester) async {
      final harness = _RouterHarness(
        state: (service) => UninitializedState(service),
      );
      addTearDown(harness.dispose);

      await tester.pumpWidget(harness.build());
      await _pumpRouter(tester);

      expect(find.text("Let's start!"), findsOneWidget);
      expect(harness.router.state.matchedLocation, '/setup');
    });

    testWidgets('redirects locked users to unlock', (tester) async {
      final harness = _RouterHarness(state: (service) => LockedState(service));
      addTearDown(harness.dispose);

      await tester.pumpWidget(harness.build());
      await _pumpRouter(tester);

      expect(find.text('Unlock'), findsOneWidget);
      expect(harness.router.state.matchedLocation, '/unlock');
    });

    testWidgets(
      'redirects unlocked users from public routes to the note list',
      (tester) async {
        final harness = _RouterHarness(
          state: (service) => UnlockedState(service),
        );
        addTearDown(harness.dispose);

        await tester.pumpWidget(harness.build());
        await _pumpRouter(tester);

        expect(harness.router.state.matchedLocation, '/list');
        expect(find.byType(NoteListScreen), findsOneWidget);
      },
    );

    testWidgets('allows unlocked users to open settings', (tester) async {
      final harness = _RouterHarness(
        state: (service) => UnlockedState(service),
      );
      addTearDown(harness.dispose);

      await tester.pumpWidget(harness.build());
      await _pumpRouter(tester);

      harness.router.go('/settings');
      await _pumpRouter(tester);

      expect(find.text('Biometrics'), findsOneWidget);
      expect(harness.router.state.matchedLocation, '/settings');
    });

    testWidgets('builds the note route with an id parameter', (tester) async {
      final harness = _RouterHarness(
        state: (service) => UnlockedState(service),
      );
      addTearDown(harness.dispose);

      await tester.pumpWidget(harness.build());
      await _pumpRouter(tester);

      harness.router.go('/note/note-42');
      await _pumpRouter(tester);

      expect(find.text('Opened note'), findsOneWidget);
      expect(harness.router.state.matchedLocation, '/note/note-42');
    });

    testWidgets('locked redirect preserves current route in from query', (
      tester,
    ) async {
      final harness = _RouterHarness(state: (service) => LockedState(service));
      addTearDown(harness.dispose);

      harness.router.go('/note/note-42');
      await tester.pump();

      await tester.pumpWidget(harness.build());
      await _pumpRouter(tester);

      expect(harness.router.state.matchedLocation, '/unlock');
      expect(harness.router.state.uri.queryParameters['from'], '/note/note-42');
    });

    testWidgets('unlocked user on unlock route restores from query route', (
      tester,
    ) async {
      final harness = _RouterHarness(
        state: (service) => UnlockedState(service),
      );
      addTearDown(harness.dispose);

      harness.router.go('/unlock?from=%2Fnote%2Fnote-42');
      await tester.pump();

      await tester.pumpWidget(harness.build());
      await _pumpRouter(tester);

      expect(harness.router.state.matchedLocation, '/note/note-42');
      expect(find.text('Opened note'), findsOneWidget);
    });

    testWidgets(
      'unlocked user ignores public from route and falls back to list',
      (tester) async {
        final harness = _RouterHarness(
          state: (service) => UnlockedState(service),
        );
        addTearDown(harness.dispose);

        harness.router.go('/unlock?from=%2Funlock');
        await tester.pump();

        await tester.pumpWidget(harness.build());
        await _pumpRouter(tester);

        expect(harness.router.state.matchedLocation, '/list');
      },
    );

    testWidgets('restores note route after lock then unlock', (tester) async {
      final harness = _RouterHarness(
        state: (service) => UnlockedState(service),
      );
      addTearDown(harness.dispose);

      await tester.pumpWidget(harness.build());
      await _pumpRouter(tester);

      harness.router.go('/note/note-42');
      await _pumpRouter(tester);
      expect(harness.router.state.matchedLocation, '/note/note-42');

      harness.controller.setVeilState(LockedState(harness.service));
      await _pumpRouter(tester);
      expect(harness.router.state.matchedLocation, '/unlock');
      expect(harness.router.state.uri.queryParameters['from'], '/note/note-42');

      harness.controller.setVeilState(UnlockedState(harness.service));
      await _pumpRouter(tester);
      expect(harness.router.state.matchedLocation, '/note/note-42');
    });
  });
}

Future<void> _pumpRouter(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
  await tester.pump(const Duration(milliseconds: 50));
}

class _RouterHarness {
  final _FakeVeilService service = _FakeVeilService();
  late final _FakeVeilController controller;
  late final ProviderContainer container;
  late final GoRouter router;

  _RouterHarness({
    required VeilState Function(_FakeVeilService service) state,
  }) {
    controller = _FakeVeilController(state(service));
    container = ProviderContainer(
      overrides: [
        veilServiceProvider.overrideWithValue(service),
        veilControllerProvider.overrideWith(() => controller),
        canUseBiometricUnlockProvider.overrideWith((ref) async => false),
        isBiometricEnabledProvider.overrideWith((ref) async => false),
        autoLockOptionProvider.overrideWith(
          (ref) async => AutoLockOption.fiveMinutes,
        ),
        notesListProvider.overrideWith((ref) async => const []),
        notesServiceProvider.overrideWithValue(_FakeNotesService()),
      ],
    );
    router = container.read(routerProvider);
  }

  Widget build() {
    return UncontrolledProviderScope(
      container: container,
      child: buildLocalizedRouterApp(
        theme: AppTheme.darkTheme,
        routerConfig: router,
      ),
    );
  }

  void dispose() {
    router.dispose();
    container.dispose();
  }
}

class _FakeVeilController extends VeilController {
  final VeilState initialState;

  _FakeVeilController(this.initialState);

  @override
  VeilState build() => initialState;

  void setVeilState(VeilState next) {
    state = next;
  }
}

class _FakeVeilService implements VeilService {
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
  void lock() {}

  @override
  Future<void> setAutoLockOption(AutoLockOption option) async {}

  @override
  Future<bool> unlock(String password) async => true;

  @override
  Future<bool> unlockWithBiometrics() async => true;
}

class _FakeNotesService implements NotesService {
  @override
  Future<Note> createEmpty() async {
    return Note(
      id: 'new-note',
      content: '',
      createdAt: DateTime(2026, 4, 10, 9, 0),
      updatedAt: DateTime(2026, 4, 10, 9, 0),
    );
  }

  @override
  Future<void> delete(String id) async {}

  @override
  Future<List<Note>> list() async => const [];

  @override
  Future<Note> open(String id) async {
    return Note(
      id: id,
      content: 'Opened note',
      createdAt: DateTime(2026, 4, 10, 9, 0),
      updatedAt: DateTime(2026, 4, 10, 9, 0),
    );
  }

  @override
  Future<void> save(Note note) async {}
}
