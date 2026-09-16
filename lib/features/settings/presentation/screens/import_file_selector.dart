import 'package:flutter/material.dart';

class ImportFileSelector extends StatelessWidget {
  final String? fileName;
  final bool isLoading;
  final VoidCallback onTap;
  final String selectTitle;
  final String selectSubtitle;
  final String changeSubtitle;
  final String loadingLabel;

  const ImportFileSelector({
    required this.fileName,
    required this.isLoading,
    required this.onTap,
    required this.selectTitle,
    required this.selectSubtitle,
    required this.changeSubtitle,
    required this.loadingLabel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasFile = fileName != null;
    final title = hasFile ? fileName! : selectTitle;
    final subtitle = hasFile ? changeSubtitle : selectSubtitle;
    final borderColor = hasFile
        ? theme.colorScheme.primary
        : theme.colorScheme.outline;

    return Semantics(
      button: true,
      enabled: !isLoading,
      label: title,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                if (isLoading)
                  const SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  )
                else
                  Icon(
                    hasFile ? Icons.description_outlined : Icons.upload_file,
                    size: 32,
                    color: theme.colorScheme.primary,
                  ),
                const SizedBox(width: 16),
                Expanded(
                  child: isLoading
                      ? Text(loadingLabel)
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(subtitle),
                          ],
                        ),
                ),
                if (!isLoading)
                  Icon(
                    hasFile ? Icons.refresh : Icons.chevron_right,
                    color: theme.colorScheme.primary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
