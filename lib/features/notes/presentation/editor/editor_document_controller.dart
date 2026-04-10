import '../../domain/editor/markdown_block.dart';
import '../../domain/editor/markdown_block_parser.dart';
import '../../domain/editor/markdown_block_serializer.dart';
import 'editor_document_state.dart';

class EditorDocumentController {
  final MarkdownBlockParser _parser;
  final MarkdownBlockSerializer _serializer;

  EditorDocumentState _state = const EditorDocumentState(
    blocks: [],
    editingIndex: null,
  );

  EditorDocumentController({
    required MarkdownBlockParser parser,
    required MarkdownBlockSerializer serializer,
  }) : _parser = parser,
       _serializer = serializer;

  EditorDocumentState get state => _state;

  void load(String markdown) {
    final blocks = markdown.isEmpty
        ? const [ParagraphBlock('')]
        : _parser.parse(markdown);

    _state = EditorDocumentState(blocks: blocks, editingIndex: null);
  }

  void startEditing(int index) {
    _state = _state.copyWith(editingIndex: index);
  }

  void stopEditing() {
    _state = _state.copyWith(clearEditingIndex: true);
  }

  void updateBlockRaw(int index, String raw) {
    final nextBlocks = [..._state.blocks];

    if (raw.isEmpty) {
      nextBlocks[index] = const ParagraphBlock('');
    } else {
      nextBlocks[index] = _parser.parse(raw).first;
    }

    _state = _state.copyWith(blocks: nextBlocks);
  }

  void insertBlockBelow(int index, MarkdownBlock block) {
    final nextBlocks = [..._state.blocks];
    nextBlocks.insert(index + 1, block);

    _state = _state.copyWith(blocks: nextBlocks, editingIndex: index + 1);
  }

  void removeBlockAt(int index) {
    final nextBlocks = [..._state.blocks];

    if (nextBlocks.isEmpty || index >= nextBlocks.length) {
      return;
    }

    nextBlocks.removeAt(index);

    if (nextBlocks.isEmpty) {
      _state = const EditorDocumentState(
        blocks: [ParagraphBlock('')],
        editingIndex: 0,
      );
      return;
    }

    final nextEditingIndex = index == 0 ? 0 : index - 1;

    _state = _state.copyWith(
      blocks: nextBlocks,
      editingIndex: nextEditingIndex,
    );
  }

  void updateParagraphRaw(int index, String raw) {
    final nextBlocks = [..._state.blocks];
    nextBlocks[index] = ParagraphBlock(raw);

    _state = _state.copyWith(blocks: nextBlocks);
  }

  void replaceBlockAndInsertBelow({
    required int index,
    required String currentRaw,
    required String nextRaw,
  }) {
    final nextBlocks = [..._state.blocks];

    nextBlocks[index] = currentRaw.isEmpty
        ? const ParagraphBlock('')
        : _parser.parse(currentRaw).first;

    nextBlocks.insert(
      index + 1,
      nextRaw.isEmpty ? const ParagraphBlock('') : _parser.parse(nextRaw).first,
    );

    _state = _state.copyWith(blocks: nextBlocks, editingIndex: index + 1);
  }

  void replaceBlockWithBlocks(int index, List<MarkdownBlock> blocks) {
    final nextBlocks = [..._state.blocks];

    if (index >= nextBlocks.length) {
      return;
    }

    nextBlocks.removeAt(index);

    if (blocks.isEmpty) {
      nextBlocks.insert(index, const ParagraphBlock(''));
    } else {
      nextBlocks.insertAll(index, blocks);
    }

    _state = _state.copyWith(blocks: nextBlocks, clearEditingIndex: true);
  }

  String toMarkdown() {
    return _serializer.serialize(_state.blocks);
  }
}
