import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:veil/app/app_theme.dart';
import 'package:veil/features/settings/application/about_providers.dart';
import 'package:veil/features/settings/presentation/screens/about_screen.dart';
import 'package:veil/features/settings/presentation/screens/open_source_licenses_screen.dart';
import 'package:veil/i18n/translations.g.dart';

import '../test_localized_app.dart';

void main() {
  group('AboutScreen', () {
    testWidgets('renders app metadata and feature actions', (tester) async {
      final launcher = _FakeAboutUrlLauncher(result: true);

      await tester.pumpWidget(
        _buildApp(
          path: '/settings/about',
          launcher: launcher,
          packageInfo: _packageInfo('1.2.3'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AboutScreen), findsOneWidget);
      expect(find.text('Veil'), findsOneWidget);
      expect(find.text('About'), findsNothing);
      expect(find.text('Version 1.2.3'), findsOneWidget);
      expect(find.text('© ${DateTime.now().year} Veil'), findsOneWidget);
      expect(find.text('Source code'), findsOneWidget);
      expect(find.text('Open source licenses'), findsOneWidget);
    });

    testWidgets('opens the repository with the external launcher', (
      tester,
    ) async {
      final launcher = _FakeAboutUrlLauncher(result: true);

      await tester.pumpWidget(
        _buildApp(
          path: '/settings/about',
          launcher: launcher,
          packageInfo: _packageInfo('1.2.3'),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Source code'));
      await tester.pump();

      expect(launcher.launchedUris, [repositoryUri]);
    });

    testWidgets('shows an error when the repository cannot be opened', (
      tester,
    ) async {
      final launcher = _FakeAboutUrlLauncher(result: false);

      await tester.pumpWidget(
        _buildApp(
          path: '/settings/about',
          launcher: launcher,
          packageInfo: _packageInfo('1.2.3'),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Source code'));
      await tester.pumpAndSettle();

      expect(find.text('Could not open the repository.'), findsOneWidget);
    });

    testWidgets('shows loading and unavailable version states', (tester) async {
      await tester.pumpWidget(
        _buildApp(
          path: '/settings/about',
          launcher: _FakeAboutUrlLauncher(result: true),
          packageInfoValue: const AsyncLoading<PackageInfo>(),
        ),
      );
      await tester.pump();

      expect(find.text('Loading version...'), findsOneWidget);

      await tester.pumpWidget(
        _buildApp(
          path: '/settings/about',
          launcher: _FakeAboutUrlLauncher(result: true),
          packageInfoValue: AsyncError<PackageInfo>(
            Exception('metadata failed'),
            StackTrace.empty,
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Version unavailable'), findsOneWidget);
    });

    testWidgets('navigates to licenses and back', (tester) async {
      await tester.pumpWidget(
        _buildApp(
          path: '/settings/about',
          launcher: _FakeAboutUrlLauncher(result: true),
          packageInfo: _packageInfo('1.2.3'),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open source licenses'));
      await tester.pumpAndSettle();

      expect(find.byType(OpenSourceLicensesScreen), findsOneWidget);
      expect(find.text('Open source licenses'), findsNothing);
      expect(find.text('Open Source Licenses'), findsOneWidget);

      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      expect(find.byType(AboutScreen), findsOneWidget);
    });

    testWidgets('expands a complete license text', (tester) async {
      const license = OpenSourceLicense(
        name: 'MIT License',
        attributions: ['test-package'],
        text: 'Complete test license text',
      );

      await tester.pumpWidget(
        _buildApp(
          path: '/settings/about/licenses',
          launcher: _FakeAboutUrlLauncher(result: true),
          packageInfo: _packageInfo('1.2.3'),
          licenses: const AsyncData([license]),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('MIT License'), findsOneWidget);
      expect(find.text('• test-package'), findsOneWidget);
      expect(find.text('Complete test license text'), findsNothing);

      await tester.tap(find.text('Full license text'));
      await tester.pumpAndSettle();

      expect(find.text('Complete test license text'), findsOneWidget);
      expect(find.byType(SelectionArea), findsOneWidget);
    });
  });

  group('OpenSourceLicenseCatalog', () {
    test(
      'merges registry entries with the explicit repository catalog',
      () async {
        final catalog = OpenSourceLicenseCatalog(
          assetBundle: _FakeAssetBundle({
            'LICENSE': 'GPL project license',
            'LICENSES/MIT.txt':
                'MIT License\n\nPermission is hereby granted free of charge.',
            'LICENSES/OFL-1.1.txt': 'SIL Open Font License Version 1.1',
          }),
          registryLicenses: () => Stream.fromIterable([
            const LicenseEntryWithLineBreaks([
              'registry-mit-package',
            ], 'MIT License\n\nPermission is hereby granted free of charge.'),
            const LicenseEntryWithLineBreaks([
              'flutter-package',
            ], 'Apache License, Version 2.0'),
          ]),
        );

        final licenses = await catalog.load();

        final mit = licenses.firstWhere(
          (license) => license.name == 'MIT License',
        );
        expect(mit.attributions, contains('openpgp'));
        expect(mit.attributions, contains('registry-mit-package'));
        expect(
          licenses.where((license) => license.name == 'MIT License'),
          hasLength(1),
        );
        expect(
          licenses.any((license) => license.name == 'Apache License 2.0'),
          isTrue,
        );
      },
    );

    test(
      'consolidates all unknown entries and preserves unique license texts',
      () async {
        final catalog = OpenSourceLicenseCatalog(
          assetBundle: _FakeAssetBundle({
            'LICENSE': 'GPL project license',
            'LICENSES/MIT.txt': 'MIT project license',
            'LICENSES/OFL-1.1.txt': 'OFL project license',
          }),
          registryLicenses: () => Stream.fromIterable([
            const LicenseEntryWithLineBreaks(
              ['angle', 'angle'],
              'Unknown license text A',
            ),
            const LicenseEntryWithLineBreaks(
              ['abseil-cpp'],
              'Unknown license text B',
            ),
            const LicenseEntryWithLineBreaks(
              ['angle', 'other-package'],
              'Unknown license text A',
            ),
          ]),
        );

        final licenses = await catalog.load();
        final thirdParty = licenses.where(
          (license) => license.name == 'Third-party licenses',
        );

        expect(thirdParty, hasLength(1));
        final license = thirdParty.single;
        expect(license.attributions, contains('angle'));
        expect(license.attributions, contains('abseil-cpp'));
        expect(license.attributions, contains('other-package'));
        expect(
          license.attributions.where((attribution) => attribution == 'angle'),
          hasLength(1),
        );
        expect(license.text, contains('Unknown license text A'));
        expect(license.text, contains('Unknown license text B'));
        expect(
          'Unknown license text A'.allMatches(license.text),
          hasLength(1),
        );
      },
    );

    test('consolidates known license variants without losing their texts', () async {
      final catalog = OpenSourceLicenseCatalog(
        assetBundle: _FakeAssetBundle({
          'LICENSE': 'GPL project license',
          'LICENSES/MIT.txt': 'MIT project license',
          'LICENSES/OFL-1.1.txt': 'OFL project license',
        }),
        registryLicenses: () => Stream.fromIterable([
          const LicenseEntryWithLineBreaks(
            ['package-a'],
            'MIT License\n\nMIT variant A',
          ),
          const LicenseEntryWithLineBreaks(
            ['package-b'],
            'MIT License\n\nMIT variant B',
          ),
        ]),
      );

      final licenses = await catalog.load();
      final mit = licenses.firstWhere((license) => license.name == 'MIT License');

      expect(mit.attributions, containsAll(['openpgp', 'package-a', 'package-b']));
      expect(mit.text, contains('MIT variant A'));
      expect(mit.text, contains('MIT variant B'));
      expect(
        licenses.where((license) => license.name == 'MIT License'),
        hasLength(1),
      );
    });
  });
}

Widget _buildApp({
  required String path,
  required AboutUrlLauncher launcher,
  AsyncValue<PackageInfo>? packageInfoValue,
  PackageInfo? packageInfo,
  AsyncValue<List<OpenSourceLicense>>? licenses,
}) {
  final router = GoRouter(
    initialLocation: path,
    routes: [
      GoRoute(path: '/settings/about', builder: (_, _) => const AboutScreen()),
      GoRoute(
        path: '/settings/about/licenses',
        builder: (_, _) => const OpenSourceLicensesScreen(),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      aboutUrlLauncherProvider.overrideWithValue(launcher),
      appPackageInfoProvider.overrideWithValue(
        packageInfoValue ?? AsyncData(packageInfo!),
      ),
      if (licenses != null)
        openSourceLicensesProvider.overrideWithValue(licenses),
    ],
    child: buildLocalizedRouterApp(
      theme: AppTheme.darkTheme,
      locale: AppLocale.en,
      routerConfig: router,
    ),
  );
}

PackageInfo _packageInfo(String version) {
  return PackageInfo(
    appName: 'Veil',
    packageName: 'app.veil.veil',
    version: version,
    buildNumber: '1',
  );
}

class _FakeAboutUrlLauncher implements AboutUrlLauncher {
  final bool result;
  final List<Uri> launchedUris = [];

  _FakeAboutUrlLauncher({required this.result});

  @override
  Future<bool> launch(Uri uri) async {
    launchedUris.add(uri);
    return result;
  }
}

class _FakeAssetBundle extends CachingAssetBundle {
  final Map<String, String> values;

  _FakeAssetBundle(this.values);

  @override
  Future<ByteData> load(String key) async {
    final value = values[key];
    if (value == null) {
      throw FlutterError('Missing test asset: $key');
    }
    return ByteData.sublistView(utf8.encode(value));
  }
}
