import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

final repositoryUri = Uri.parse('https://github.com/veil-notes/app');

abstract interface class AboutUrlLauncher {
  Future<bool> launch(Uri uri);
}

class PlatformAboutUrlLauncher implements AboutUrlLauncher {
  const PlatformAboutUrlLauncher();

  @override
  Future<bool> launch(Uri uri) {
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

final aboutUrlLauncherProvider = Provider<AboutUrlLauncher>((ref) {
  return const PlatformAboutUrlLauncher();
});

final appPackageInfoProvider = FutureProvider<PackageInfo>((ref) {
  return PackageInfo.fromPlatform();
});

@immutable
class OpenSourceLicense {
  final String name;
  final List<String> attributions;
  final String text;

  const OpenSourceLicense({
    required this.name,
    required this.attributions,
    required this.text,
  });
}

class OpenSourceLicenseCatalog {
  final AssetBundle assetBundle;
  final Stream<LicenseEntry> Function() registryLicenses;

  OpenSourceLicenseCatalog({
    AssetBundle? assetBundle,
    Stream<LicenseEntry> Function()? registryLicenses,
  }) : assetBundle = assetBundle ?? rootBundle,
       registryLicenses = registryLicenses ?? (() => LicenseRegistry.licenses);

  Future<List<OpenSourceLicense>> load() async {
    final licenses = <_LicenseRecord>[];

    for (final descriptor in _staticDescriptors) {
      final text = await assetBundle.loadString(descriptor.assetPath);
      licenses.add(
        _LicenseRecord(
          key: descriptor.key,
          name: descriptor.name,
          attributions: descriptor.attributions,
          text: text,
        ),
      );
    }

    await for (final entry in registryLicenses()) {
      final packages = entry.packages.toSet().toList(growable: false);
      final text = _entryText(entry);
      if (text.trim().isEmpty || packages.isEmpty) {
        continue;
      }

      final key = _licenseKey(text);
      licenses.add(
        _LicenseRecord(
          key: key,
          name: _licenseName(key),
          attributions: packages,
          text: text,
        ),
      );
    }

    return _merge(licenses);
  }

  List<OpenSourceLicense> _merge(List<_LicenseRecord> records) {
    final merged = <String, _MutableLicense>{};

    for (final record in records) {
      final existing = merged[record.key];
      if (existing == null) {
        merged[record.key] = _MutableLicense(
          name: record.name,
          attributions: [...record.attributions],
          texts: [record.text],
          normalizedTexts: {_normalize(record.text)},
        );
        continue;
      }

      for (final attribution in record.attributions) {
        if (!existing.attributions.contains(attribution)) {
          existing.attributions.add(attribution);
        }
      }

      if (existing.normalizedTexts.add(_normalize(record.text))) {
        existing.texts.add(record.text);
      }
    }

    return merged.values
        .map(
          (license) => OpenSourceLicense(
            name: license.name,
            attributions: List.unmodifiable(license.attributions),
            text: license.text,
          ),
        )
        .toList(growable: false);
  }

  String _entryText(LicenseEntry entry) {
    return entry.paragraphs
        .map((paragraph) {
          if (paragraph.indent <= 0) {
            return paragraph.text;
          }

          return '${'  ' * paragraph.indent}${paragraph.text}';
        })
        .join('\n\n');
  }

  String _licenseKey(String text) {
    final normalized = _normalize(text);

    if (normalized.contains('mit license') ||
        normalized.contains('permission is hereby granted free of charge')) {
      return 'mit';
    }
    if (normalized.contains('gnu general public license')) {
      return 'gpl-3.0';
    }
    if (normalized.contains('sil open font license')) {
      return 'ofl-1.1';
    }
    if (normalized.contains('apache license')) {
      return 'apache-2.0';
    }
    if (normalized.contains(
      'redistribution and use in source and binary forms',
    )) {
      return 'bsd';
    }

    return 'third-party';
  }

  String _licenseName(String key) {
    switch (key) {
      case 'mit':
        return 'MIT License';
      case 'gpl-3.0':
        return 'GNU General Public License v3.0';
      case 'ofl-1.1':
        return 'SIL Open Font License 1.1';
      case 'apache-2.0':
        return 'Apache License 2.0';
      case 'bsd':
        return 'BSD License';
      default:
        return 'Third-party licenses';
    }
  }

  String _normalize(String text) {
    return text.replaceAll(RegExp(r'\s+'), ' ').trim().toLowerCase();
  }
}

final openSourceLicenseCatalogProvider = Provider<OpenSourceLicenseCatalog>(
  (ref) => OpenSourceLicenseCatalog(),
);

final openSourceLicensesProvider = FutureProvider<List<OpenSourceLicense>>((
  ref,
) {
  return ref.watch(openSourceLicenseCatalogProvider).load();
});

class _LicenseDescriptor {
  final String key;
  final String name;
  final String assetPath;
  final List<String> attributions;

  const _LicenseDescriptor({
    required this.key,
    required this.name,
    required this.assetPath,
    required this.attributions,
  });
}

const _staticDescriptors = [
  _LicenseDescriptor(
    key: 'gpl-3.0',
    name: 'GNU General Public License v3.0',
    assetPath: 'LICENSE',
    attributions: ['Veil'],
  ),
  _LicenseDescriptor(
    key: 'mit',
    name: 'MIT License',
    assetPath: 'LICENSES/MIT.txt',
    attributions: ['openpgp', 'openpgp-mobile', 'cupertino_icons'],
  ),
  _LicenseDescriptor(
    key: 'ofl-1.1',
    name: 'SIL Open Font License 1.1',
    assetPath: 'LICENSES/OFL-1.1.txt',
    attributions: ['Inter font'],
  ),
];

class _LicenseRecord {
  final String key;
  final String name;
  final List<String> attributions;
  final String text;

  const _LicenseRecord({
    required this.key,
    required this.name,
    required this.attributions,
    required this.text,
  });
}

class _MutableLicense {
  final String name;
  final List<String> attributions;
  final List<String> texts;
  final Set<String> normalizedTexts;

  _MutableLicense({
    required this.name,
    required this.attributions,
    required this.texts,
    required this.normalizedTexts,
  });

  String get text => texts.join('\n\n${'-' * 80}\n\n');
}
