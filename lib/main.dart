import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'app/app.dart';
import 'app/locale/app_locale_provider.dart';
import 'app/locale/app_locale_service.dart';
import 'core/storage/infra/flutter_secure_storage_service.dart';
import 'features/veil/providers/veil_provider.dart';
import 'i18n/translations.g.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final secureStorageService = FlutterSecureStorageService(
    const FlutterSecureStorage(),
  );
  final appLocaleService = AppLocaleService(secureStorageService);
  final initialLocale = await appLocaleService.resolveInitialLocale(
    deviceLocale: WidgetsBinding.instance.platformDispatcher.locale,
  );

  await LocaleSettings.setLocale(initialLocale);

  runApp(
    ProviderScope(
      overrides: [
        secureStorageServiceProvider.overrideWithValue(secureStorageService),
        appLocaleServiceProvider.overrideWithValue(appLocaleService),
        initialAppLocaleProvider.overrideWithValue(initialLocale),
      ],
      child: TranslationProvider(child: const App()),
    ),
  );
}
