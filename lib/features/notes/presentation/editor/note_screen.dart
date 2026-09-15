import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../i18n/translations.g.dart';
import '../../application/notes_service.dart';
import '../../domain/editor/markdown_block.dart';
import '../../domain/editor/markdown_block_parser.dart';
import '../../domain/editor/markdown_block_serializer.dart';
import '../../domain/note.dart';
import 'editor_document_controller.dart';
import 'markdown_block_editor.dart';
import 'markdown_block_view.dart';
import 'note_save_status.dart';
import '../../providers/notes_provider.dart';

import 'markdown_editing.dart';
import 'note_editor_toolbar.dart';

class NoteScreen extends ConsumerStatefulWidget {
  final String? id;

  const NoteScreen({super.key, this.id});

  @override
  ConsumerState<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends ConsumerState<NoteScreen> {
  final GlobalKey<MarkdownBlockEditorState> _editorKey =
      GlobalKey<MarkdownBlockEditorState>();
  final EditorDocumentController _documentController = EditorDocumentController(
    parser: const MarkdownBlockParser(),
    serializer: const MarkdownBlockSerializer(),
  );

  Note? _currentNote;
  NotesService? _noteService;
  Timer? _saveDebounce;
  Future<void>? _saveOperation;
  int _contentVersion = 0;
  bool _hasPendingChanges = false;
  bool _isHandlingBack = false;
  NoteSaveStatus _saveStatus = NoteSaveStatus.saved;

  @override
  void dispose() {
    _saveDebounce?.cancel();
    if (_hasPendingChanges) {
      unawaited(_saveSilently());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final noteAsync = ref.watch(noteProvider(widget.id));
    final topInset = MediaQuery.paddingOf(context).top + kToolbarHeight + 8;
    final bottomInset = MediaQuery.paddingOf(context).bottom + 84;

    return PopScope<void>(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop || _isHandlingBack) {
          return;
        }

        unawaited(_handleBack());
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leadingWidth: 72,
          leading: Padding(
            padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
            child: Material(
              elevation: 0,
              color: const Color(0xFF2A2448),
              shape: const CircleBorder(),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: BackButton(
                  color: Colors.white,
                  onPressed: _isHandlingBack ? null : _handleBack,
                ),
              ),
            ),
          ),
        ),
        body: noteAsync.when(
          data: (note) {
            _bindDocument(note);

            final blocks = _effectiveBlocks;

            return Stack(
              children: [
                Positioned.fill(
                  child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(8, topInset, 8, bottomInset),
                    itemCount: blocks.length,
                    itemBuilder: (context, index) {
                      final block = blocks[index];
                      final isEditing =
                          _documentController.state.editingIndex == index;

                      if (isEditing) {
                        return MarkdownBlockEditor(
                          key: _editorKey,
                          blockId: index,
                          initialValue: block.raw,
                          onChanged: (value) => _onBlockChanged(index, value),
                          onDeleteEmptyBlock: () {
                            _removeEmptyBlock(index);
                          },
                          onSubmittedNewBlock: (selection) {
                            _splitBlockAtSelection(index, selection);
                          },
                          onPasteRequested: _pasteFromClipboardIntoEditingBlock,
                        );
                      }

                      return MarkdownBlockView(
                        block: block,
                        onOpenLink: _openLink,
                        onTap: () {
                          setState(() {
                            _documentController.startEditing(index);
                          });
                        },
                        onChecklistChanged: block is ChecklistItemBlock
                            ? (checked) =>
                                  _toggleChecklist(index, block, checked)
                            : null,
                      );
                    },
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: NoteEditorToolbar(
                      saveStatus: _saveStatus,
                      onBold: _applyToEditingBlockBold,
                      onItalic: _applyToEditingBlockItalic,
                      onHeadingSelected: _toggleHeadingOnEditingBlock,
                      currentHeadingLevel: _currentHeadingLevel,
                      onBullet: _toggleBulletOnEditingBlock,
                      onOrdered: _toggleOrderedOnEditingBlock,
                      onChecklist: _toggleChecklistOnEditingBlock,

                      isBulletActive: _isEditingBullet,
                      isOrderedActive: _isEditingOrdered,
                      isChecklistActive: _isEditingChecklist,
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) =>
              Center(child: Text(context.t.common.errors.loadFailed)),
        ),
      ),
    );
  }

  void _removeEmptyBlock(int index) {
    _documentController.removeBlockAt(index);
    _onContentChanged();
    setState(() {});
  }

  void _openLink(Uri uri) {
    unawaited(_launchLink(uri));
  }

  Future<void> _launchLink(Uri uri) async {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _pasteFromClipboardIntoEditingBlock() async {
    final index = _documentController.state.editingIndex;
    if (index == null) {
      return;
    }

    final clipboardData = await Clipboard.getData('text/plain');
    final text = clipboardData?.text;

    if (text == null || text.isEmpty) {
      return;
    }

    if (text.contains('\n')) {
      final parsedBlocks = const MarkdownBlockParser().parse(text);

      _documentController.replaceBlockWithBlocks(index, parsedBlocks);

      _onContentChanged();
      setState(() {});
      return;
    }

    _editorKey.currentState?.insertText(text);
  }

  void _splitBlockAtSelection(int index, TextSelection selection) {
    final blocks = _documentController.state.blocks;
    if (index >= blocks.length) {
      return;
    }

    final block = blocks[index];
    final raw = block.raw;

    final offset = selection.start.clamp(0, raw.length);
    final before = raw.substring(0, offset);
    final after = raw.substring(offset);

    final currentContentIsEmpty = switch (block) {
      ChecklistItemBlock(:final text) => text.trim().isEmpty,
      BulletListItemBlock(:final text) => text.trim().isEmpty,
      OrderedListItemBlock(:final text) => text.trim().isEmpty,
      _ => false,
    };

    final nextRaw = switch (block) {
      ChecklistItemBlock() when currentContentIsEmpty => '',
      BulletListItemBlock() when currentContentIsEmpty => '',
      OrderedListItemBlock() when currentContentIsEmpty => '',
      ChecklistItemBlock() => '- [ ] ${after.trimLeft()}',
      BulletListItemBlock() => '- ${after.trimLeft()}',
      OrderedListItemBlock(:final number) =>
        '${number + 1}. ${after.trimLeft()}',
      _ => after,
    };

    _documentController.replaceBlockAndInsertBelow(
      index: index,
      currentRaw: before,
      nextRaw: nextRaw,
    );

    _onContentChanged();
    setState(() {});
  }

  MarkdownBlock? get _editingBlock {
    final index = _documentController.state.editingIndex;
    if (index == null) {
      return null;
    }

    final blocks = _documentController.state.blocks;
    if (index >= blocks.length) {
      return null;
    }

    return blocks[index];
  }

  int? get _currentHeadingLevel {
    final block = _editingBlock;
    return block is HeadingBlock ? block.level : null;
  }

  bool get _isEditingBullet {
    return _editingBlock is BulletListItemBlock;
  }

  bool get _isEditingOrdered {
    return _editingBlock is OrderedListItemBlock;
  }

  bool get _isEditingChecklist {
    return _editingBlock is ChecklistItemBlock;
  }

  void _toggleChecklist(int index, ChecklistItemBlock block, bool checked) {
    _documentController.updateBlockRaw(
      index,
      MarkdownEditing.setChecklistChecked(block, checked),
    );

    _onContentChanged();
    setState(() {});
  }

  void _applyToEditingBlockFromBlock(
    String Function(MarkdownBlock block) transform,
  ) {
    final index = _documentController.state.editingIndex;
    if (index == null) {
      return;
    }

    final blocks = _documentController.state.blocks;
    if (index >= blocks.length) {
      return;
    }

    final block = blocks[index];
    _documentController.updateBlockRaw(index, transform(block));

    _onContentChanged();
    setState(() {});
  }

  void _applyToEditingBlockBold() {
    _editorKey.currentState?.applyWrap('**', '**');
  }

  void _applyToEditingBlockItalic() {
    _editorKey.currentState?.applyWrap('*', '*');
  }

  void _toggleHeadingOnEditingBlock(int level) {
    _applyToEditingBlockFromBlock(
      (block) => MarkdownEditing.toggleHeading(block, level),
    );
  }

  void _toggleBulletOnEditingBlock() {
    _applyToEditingBlockFromBlock(MarkdownEditing.toggleBullet);
  }

  void _toggleOrderedOnEditingBlock() {
    _applyToEditingBlockFromBlock(MarkdownEditing.toggleOrdered);
  }

  void _toggleChecklistOnEditingBlock() {
    _applyToEditingBlockFromBlock(MarkdownEditing.toggleChecklist);
  }

  List<MarkdownBlock> get _effectiveBlocks {
    return _documentController.state.blocks;
  }

  void _bindDocument(Note note) {
    if (_currentNote?.id == note.id) {
      return;
    }

    _currentNote = note;
    _documentController.load(note.content);

    if (note.content.trim().isEmpty) {
      _documentController.startEditing(0);
    }
  }

  void _onBlockChanged(int index, String raw) {
    final blocks = _documentController.state.blocks;
    if (index >= blocks.length) {
      return;
    }

    final block = blocks[index];

    if (block is ParagraphBlock) {
      _documentController.updateParagraphRaw(index, raw);
    } else {
      _documentController.updateBlockRaw(index, raw);
    }

    _onContentChanged();
    setState(() {});
  }

  void _onContentChanged() {
    if (_currentNote == null) {
      return;
    }

    _noteService ??= ref.read(notesServiceProvider);
    _contentVersion++;
    _hasPendingChanges = true;

    setState(() {
      _saveStatus = NoteSaveStatus.saving;
    });

    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 600), () {
      unawaited(_saveSilently());
    });
  }

  Future<void> _saveSilently() async {
    try {
      await _savePendingChanges();
    } catch (_) {
      // The status is updated by _savePendingChanges. Debounced saves are
      // intentionally silent; the editor keeps the dirty state for retry.
    }
  }

  Future<void> _savePendingChanges() async {
    _saveDebounce?.cancel();
    _saveDebounce = null;

    if (!_hasPendingChanges) {
      return;
    }

    var noteService = _noteService;
    if (noteService == null) {
      noteService = ref.read(notesServiceProvider);
      _noteService = noteService;
    }
    final resolvedNoteService = noteService!;

    while (_hasPendingChanges) {
      final inFlightSave = _saveOperation;
      if (inFlightSave != null) {
        await inFlightSave;
        continue;
      }

      final note = _currentNote;
      if (note == null) {
        _hasPendingChanges = false;
        return;
      }

      final version = _contentVersion;
      final updatedNote = note.copyWith(
        content: _documentController.toMarkdown(),
        updatedAt: DateTime.now(),
      );
      final saveOperation = _persistNote(
        noteService: resolvedNoteService,
        updatedNote: updatedNote,
        version: version,
      );
      _saveOperation = saveOperation;

      try {
        await saveOperation;
      } finally {
        if (identical(_saveOperation, saveOperation)) {
          _saveOperation = null;
        }
      }
    }
  }

  Future<void> _persistNote({
    required NotesService noteService,
    required Note updatedNote,
    required int version,
  }) async {
    try {
      await noteService.save(updatedNote);
      _currentNote = updatedNote;

      if (mounted) {
        ref.invalidate(notesListProvider);

        if (widget.id != null) {
          ref.invalidate(noteProvider(widget.id));
        }
      }

      final isLatestVersion = version == _contentVersion;
      if (isLatestVersion) {
        _hasPendingChanges = false;
      }

      if (!mounted) {
        return;
      }

      setState(() {
        if (isLatestVersion) {
          _saveStatus = NoteSaveStatus.saved;
        } else {
          _saveStatus = NoteSaveStatus.saving;
        }
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _saveStatus = NoteSaveStatus.error;
        });
      }

      rethrow;
    }
  }

  Future<void> _handleBack() async {
    if (_isHandlingBack) {
      return;
    }

    _isHandlingBack = true;

    try {
      await _savePendingChanges();
    } catch (_) {
      if (mounted) {
        setState(() {
          _isHandlingBack = false;
          _saveStatus = NoteSaveStatus.error;
        });
      }
      return;
    }

    if (!mounted) {
      return;
    }

    _isHandlingBack = false;
    final router = GoRouter.of(context);
    if (router.canPop()) {
      router.pop();
      return;
    }

    router.go('/list');
  }
}
