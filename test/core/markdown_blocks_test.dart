import 'package:flutter_test/flutter_test.dart';
import 'package:veil/features/notes/domain/editor/markdown_block.dart';
import 'package:veil/features/notes/domain/editor/markdown_block_parser.dart';
import 'package:veil/features/notes/domain/editor/markdown_block_serializer.dart';

void main() {
  const parser = MarkdownBlockParser();
  const serializer = MarkdownBlockSerializer();

  test('parses supported markdown block types line by line', () {
    final blocks = parser.parse(
      '# Heading\n'
      '- [x] Done item\n'
      '- Bullet item\n'
      '12. Ordered item\n'
      'Plain paragraph',
    );

    expect(blocks, hasLength(5));

    expect(blocks[0], isA<HeadingBlock>());
    expect((blocks[0] as HeadingBlock).level, 1);
    expect((blocks[0] as HeadingBlock).text, 'Heading');

    expect(blocks[1], isA<ChecklistItemBlock>());
    expect((blocks[1] as ChecklistItemBlock).checked, isTrue);
    expect((blocks[1] as ChecklistItemBlock).text, 'Done item');

    expect(blocks[2], isA<BulletListItemBlock>());
    expect((blocks[2] as BulletListItemBlock).text, 'Bullet item');

    expect(blocks[3], isA<OrderedListItemBlock>());
    expect((blocks[3] as OrderedListItemBlock).number, 12);
    expect((blocks[3] as OrderedListItemBlock).text, 'Ordered item');

    expect(blocks[4], isA<ParagraphBlock>());
    expect(blocks[4].raw, 'Plain paragraph');
  });

  test('treats empty markdown as an empty block list', () {
    expect(parser.parse(''), isEmpty);
  });

  test('keeps blank lines as paragraph blocks', () {
    final blocks = parser.parse('First line\n\nThird line');

    expect(blocks, hasLength(3));
    expect(blocks[1], isA<ParagraphBlock>());
    expect(blocks[1].raw, '');
  });

  test('serializes blocks by joining their raw values with newlines', () {
    final markdown = serializer.serialize(const [
      HeadingBlock('# Heading', level: 1, text: 'Heading'),
      ChecklistItemBlock('- [ ] Task', checked: false, text: 'Task'),
      ParagraphBlock('Body'),
    ]);

    expect(markdown, '# Heading\n- [ ] Task\nBody');
  });

  test('serializes an empty block list to an empty string', () {
    expect(serializer.serialize(const []), isEmpty);
  });
}
