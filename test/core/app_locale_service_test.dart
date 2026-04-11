import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:veil/app/locale/app_locale_service.dart';
import 'package:veil/core/storage/secure_storage_service.dart';
import 'package:veil/i18n/translations.g.dart';

void main() {
  group('AppLocaleService', () {
    test('uses the saved locale when present', () async {
      final storage = _FakeSecureStorageService(
        values: {AppLocaleService.localeStorageKey: 'pt-BR'},
      );
      final service = AppLocaleService(storage);

      final locale = await service.resolveInitialLocale(
        deviceLocale: const Locale('pt', 'BR'),
      );

      expect(locale, AppLocale.ptBr);
    });

    test('uses the device locale when no preference is saved', () async {
      final service = AppLocaleService(_FakeSecureStorageService());

      final locale = await service.resolveInitialLocale(
        deviceLocale: const Locale('en'),
      );

      expect(locale, AppLocale.en);
    });

    test('falls back to en for unsupported device locales', () async {
      final service = AppLocaleService(_FakeSecureStorageService());

      final locale = await service.resolveInitialLocale(
        deviceLocale: const Locale('it'),
      );

      expect(locale, AppLocale.en);
    });

    test('persists the chosen locale', () async {
      final storage = _FakeSecureStorageService();
      final service = AppLocaleService(storage);

      await service.saveLocale(AppLocale.ptBr);

      expect(storage.values[AppLocaleService.localeStorageKey], 'pt-BR');
    });
  });
}

class _FakeSecureStorageService implements SecureStorageService {
  final Map<String, String> values;

  _FakeSecureStorageService({Map<String, String>? values})
    : values = values ?? {};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async {
    values[key] = value;
  }
}
