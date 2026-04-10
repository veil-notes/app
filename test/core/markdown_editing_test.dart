import 'package:flutter_test/flutter_test.dart';
import 'package:veil/features/notes/domain/editor/markdown_block.dart';
import 'package:veil/features/notes/presentation/editor/markdown_editing.dart';

void main() {
  group('MarkdownEditing', () {
    test('wraps inline styles', () {
      expect(MarkdownEditing.bold('text'), '**text**');
      expect(MarkdownEditing.italic('text'), '*text*');
      expect(MarkdownEditing.strike('text'), '~~text~~');
    });

    test('toggles heading off when same level is selected', () {
      const block = HeadingBlock('## Title', level: 2, text: 'Title');

      expect(MarkdownEditing.toggleHeading(block, 2), 'Title');
    });

    test('converts other blocks to headings after stripping prefixes', () {
      const block = BulletListItemBlock('- Item', text: 'Item');

      expect(MarkdownEditing.toggleHeading(block, 3), '### Item');
    });

    test('toggles bullet list on and off', () {
      const paragraph = ParagraphBlock('Task');
      const bullet = BulletListItemBlock('- Task', text: 'Task');

      expect(MarkdownEditing.toggleBullet(paragraph), '- Task');
      expect(MarkdownEditing.toggleBullet(bullet), 'Task');
    });

    test('toggles ordered list on and off', () {
      const paragraph = ParagraphBlock('Task');
      const ordered = OrderedListItemBlock('1. Task', number: 1, text: 'Task');

      expect(MarkdownEditing.toggleOrdered(paragraph), '1. Task');
      expect(MarkdownEditing.toggleOrdered(ordered), 'Task');
    });

    test('toggles checklist on and off', () {
      const paragraph = ParagraphBlock('Task');
      const checklist = ChecklistItemBlock(
        '- [ ] Task',
        checked: false,
        text: 'Task',
      );

      expect(MarkdownEditing.toggleChecklist(paragraph), '- [ ] Task');
      expect(MarkdownEditing.toggleChecklist(checklist), 'Task');
    });

    test('updates checklist marker without changing text', () {
      const block = ChecklistItemBlock(
        '- [ ] Task',
        checked: false,
        text: 'Task',
      );

      expect(MarkdownEditing.setChecklistChecked(block, true), '- [x] Task');
      expect(MarkdownEditing.setChecklistChecked(block, false), '- [ ] Task');
    });

    test('strips existing markdown prefixes before switching block type', () {
      const checklist = ChecklistItemBlock(
        '- [x] Done',
        checked: true,
        text: 'Done',
      );

      expect(MarkdownEditing.toggleOrdered(checklist), '1. Done');
      expect(MarkdownEditing.toggleBullet(checklist), '- Done');
    });
  });
}
