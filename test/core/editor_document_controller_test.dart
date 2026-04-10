import 'package:flutter_test/flutter_test.dart';
import 'package:veil/features/notes/domain/editor/markdown_block.dart';
import 'package:veil/features/notes/domain/editor/markdown_block_parser.dart';
import 'package:veil/features/notes/domain/editor/markdown_block_serializer.dart';
import 'package:veil/features/notes/presentation/editor/editor_document_controller.dart';

void main() {
  EditorDocumentController buildController() {
    return EditorDocumentController(
      parser: const MarkdownBlockParser(),
      serializer: const MarkdownBlockSerializer(),
    );
  }

  group('EditorDocumentController', () {
    test('loads an empty paragraph when markdown is blank', () {
      final controller = buildController();

      controller.load('');

      expect(controller.state.blocks, hasLength(1));
      expect(controller.state.blocks.single, isA<ParagraphBlock>());
      expect(controller.state.blocks.single.raw, '');
      expect(controller.state.editingIndex, isNull);
    });

    test('loads parsed blocks for non-empty markdown', () {
      final controller = buildController();

      controller.load('# Heading\nBody');

      expect(controller.state.blocks, hasLength(2));
      expect(controller.state.blocks.first, isA<HeadingBlock>());
      expect(controller.state.blocks.last, isA<ParagraphBlock>());
    });

    test('starts and stops editing', () {
      final controller = buildController()..load('Body');

      controller.startEditing(0);
      expect(controller.state.editingIndex, 0);

      controller.stopEditing();
      expect(controller.state.editingIndex, isNull);
    });

    test('updates block raw by reparsing non-empty content', () {
      final controller = buildController()..load('Body');

      controller.updateBlockRaw(0, '- [x] Done');

      expect(controller.state.blocks.single, isA<ChecklistItemBlock>());
      final block = controller.state.blocks.single as ChecklistItemBlock;
      expect(block.checked, isTrue);
      expect(block.text, 'Done');
    });

    test('turns empty updates into paragraph blocks', () {
      final controller = buildController()..load('# Heading');

      controller.updateBlockRaw(0, '');

      expect(controller.state.blocks.single, isA<ParagraphBlock>());
      expect(controller.state.blocks.single.raw, '');
    });

    test('inserts a block below and moves editing index', () {
      final controller = buildController()..load('First');

      controller.insertBlockBelow(0, const ParagraphBlock('Second'));

      expect(controller.state.blocks, hasLength(2));
      expect(controller.state.blocks[1].raw, 'Second');
      expect(controller.state.editingIndex, 1);
    });

    test('removes a block and focuses previous one', () {
      final controller = buildController()..load('First\nSecond');

      controller.removeBlockAt(1);

      expect(controller.state.blocks, hasLength(1));
      expect(controller.state.blocks.single.raw, 'First');
      expect(controller.state.editingIndex, 0);
    });

    test('keeps one empty paragraph when removing the last block', () {
      final controller = buildController()..load('Only');

      controller.removeBlockAt(0);

      expect(controller.state.blocks, hasLength(1));
      expect(controller.state.blocks.single, isA<ParagraphBlock>());
      expect(controller.state.blocks.single.raw, '');
      expect(controller.state.editingIndex, 0);
    });

    test('ignores out-of-range removals', () {
      final controller = buildController()..load('Only');

      controller.removeBlockAt(5);

      expect(controller.state.blocks, hasLength(1));
      expect(controller.state.blocks.single.raw, 'Only');
    });

    test('updates paragraph raw without reparsing to a new block type', () {
      final controller = buildController()..load('Only');

      controller.updateParagraphRaw(0, '- not a list');

      expect(controller.state.blocks.single, isA<ParagraphBlock>());
      expect(controller.state.blocks.single.raw, '- not a list');
    });

    test('replaces a block and inserts the next one below', () {
      final controller = buildController()..load('Body');

      controller.replaceBlockAndInsertBelow(
        index: 0,
        currentRaw: '# Title',
        nextRaw: '',
      );

      expect(controller.state.blocks, hasLength(2));
      expect(controller.state.blocks.first, isA<HeadingBlock>());
      expect(controller.state.blocks.last, isA<ParagraphBlock>());
      expect(controller.state.editingIndex, 1);
    });

    test('replaces a block with many blocks and clears editing index', () {
      final controller = buildController()..load('Body');
      controller.startEditing(0);

      controller.replaceBlockWithBlocks(0, const [
        HeadingBlock('# Title', level: 1, text: 'Title'),
        ParagraphBlock('Body'),
      ]);

      expect(controller.state.blocks, hasLength(2));
      expect(controller.state.blocks.first, isA<HeadingBlock>());
      expect(controller.state.editingIndex, isNull);
    });

    test('replaces a block with empty paragraph when replacement list is empty', () {
      final controller = buildController()..load('Body');

      controller.replaceBlockWithBlocks(0, const []);

      expect(controller.state.blocks, hasLength(1));
      expect(controller.state.blocks.single, isA<ParagraphBlock>());
      expect(controller.state.blocks.single.raw, '');
    });

    test('serializes current blocks back to markdown', () {
      final controller = buildController()..load('# Title\nBody');

      expect(controller.toMarkdown(), '# Title\nBody');
    });
  });
}
