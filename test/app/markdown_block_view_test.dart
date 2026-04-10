import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veil/app/app_theme.dart';
import 'package:veil/features/notes/domain/editor/markdown_block.dart';
import 'package:veil/features/notes/presentation/editor/markdown_block_view.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      home: Scaffold(body: child),
    );
  }

  group('MarkdownBlockView', () {
    testWidgets('renders headings and handles taps', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        wrap(
          MarkdownBlockView(
            block: const HeadingBlock('# Title', level: 1, text: 'Title'),
            onTap: () => tapped = true,
          ),
        ),
      );

      expect(find.text('Title'), findsOneWidget);

      await tester.tap(find.byType(MarkdownBlockView));
      expect(tapped, isTrue);
    });

    testWidgets('renders checklist blocks and propagates changes', (
      tester,
    ) async {
      bool? changed;

      await tester.pumpWidget(
        wrap(
          MarkdownBlockView(
            block: const ChecklistItemBlock(
              '- [ ] Task',
              checked: false,
              text: 'Task',
            ),
            onTap: () {},
            onChecklistChanged: (value) => changed = value,
          ),
        ),
      );

      expect(find.byType(Checkbox), findsOneWidget);
      expect(find.text('Task'), findsOneWidget);

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      expect(changed, isTrue);
    });

    testWidgets('renders bullet and ordered list prefixes', (tester) async {
      await tester.pumpWidget(
        wrap(
          Column(
            children: const [
              MarkdownBlockView(
                block: BulletListItemBlock('- Item', text: 'Item'),
                onTap: _noop,
              ),
              MarkdownBlockView(
                block: OrderedListItemBlock('2. Item', number: 2, text: 'Item'),
                onTap: _noop,
              ),
            ],
          ),
        ),
      );

      expect(find.textContaining('Item'), findsNWidgets(2));
      expect(find.textContaining('2. '), findsOneWidget);
    });

    testWidgets('renders the expected heading styles for levels 2 to 5', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const Column(
            children: [
              MarkdownBlockView(
                block: HeadingBlock('## Two', level: 2, text: 'Two'),
                onTap: _noop,
              ),
              MarkdownBlockView(
                block: HeadingBlock('### Three', level: 3, text: 'Three'),
                onTap: _noop,
              ),
              MarkdownBlockView(
                block: HeadingBlock('#### Four', level: 4, text: 'Four'),
                onTap: _noop,
              ),
              MarkdownBlockView(
                block: HeadingBlock('##### Five', level: 5, text: 'Five'),
                onTap: _noop,
              ),
            ],
          ),
        ),
      );

      Text textWidget(String label) => tester.widget<Text>(find.text(label));

      expect(textWidget('Two').textSpan?.style?.fontSize, 22);
      expect(textWidget('Three').textSpan?.style?.fontSize, 20);
      expect(textWidget('Four').textSpan?.style?.fontSize, 18);
      expect(textWidget('Five').textSpan?.style?.fontSize, 16);
    });
  });
}

void _noop() {}
