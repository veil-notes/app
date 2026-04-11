import 'dart:ui';

import '../../core/storage/secure_storage_service.dart';
import '../../i18n/translations.g.dart';

class AppLocaleService {
  static const localeStorageKey = 'app.locale';

  final SecureStorageService _storage;

  const AppLocaleService(this._storage);

  Future<AppLocale?> getSavedLocale() async {
    final rawLocale = await _storage.read(localeStorageKey);
    if (rawLocale == null || rawLocale.isEmpty) {
      return null;
    }

    return _tryParse(rawLocale);
  }

  Future<void> saveLocale(AppLocale locale) {
    return _storage.write(localeStorageKey, locale.languageTag);
  }

  AppLocale resolveDeviceLocale(Locale deviceLocale) {
    final candidates = <String>[
      if (deviceLocale.countryCode != null &&
          deviceLocale.countryCode!.isNotEmpty)
        '${deviceLocale.languageCode}-${deviceLocale.countryCode}',
      deviceLocale.languageCode,
    ];

    for (final candidate in candidates) {
      final locale = _tryParse(candidate);
      if (locale != null) {
        return locale;
      }
    }

    return AppLocale.en;
  }

  Future<AppLocale> resolveInitialLocale({required Locale deviceLocale}) async {
    final savedLocale = await getSavedLocale();
    return savedLocale ?? resolveDeviceLocale(deviceLocale);
  }

  AppLocale? _tryParse(String rawLocale) {
    try {
      return AppLocaleUtils.parse(rawLocale);
    } catch (_) {
      return null;
    }
  }
}
