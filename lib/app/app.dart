import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/veil/domain/states/unlocked_state.dart';
import '../features/veil/providers/veil_provider.dart';
import '../i18n/translations.g.dart';
import 'app_theme.dart';
import 'locale/app_locale_provider.dart';
import 'router.dart';

import 'shortcuts/app_shortcut_action.dart';
import 'shortcuts/shortcut_provider.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> with WidgetsBindingObserver {
  ProviderSubscription? _veilStateSubscription;
  StreamSubscription<AppShortcutAction>? _shortcutSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _veilStateSubscription = ref.listenManual(veilControllerProvider, (
      previous,
      next,
    ) async {
      final sessionController = ref.read(veilSessionControllerProvider);

      if (next is UnlockedState) {
        final autoLockOption = await ref.read(autoLockOptionProvider.future);
        sessionController.updateTimeout(autoLockOption.duration);
        sessionController.start();
        _consumePendingShortcutIfNeeded(next);
        return;
      }

      sessionController.stop();
    });

    final shortcutService = ref.read(shortcutIntentServiceProvider);

    shortcutService.initialize().then((initialAction) {
      if (!mounted || initialAction == null) {
        return;
      }
      _handleShortcutAction(initialAction);
    });

    _shortcutSubscription = shortcutService.actions.listen(
      _handleShortcutAction,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _veilStateSubscription?.close();
    _shortcutSubscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      final biometricPromptInProgress = ref.read(
        biometricPromptInProgressProvider,
      );

      if (biometricPromptInProgress) {
        return;
      }

      final veilState = ref.read(veilControllerProvider);

      if (veilState is UnlockedState) {
        ref.read(veilControllerProvider.notifier).lock();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessionController = ref.read(veilSessionControllerProvider);
    final appLocale = ref.watch(appLocaleControllerProvider);

    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) {
        final veilState = ref.read(veilControllerProvider);

        if (veilState is UnlockedState) {
          sessionController.refresh();
        }
      },
      child: MaterialApp.router(
        debugShowCheckedModeBanner: kDebugMode || kProfileMode,
        locale: appLocale.flutterLocale,
        supportedLocales: AppLocaleUtils.supportedLocales,
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        title: appLocale.translations.app.title,
        routerConfig: ref.watch(routerProvider),
        theme: AppTheme.darkTheme,
        darkTheme: AppTheme.darkTheme,
      ),
    );
  }

  void _handleShortcutAction(AppShortcutAction action) {
    ref.read(pendingShortcutActionProvider.notifier).set(action);

    final state = ref.read(veilControllerProvider);
    _consumePendingShortcutIfNeeded(state);
  }

  void _consumePendingShortcutIfNeeded(Object veilState) {
    if (veilState is! UnlockedState) {
      return;
    }

    final pending = ref.read(pendingShortcutActionProvider);
    if (pending == AppShortcutAction.newNote) {
      ref.read(pendingShortcutActionProvider.notifier).consume();

      final router = ref.read(routerProvider);
      final currentPath = router.routeInformationProvider.value.uri.path;

      if (currentPath != '/list') {
        router.go('/list');
      }

      router.push('/note');
    }
  }
}
