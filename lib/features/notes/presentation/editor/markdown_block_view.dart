import 'package:flutter/material.dart';

import '../../domain/editor/markdown_block.dart';
import 'markdown_inline_text_builder.dart';

class MarkdownBlockView extends StatefulWidget {
  final MarkdownBlock block;
  final VoidCallback onTap;
  final ValueChanged<bool>? onChecklistChanged;
  final ValueChanged<Uri>? onOpenLink;

  const MarkdownBlockView({
    super.key,
    required this.block,
    required this.onTap,
    this.onChecklistChanged,
    this.onOpenLink,
  });

  @override
  State<MarkdownBlockView> createState() => _MarkdownBlockViewState();
}

class _MarkdownBlockViewState extends State<MarkdownBlockView> {
  late final MarkdownInlineTextBuilder _inlineBuilder;

  @override
  void initState() {
    super.initState();

    _inlineBuilder = MarkdownInlineTextBuilder(
      onOpenLink: (uri) => widget.onOpenLink?.call(uri),
    );
  }

  @override
  void dispose() {
    _inlineBuilder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final baseStyle = Theme.of(context).textTheme.bodyMedium;
    final linkColor = Theme.of(context).colorScheme.primary;

    return switch (widget.block) {
      HeadingBlock(:final level, :final text) => Text.rich(
        _inlineBuilder.build(
          text,
          style: _headingStyle(context, level),
          linkColor: linkColor,
        ),
      ),
      ChecklistItemBlock(:final checked, :final text) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: checked,
            visualDensity: const VisualDensity(horizontal: -4, vertical: -2),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onChanged: widget.onChecklistChanged == null
                ? null
                : (value) => widget.onChecklistChanged!(value ?? false),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text.rich(
                _inlineBuilder.build(
                  text,
                  style: baseStyle?.copyWith(
                    decoration: checked ? TextDecoration.lineThrough : null,
                  ),
                  linkColor: linkColor,
                ),
              ),
            ),
          ),
        ],
      ),
      BulletListItemBlock(:final text) => Text.rich(
        TextSpan(
          children: [
            TextSpan(text: '• ', style: baseStyle),
            _inlineBuilder.build(
              text,
              style: baseStyle,
              linkColor: linkColor,
            ),
          ],
        ),
      ),
      OrderedListItemBlock(:final number, :final text) => Text.rich(
        TextSpan(
          children: [
            TextSpan(text: '$number. ', style: baseStyle),
            _inlineBuilder.build(
              text,
              style: baseStyle,
              linkColor: linkColor,
            ),
          ],
        ),
      ),
      ParagraphBlock(:final raw) => Text.rich(
        _inlineBuilder.build(
          raw,
          style: baseStyle,
          linkColor: linkColor,
        ),
      ),
    };
  }

  TextStyle _headingStyle(BuildContext context, int level) {
    final base = Theme.of(context).textTheme.titleLarge!;

    return switch (level) {
      1 => base.copyWith(fontSize: 28, fontWeight: FontWeight.w800),
      2 => base.copyWith(fontSize: 22, fontWeight: FontWeight.w800),
      3 => base.copyWith(fontSize: 20, fontWeight: FontWeight.w700),
      4 => base.copyWith(fontSize: 18, fontWeight: FontWeight.w700),
      _ => base.copyWith(fontSize: 16, fontWeight: FontWeight.w700),
    };
  }
}