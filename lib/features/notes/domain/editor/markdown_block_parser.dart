import 'markdown_block.dart';

class MarkdownBlockParser {
  const MarkdownBlockParser();

  List<MarkdownBlock> parse(String markdown) {
    if (markdown.isEmpty) {
      return const [];
    }

    final lines = markdown.split('\n');

    return lines.map(_parseLine).toList();
  }

  MarkdownBlock _parseLine(String line) {
    final headingMatch = RegExp(r'^(#{1,5})\s+(.*)$').firstMatch(line);
    if (headingMatch != null) {
      return HeadingBlock(
        line,
        level: headingMatch.group(1)!.length,
        text: headingMatch.group(2) ?? '',
      );
    }

    final checklistMatch = RegExp(r'^-\s\[( |x|X)\]\s+(.*)$').firstMatch(line);
    if (checklistMatch != null) {
      return ChecklistItemBlock(
        line,
        checked: checklistMatch.group(1)!.toLowerCase() == 'x',
        text: checklistMatch.group(2) ?? '',
      );
    }

    final bulletMatch = RegExp(r'^-\s+(.*)$').firstMatch(line);
    if (bulletMatch != null) {
      return BulletListItemBlock(line, text: bulletMatch.group(1) ?? '');
    }

    final orderedMatch = RegExp(r'^(\d+)\.\s+(.*)$').firstMatch(line);
    if (orderedMatch != null) {
      return OrderedListItemBlock(
        line,
        number: int.parse(orderedMatch.group(1)!),
        text: orderedMatch.group(2) ?? '',
      );
    }

    return ParagraphBlock(line);
  }
}
