import 'package:flutter/material.dart';

import '../../domain/editor/markdown_block.dart';

import 'markdown_inline_text_builder.dart';

class MarkdownBlockView extends StatelessWidget {
  final MarkdownBlock block;
  final VoidCallback onTap;
  final ValueChanged<bool>? onChecklistChanged;

  const MarkdownBlockView({
    super.key,
    required this.block,
    required this.onTap,
    this.onChecklistChanged,
  });

  static const _inlineBuilder = MarkdownInlineTextBuilder();

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: onTap, child: _buildContent(context));
  }

  Widget _buildContent(BuildContext context) {
    final baseStyle = Theme.of(context).textTheme.bodyMedium;

    return switch (block) {
      HeadingBlock(:final level, :final text) => Text.rich(
        _inlineBuilder.build(text, style: _headingStyle(context, level)),
      ),
      ChecklistItemBlock(:final checked, :final text) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: checked,
            visualDensity: const VisualDensity(horizontal: -4, vertical: -2),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onChanged: onChecklistChanged == null
                ? null
                : (value) => onChecklistChanged!(value ?? false),
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
            _inlineBuilder.build(text, style: baseStyle),
          ],
        ),
      ),
      OrderedListItemBlock(:final number, :final text) => Text.rich(
        TextSpan(
          children: [
            TextSpan(text: '$number. ', style: baseStyle),
            _inlineBuilder.build(text, style: baseStyle),
          ],
        ),
      ),
      ParagraphBlock(:final raw) => Text.rich(
        _inlineBuilder.build(raw, style: baseStyle),
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
