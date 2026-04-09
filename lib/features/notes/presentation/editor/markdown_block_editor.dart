import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MarkdownBlockEditor extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;
  final ValueChanged<TextSelection> onSubmittedNewBlock;
  final Future<void> Function() onPasteRequested;
  final VoidCallback onDeleteEmptyBlock;

  const MarkdownBlockEditor({
    super.key,
    required this.initialValue,
    required this.onChanged,
    required this.onSubmittedNewBlock,
    required this.onPasteRequested,
    required this.onDeleteEmptyBlock,
  });

  @override
  State<MarkdownBlockEditor> createState() => MarkdownBlockEditorState();
}

class MarkdownBlockEditorState extends State<MarkdownBlockEditor> {
  static const _emptySentinel = '\u200B';

  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late String _lastLocalValue;
  bool _isApplyingExternalUpdate = false;

  @override
  void initState() {
    super.initState();
    _lastLocalValue = widget.initialValue;
    _focusNode = FocusNode();
    _controller = TextEditingController(
      text: _controllerTextFromRaw(widget.initialValue),
    );
    _controller.selection = _controllerSelectionFromRaw(
      widget.initialValue,
      TextSelection.collapsed(offset: widget.initialValue.length),
    );
    _controller.addListener(_handleChanged);
  }

  @override
  void didUpdateWidget(covariant MarkdownBlockEditor oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialValue == _lastLocalValue) {
      return;
    }

    final nextControllerText = _controllerTextFromRaw(widget.initialValue);
    if (nextControllerText == _controller.text) {
      _lastLocalValue = widget.initialValue;
      return;
    }

    _applyControllerValue(
      rawText: widget.initialValue,
      rawSelection: TextSelection.collapsed(offset: widget.initialValue.length),
      notify: false,
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_handleChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleChanged() {
    if (_isApplyingExternalUpdate) {
      return;
    }

    final controllerText = _controller.text;
    final rawText = _rawTextFromController(controllerText);

    // Soft keyboards like HeliBoard do not emit a hardware backspace event
    // when the field is empty. They delete the invisible sentinel instead.
    if (_lastLocalValue.isEmpty && controllerText.isEmpty) {
      widget.onDeleteEmptyBlock();
      return;
    }

    // If the user typed into an "empty" field, strip the sentinel immediately.
    if (rawText.isNotEmpty && controllerText != rawText) {
      final rawSelection = _rawSelectionFromController(
        _controller.selection,
        controllerText,
      );

      _applyControllerValue(
        rawText: rawText,
        rawSelection: TextSelection.collapsed(
          offset: rawSelection.extentOffset.clamp(0, rawText.length),
        ),
      );
      return;
    }

    _lastLocalValue = rawText;
    widget.onChanged(rawText);
  }

  void applyWrap(String prefix, String suffix) {
    final value = _controller.value;
    final text = _rawTextFromController(value.text);
    final selection = _rawSelectionFromController(value.selection, value.text);

    if (!selection.isValid) {
      return;
    }

    final start = selection.start;
    final end = selection.end;

    final selectedText = selection.isCollapsed
        ? ''
        : text.substring(start, end);

    final replacement = '$prefix$selectedText$suffix';
    final nextText = text.replaceRange(start, end, replacement);

    final cursorOffset = selection.isCollapsed
        ? start + prefix.length
        : start + replacement.length;

    _applyControllerValue(
      rawText: nextText,
      rawSelection: TextSelection.collapsed(offset: cursorOffset),
    );
  }

  void insertText(String insertedText) {
    final value = _controller.value;
    final selection = _rawSelectionFromController(value.selection, value.text);
    final text = _rawTextFromController(value.text);

    if (!selection.isValid) {
      return;
    }

    final start = selection.start;
    final end = selection.end;

    final nextText = text.replaceRange(start, end, insertedText);
    final nextOffset = start + insertedText.length;

    _applyControllerValue(
      rawText: nextText,
      rawSelection: TextSelection.collapsed(offset: nextOffset),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.backspace): DeleteCharacterIntent(
          forward: false,
        ),
      },
      child: Actions(
        actions: {
          DeleteCharacterIntent: CallbackAction<DeleteCharacterIntent>(
            onInvoke: (intent) {
              final rawSelection = _rawSelectionFromController(
                _controller.selection,
                _controller.text,
              );
              final isCollapsed = rawSelection.isCollapsed;
              final isAtStart = rawSelection.baseOffset == 0;
              final isEmpty = _rawTextFromController(_controller.text).isEmpty;

              if (isEmpty && isCollapsed && isAtStart) {
                widget.onDeleteEmptyBlock();
                return null;
              }

              _deleteBackward();
              return null;
            },
          ),
        },
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          autofocus: true,
          maxLines: 1,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.zero,
            filled: false,
            fillColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
          ),
          onEditingComplete: () {},
          onSubmitted: (_) {
            final rawSelection = _rawSelectionFromController(
              _controller.selection,
              _controller.text,
            );
            widget.onSubmittedNewBlock(rawSelection);
          },
          contextMenuBuilder: (context, editableTextState) {
            final buttonItems = List<ContextMenuButtonItem>.from(
              editableTextState.contextMenuButtonItems,
            );

            final pasteIndex = buttonItems.indexWhere(
              (item) => item.type == ContextMenuButtonType.paste,
            );

            if (pasteIndex != -1) {
              buttonItems[pasteIndex] = ContextMenuButtonItem(
                label: 'Paste',
                onPressed: () async {
                  ContextMenuController.removeAny();
                  await widget.onPasteRequested();
                },
              );
            }

            return AdaptiveTextSelectionToolbar.buttonItems(
              anchors: editableTextState.contextMenuAnchors,
              buttonItems: buttonItems,
            );
          },
        ),
      ),
    );
  }

  void _deleteBackward() {
    final value = _controller.value;
    final selection = _rawSelectionFromController(value.selection, value.text);
    final text = _rawTextFromController(value.text);

    if (!selection.isValid) {
      return;
    }

    if (!selection.isCollapsed) {
      final start = selection.start;
      final end = selection.end;

      final nextText = text.replaceRange(start, end, '');
      _applyControllerValue(
        rawText: nextText,
        rawSelection: TextSelection.collapsed(offset: start),
      );
      return;
    }

    final cursor = selection.baseOffset;
    if (cursor <= 0) {
      return;
    }

    final nextText = text.replaceRange(cursor - 1, cursor, '');
    _applyControllerValue(
      rawText: nextText,
      rawSelection: TextSelection.collapsed(offset: cursor - 1),
    );
  }

  void _applyControllerValue({
    required String rawText,
    required TextSelection rawSelection,
    bool notify = true,
  }) {
    _isApplyingExternalUpdate = true;
    _controller.value = TextEditingValue(
      text: _controllerTextFromRaw(rawText),
      selection: _controllerSelectionFromRaw(rawText, rawSelection),
      composing: TextRange.empty,
    );
    _lastLocalValue = rawText;
    _isApplyingExternalUpdate = false;

    if (notify) {
      widget.onChanged(rawText);
    }
  }

  String _controllerTextFromRaw(String rawText) {
    return rawText.isEmpty ? _emptySentinel : rawText;
  }

  String _rawTextFromController(String controllerText) {
    return controllerText.replaceAll(_emptySentinel, '');
  }

  TextSelection _rawSelectionFromController(
    TextSelection controllerSelection,
    String controllerText,
  ) {
    return TextSelection(
      baseOffset: _rawOffsetFromController(
        controllerText,
        controllerSelection.baseOffset,
      ),
      extentOffset: _rawOffsetFromController(
        controllerText,
        controllerSelection.extentOffset,
      ),
    );
  }

  TextSelection _controllerSelectionFromRaw(
    String rawText,
    TextSelection rawSelection,
  ) {
    final baseOffset = rawText.isEmpty
        ? 1
        : rawSelection.baseOffset.clamp(0, rawText.length);
    final extentOffset = rawText.isEmpty
        ? 1
        : rawSelection.extentOffset.clamp(0, rawText.length);

    return TextSelection(baseOffset: baseOffset, extentOffset: extentOffset);
  }

  int _rawOffsetFromController(String controllerText, int controllerOffset) {
    final safeOffset = controllerOffset.clamp(0, controllerText.length);
    final prefix = controllerText.substring(0, safeOffset);
    return _rawTextFromController(prefix).length;
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class MarkdownBlockEditor extends StatefulWidget {
//   final String initialValue;
//   final ValueChanged<String> onChanged;
//   final ValueChanged<TextSelection> onSubmittedNewBlock;
//   final Future<void> Function() onPasteRequested;
//   final VoidCallback onDeleteEmptyBlock;

//   const MarkdownBlockEditor({
//     super.key,
//     required this.initialValue,
//     required this.onChanged,
//     required this.onSubmittedNewBlock,
//     required this.onPasteRequested,
//     required this.onDeleteEmptyBlock,
//   });

//   @override
//   State<MarkdownBlockEditor> createState() => MarkdownBlockEditorState();
// }

// class MarkdownBlockEditorState extends State<MarkdownBlockEditor> {
//   late final TextEditingController _controller;
//   late final FocusNode _focusNode;
//   late String _lastLocalValue;
//   bool _isApplyingExternalUpdate = false;

//   @override
//   void initState() {
//     super.initState();
//     _lastLocalValue = widget.initialValue;
//     _focusNode = FocusNode();
//     _controller = TextEditingController(text: widget.initialValue);
//     _controller.addListener(_handleChanged);
//   }

//   @override
//   void didUpdateWidget(covariant MarkdownBlockEditor oldWidget) {
//     super.didUpdateWidget(oldWidget);

//     if (widget.initialValue == _lastLocalValue) {
//       return;
//     }

//     if (widget.initialValue == _controller.text) {
//       _lastLocalValue = widget.initialValue;
//       return;
//     }

//     _isApplyingExternalUpdate = true;
//     _controller.value = _controller.value.copyWith(
//       text: widget.initialValue,
//       selection: TextSelection.collapsed(offset: widget.initialValue.length),
//       composing: TextRange.empty,
//     );
//     _lastLocalValue = widget.initialValue;
//     _isApplyingExternalUpdate = false;
//   }

//   @override
//   void dispose() {
//     _controller.removeListener(_handleChanged);
//     _controller.dispose();
//     _focusNode.dispose();
//     super.dispose();
//   }

//   void _handleChanged() {
//     if (_isApplyingExternalUpdate) {
//       return;
//     }

//     final text = _controller.text;
//     _lastLocalValue = text;

//     widget.onChanged(text);
//   }

//   void applyWrap(String prefix, String suffix) {
//     final value = _controller.value;
//     final selection = value.selection;

//     if (!selection.isValid) {
//       return;
//     }

//     final start = selection.start;
//     final end = selection.end;
//     final text = value.text;

//     final selectedText = selection.isCollapsed
//         ? ''
//         : text.substring(start, end);

//     final replacement = '$prefix$selectedText$suffix';
//     final nextText = text.replaceRange(start, end, replacement);

//     final cursorOffset = selection.isCollapsed
//         ? start + prefix.length
//         : start + replacement.length;

//     _setTextValue(nextText, TextSelection.collapsed(offset: cursorOffset));
//   }

//   void _setTextValue(String text, TextSelection selection) {
//     _isApplyingExternalUpdate = true;
//     _controller.value = TextEditingValue(
//       text: text,
//       selection: selection,
//       composing: TextRange.empty,
//     );
//     _lastLocalValue = text;
//     _isApplyingExternalUpdate = false;
//     widget.onChanged(text);
//   }

//   void insertText(String insertedText) {
//     final value = _controller.value;
//     final selection = value.selection;

//     if (!selection.isValid) {
//       return;
//     }

//     final start = selection.start;
//     final end = selection.end;

//     final nextText = value.text.replaceRange(start, end, insertedText);
//     final nextOffset = start + insertedText.length;

//     _setTextValue(nextText, TextSelection.collapsed(offset: nextOffset));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Shortcuts(
//       shortcuts: const {
//         SingleActivator(LogicalKeyboardKey.backspace): DeleteCharacterIntent(
//           forward: false,
//         ),
//       },
//       child: Actions(
//         actions: {
//           DeleteCharacterIntent: CallbackAction<DeleteCharacterIntent>(
//             onInvoke: (intent) {
//               final selection = _controller.selection;
//               final isCollapsed = selection.isCollapsed;
//               final isAtStart = selection.baseOffset == 0;
//               final isEmpty = _controller.text.isEmpty;

//               if (isEmpty && isCollapsed && isAtStart) {
//                 widget.onDeleteEmptyBlock();
//                 return null;
//               }

//               _deleteBackward();
//               return null;
//             },
//           ),
//         },
//         child: TextField(
//           controller: _controller,
//           focusNode: _focusNode,
//           autofocus: true,
//           maxLines: 1,
//           keyboardType: TextInputType.text,
//           textInputAction: TextInputAction.next,
//           decoration: const InputDecoration(
//             isDense: true,
//             contentPadding: EdgeInsets.zero,
//             filled: false,
//             fillColor: Colors.transparent,
//             focusColor: Colors.transparent,
//             hoverColor: Colors.transparent,
//             border: InputBorder.none,
//             enabledBorder: InputBorder.none,
//             focusedBorder: InputBorder.none,
//             disabledBorder: InputBorder.none,
//           ),
//           onEditingComplete: () {},
//           onSubmitted: (_) => widget.onSubmittedNewBlock(_controller.selection),

//           contextMenuBuilder: (context, editableTextState) {
//             final buttonItems = List<ContextMenuButtonItem>.from(
//               editableTextState.contextMenuButtonItems,
//             );

//             final pasteIndex = buttonItems.indexWhere(
//               (item) => item.type == ContextMenuButtonType.paste,
//             );

//             if (pasteIndex != -1) {
//               buttonItems[pasteIndex] = ContextMenuButtonItem(
//                 label: 'Paste',
//                 onPressed: () async {
//                   ContextMenuController.removeAny();
//                   await widget.onPasteRequested();
//                 },
//               );
//             }

//             return AdaptiveTextSelectionToolbar.buttonItems(
//               anchors: editableTextState.contextMenuAnchors,
//               buttonItems: buttonItems,
//             );
//           },
//         ),
//       ),
//     );
//   }

//   void _deleteBackward() {
//     final value = _controller.value;
//     final selection = value.selection;

//     if (!selection.isValid) {
//       return;
//     }

//     final text = value.text;

//     if (!selection.isCollapsed) {
//       final start = selection.start;
//       final end = selection.end;

//       final nextText = text.replaceRange(start, end, '');
//       _setTextValue(nextText, TextSelection.collapsed(offset: start));
//       return;
//     }

//     final cursor = selection.baseOffset;
//     if (cursor <= 0) {
//       return;
//     }

//     final nextText = text.replaceRange(cursor - 1, cursor, '');
//     _setTextValue(nextText, TextSelection.collapsed(offset: cursor - 1));
//   }
// }
