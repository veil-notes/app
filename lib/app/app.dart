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

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> with WidgetsBindingObserver {
  ProviderSubscription? _veilStateSubscription;

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
        return;
      }

      sessionController.stop();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _veilStateSubscription?.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
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
}
