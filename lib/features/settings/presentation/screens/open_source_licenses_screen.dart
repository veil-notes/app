import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../i18n/translations.g.dart';
import '../../application/about_providers.dart';
import 'settings_feature_scaffold.dart';

class OpenSourceLicensesScreen extends ConsumerWidget {
  const OpenSourceLicensesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final licensesAsync = ref.watch(openSourceLicensesProvider);

    return SettingsFeatureScaffold(
      title: context.t.settings.about.licensesTitle,
      showTitle: false,
      body: licensesAsync.when(
        data: (licenses) => _LicenseList(licenses: licenses),
        loading: () => Center(
          child: CircularProgressIndicator(
            semanticsLabel: context.t.settings.about.licensesLoading,
          ),
        ),
        error: (_, _) => Center(
          child: Text(
            context.t.settings.about.licensesError,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _LicenseList extends StatelessWidget {
  final List<OpenSourceLicense> licenses;

  const _LicenseList({required this.licenses});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colorScheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        Text(
          t.settings.about.licensesHeading,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Text(t.settings.about.licensesIntro),
        const SizedBox(height: 24),
        ...licenses.map(
          (license) => _LicenseSection(
            license: license,
            primaryColor: colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

class _LicenseSection extends StatelessWidget {
  final OpenSourceLicense license;
  final Color primaryColor;

  const _LicenseSection({required this.license, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            license.name,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: primaryColor,
              decoration: TextDecoration.underline,
              decorationColor: primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          ...license.attributions.map(
            (attribution) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text('• $attribution'),
            ),
          ),
          const SizedBox(height: 4),
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            childrenPadding: EdgeInsets.zero,
            title: Text(t.settings.about.fullLicenseText),
            children: [
              SelectionArea(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    license.text,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
