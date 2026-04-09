import '../../domain/markdown_block.dart';

class MarkdownEditing {
  static String bold(String raw) => '**$raw**';

  static String italic(String raw) => '*$raw*';

  static String strike(String raw) => '~~$raw~~';

  static String toggleHeading(MarkdownBlock block, int level) {
    if (block is HeadingBlock && block.level == level) {
      return block.text;
    }

    final text = _stripPrefixes(block.raw);
    return '${'#' * level} $text';
  }

  static String toggleBullet(MarkdownBlock block) {
    if (block is BulletListItemBlock) {
      return block.text;
    }

    final text = _stripPrefixes(block.raw);
    return '- $text';
  }

  static String toggleOrdered(MarkdownBlock block) {
    if (block is OrderedListItemBlock) {
      return block.text;
    }

    final text = _stripPrefixes(block.raw);
    return '1. $text';
  }

  static String toggleChecklist(MarkdownBlock block) {
    if (block is ChecklistItemBlock) {
      return block.text;
    }

    final text = _stripPrefixes(block.raw);
    return '- [ ] $text';
  }

  static String setChecklistChecked(ChecklistItemBlock block, bool checked) {
    final marker = checked ? 'x' : ' ';
    return '- [$marker] ${block.text}';
  }

  static String _stripPrefixes(String raw) {
    final trimmed = raw.trimLeft();

    final heading = trimmed.replaceFirst(RegExp(r'^(#{1,6})\s+'), '');
    final checklist = heading.replaceFirst(RegExp(r'^-\s\[( |x|X)\]\s+'), '');
    final bullet = checklist.replaceFirst(RegExp(r'^-\s+'), '');
    final ordered = bullet.replaceFirst(RegExp(r'^\d+\.\s+'), '');

    return ordered;
  }
}
