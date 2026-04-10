sealed class MarkdownBlock {
  final String raw;

  const MarkdownBlock(this.raw);
}

class ParagraphBlock extends MarkdownBlock {
  const ParagraphBlock(super.raw);
}

class HeadingBlock extends MarkdownBlock {
  final int level;
  final String text;

  const HeadingBlock(super.raw, {required this.level, required this.text});
}

class ChecklistItemBlock extends MarkdownBlock {
  final bool checked;
  final String text;

  const ChecklistItemBlock(
    super.raw, {
    required this.checked,
    required this.text,
  });
}

class BulletListItemBlock extends MarkdownBlock {
  final String text;

  const BulletListItemBlock(super.raw, {required this.text});
}

class OrderedListItemBlock extends MarkdownBlock {
  final int number;
  final String text;

  const OrderedListItemBlock(
    super.raw, {
    required this.number,
    required this.text,
  });
}
