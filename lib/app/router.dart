import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:veil/features/settings/presentation/screens/settings_screen.dart';
import 'package:veil/features/veil/domain/states/bootstrapping_state.dart';
import 'package:veil/features/veil/presentation/screens/setup_screen.dart';
import 'package:veil/features/veil/presentation/screens/unlock_screen.dart';

import '../features/notes/presentation/screens/note_list_screen.dart';
import '../features/notes/presentation/editor/note_screen.dart';
import '../features/veil/domain/states/locked_state.dart';
import '../features/veil/domain/states/uninitialized_state.dart';
import '../features/veil/domain/states/unlocked_state.dart';
import '../features/veil/providers/veil_provider.dart';
import '../features/veil/presentation/screens/splash_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  late final GoRouter router;

  router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final veilState = ref.read(veilControllerProvider);
      final location = state.matchedLocation;

      final isBootstrapping = veilState is BootstrappingState;
      final isUninitialized = veilState is UninitializedState;
      final isLocked = veilState is LockedState;
      final isUnlocked = veilState is UnlockedState;

      final isSplashRoute = location == '/';
      final isSetupRoute = location == '/setup';
      final isUnlockRoute = location == '/unlock';

      if (isBootstrapping) {
        return isSplashRoute ? null : '/';
      }

      if (isUninitialized) {
        return isSetupRoute ? null : '/setup';
      }

      if (isLocked) {
        if (isUnlockRoute) {
          return null;
        }

        final from = state.uri.toString();
        return Uri(path: '/unlock', queryParameters: {'from': from}).toString();
      }

      if (isUnlocked) {
        if (isUnlockRoute) {
          final from = state.uri.queryParameters['from'];
          if (from != null &&
              from.isNotEmpty &&
              from != '/' &&
              from != '/setup' &&
              !from.startsWith('/unlock')) {
            return from;
          }

          return '/list';
        }

        if (isSplashRoute || isSetupRoute) {
          return '/list';
        }

        return null;
      }

      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (_, _) => const SplashScreen()),
      GoRoute(path: '/setup', builder: (_, _) => const SetupScreen()),
      GoRoute(path: '/unlock', builder: (_, _) => const UnlockScreen()),
      GoRoute(path: '/list', builder: (_, _) => const NoteListScreen()),
      GoRoute(path: '/settings', builder: (_, _) => const SettingsScreen()),
      GoRoute(path: '/note', builder: (_, _) => const NoteScreen()),
      GoRoute(
        path: '/note/:id',
        builder: (_, state) {
          final id = state.pathParameters['id']!;
          return NoteScreen(id: id);
        },
      ),
    ],
  );

  ref.listen(veilControllerProvider, (_, _) {
    router.refresh();
  });

  return router;
});
