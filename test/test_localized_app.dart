import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:veil/i18n/translations.g.dart';

Widget buildLocalizedApp({
  required Widget home,
  ThemeData? theme,
  AppLocale locale = AppLocale.en,
}) {
  LocaleSettings.setLocaleSync(locale);

  return TranslationProvider(
    child: Builder(
      builder: (context) {
        return MaterialApp(
          theme: theme,
          locale: locale.flutterLocale,
          supportedLocales: AppLocaleUtils.supportedLocales,
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          home: home,
        );
      },
    ),
  );
}

Widget buildLocalizedRouterApp({
  required RouterConfig<Object> routerConfig,
  ThemeData? theme,
  AppLocale locale = AppLocale.en,
}) {
  LocaleSettings.setLocaleSync(locale);

  return TranslationProvider(
    child: Builder(
      builder: (context) {
        return MaterialApp.router(
          theme: theme,
          locale: locale.flutterLocale,
          supportedLocales: AppLocaleUtils.supportedLocales,
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          routerConfig: routerConfig,
        );
      },
    ),
  );
}
