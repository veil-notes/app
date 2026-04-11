import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../i18n/translations.g.dart';
import '../../features/veil/providers/veil_provider.dart';
import 'app_locale_service.dart';

final deviceLocaleProvider = Provider<Locale>((ref) {
  return WidgetsBinding.instance.platformDispatcher.locale;
});

final appLocaleServiceProvider = Provider<AppLocaleService>((ref) {
  return AppLocaleService(ref.read(secureStorageServiceProvider));
});

final initialAppLocaleProvider = Provider<AppLocale>((ref) {
  return AppLocale.en;
});

final appLocaleControllerProvider =
    NotifierProvider<AppLocaleController, AppLocale>(AppLocaleController.new);

class AppLocaleController extends Notifier<AppLocale> {
  @override
  AppLocale build() {
    final locale = ref.read(initialAppLocaleProvider);
    LocaleSettings.setLocaleSync(locale);
    return locale;
  }

  Future<void> setLocale(AppLocale locale) async {
    await ref.read(appLocaleServiceProvider).saveLocale(locale);
    await LocaleSettings.setLocale(locale);
    state = locale;
  }
}
