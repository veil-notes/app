import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../i18n/translations.g.dart';
import '../../application/about_providers.dart';
import 'settings_feature_scaffold.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final packageInfoAsync = ref.watch(appPackageInfoProvider);

    return SettingsFeatureScaffold(
      title: t.settings.about.title,
      showTitle: false,
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          _AboutHeader(packageInfoAsync: packageInfoAsync),
          const SizedBox(height: 32),
          ListTile(
            leading: const Icon(Icons.code_outlined),
            title: Text(
              t.settings.about.repositoryTitle,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              t.settings.about.repositorySubtitle,
              style: const TextStyle(fontSize: 12),
            ),
            trailing: const Icon(Icons.open_in_new),
            onTap: () => unawaited(_openRepository(context, ref)),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text(
              t.settings.about.licensesTitle,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              t.settings.about.licensesSubtitle,
              style: const TextStyle(fontSize: 12),
            ),
            onTap: () => context.push('/settings/about/licenses'),
          ),
        ],
      ),
    );
  }

  Future<void> _openRepository(BuildContext context, WidgetRef ref) async {
    final opened = await ref
        .read(aboutUrlLauncherProvider)
        .launch(repositoryUri);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.t.settings.about.repositoryError)),
      );
    }
  }
}

class _AboutHeader extends StatelessWidget {
  final AsyncValue<PackageInfo> packageInfoAsync;

  const _AboutHeader({required this.packageInfoAsync});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final copyright = '© ${DateTime.now().year} ${t.app.title}';
    final version = packageInfoAsync.when(
      data: (packageInfo) =>
          t.settings.about.version(version: packageInfo.version),
      loading: () => t.settings.about.versionLoading,
      error: (_, _) => t.settings.about.versionUnavailable,
    );
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Text(
            t.app.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            version,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.72),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            copyright,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.56),
            ),
          ),
        ],
      ),
    );
  }
}
