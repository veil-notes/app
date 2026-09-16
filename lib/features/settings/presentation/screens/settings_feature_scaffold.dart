import 'package:flutter/material.dart';

import '../../../../i18n/translations.g.dart';

class SettingsFeatureScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final bool showTitle;

  const SettingsFeatureScaffold({
    required this.title,
    required this.body,
    this.showTitle = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top + kToolbarHeight + 8;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leadingWidth: 72,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
          child: Material(
            elevation: 0,
            color: const Color(0xFF2A2448),
            shape: const CircleBorder(),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: const BackButton(color: Colors.white),
            ),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(top: topInset),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showTitle) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 24),
              ],
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: body,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsFeatureActionButtons extends StatelessWidget {
  final Translations t;
  final bool isLoading;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const SettingsFeatureActionButtons({
    required this.t,
    required this.isLoading,
    required this.onConfirm,
    required this.onCancel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: isLoading ? null : onConfirm,
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(t.common.actions.confirm),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: isLoading ? null : onCancel,
          child: Text(t.common.actions.cancel),
        ),
      ],
    );
  }
}
