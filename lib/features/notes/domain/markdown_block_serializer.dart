import 'markdown_block.dart';

class MarkdownBlockSerializer {
  const MarkdownBlockSerializer();

  String serialize(List<MarkdownBlock> blocks) {
    return blocks.map((block) => block.raw).join('\n');
  }
}
