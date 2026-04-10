import '../../domain/editor/markdown_block.dart';

class EditorDocumentState {
  final List<MarkdownBlock> blocks;
  final int? editingIndex;

  const EditorDocumentState({required this.blocks, required this.editingIndex});

  EditorDocumentState copyWith({
    List<MarkdownBlock>? blocks,
    int? editingIndex,
    bool clearEditingIndex = false,
  }) {
    return EditorDocumentState(
      blocks: blocks ?? this.blocks,
      editingIndex: clearEditingIndex
          ? null
          : editingIndex ?? this.editingIndex,
    );
  }
}
