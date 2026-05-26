import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veil/app/app_theme.dart';
import 'package:veil/features/notes/presentation/editor/markdown_block_editor.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      home: Scaffold(body: child),
    );
  }

  group('MarkdownBlockEditor', () {
    testWidgets('emits raw text without the empty sentinel', (tester) async {
      String? changedValue;

      await tester.pumpWidget(
        wrap(
          MarkdownBlockEditor(
            initialValue: '',
            onChanged: (value) => changedValue = value,
            onSubmittedNewBlock: (_) {},
            onPasteRequested: () async {},
            onDeleteEmptyBlock: () {},
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Hello');

      expect(changedValue, 'Hello');
      expect(find.text('Hello'), findsOneWidget);
    });

    testWidgets('uses multiline field config for line wrapping', (tester) async {
      await tester.pumpWidget(
        wrap(
          MarkdownBlockEditor(
            initialValue: '',
            onChanged: (_) {},
            onSubmittedNewBlock: (_) {},
            onPasteRequested: () async {},
            onDeleteEmptyBlock: () {},
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.minLines, 1);
      expect(textField.maxLines, isNull);
      expect(textField.keyboardType, TextInputType.multiline);
    });

    testWidgets('applyWrap wraps the selected text', (tester) async {
      final key = GlobalKey<MarkdownBlockEditorState>();
      String? changedValue;

      await tester.pumpWidget(
        wrap(
          MarkdownBlockEditor(
            key: key,
            initialValue: 'abc',
            onChanged: (value) => changedValue = value,
            onSubmittedNewBlock: (_) {},
            onPasteRequested: () async {},
            onDeleteEmptyBlock: () {},
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      textField.controller!.selection = const TextSelection(
        baseOffset: 0,
        extentOffset: 3,
      );

      key.currentState!.applyWrap('**', '**');
      await tester.pump();

      expect(changedValue, '**abc**');
      expect(find.text('**abc**'), findsOneWidget);
    });

    testWidgets('applyWrap inserts paired markers at a collapsed selection', (
      tester,
    ) async {
      final key = GlobalKey<MarkdownBlockEditorState>();
      String? changedValue;

      await tester.pumpWidget(
        wrap(
          MarkdownBlockEditor(
            key: key,
            initialValue: 'ab',
            onChanged: (value) => changedValue = value,
            onSubmittedNewBlock: (_) {},
            onPasteRequested: () async {},
            onDeleteEmptyBlock: () {},
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      textField.controller!.selection = const TextSelection.collapsed(
        offset: 1,
      );

      key.currentState!.applyWrap('**', '**');
      await tester.pump();

      expect(changedValue, 'a****b');
      expect(find.text('a****b'), findsOneWidget);
    });

    testWidgets('insertText inserts at the current raw selection', (
      tester,
    ) async {
      final key = GlobalKey<MarkdownBlockEditorState>();
      String? changedValue;

      await tester.pumpWidget(
        wrap(
          MarkdownBlockEditor(
            key: key,
            initialValue: 'ab',
            onChanged: (value) => changedValue = value,
            onSubmittedNewBlock: (_) {},
            onPasteRequested: () async {},
            onDeleteEmptyBlock: () {},
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      textField.controller!.selection = const TextSelection.collapsed(
        offset: 1,
      );

      key.currentState!.insertText('X');
      await tester.pump();

      expect(changedValue, 'aXb');
      expect(find.text('aXb'), findsOneWidget);
    });

    testWidgets('insertText replaces the selected range', (tester) async {
      final key = GlobalKey<MarkdownBlockEditorState>();
      String? changedValue;

      await tester.pumpWidget(
        wrap(
          MarkdownBlockEditor(
            key: key,
            initialValue: 'abcd',
            onChanged: (value) => changedValue = value,
            onSubmittedNewBlock: (_) {},
            onPasteRequested: () async {},
            onDeleteEmptyBlock: () {},
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      textField.controller!.selection = const TextSelection(
        baseOffset: 1,
        extentOffset: 3,
      );

      key.currentState!.insertText('X');
      await tester.pump();

      expect(changedValue, 'aXd');
      expect(find.text('aXd'), findsOneWidget);
    });

    testWidgets('submits the raw selection on text action next', (
      tester,
    ) async {
      TextSelection? submittedSelection;

      await tester.pumpWidget(
        wrap(
          MarkdownBlockEditor(
            initialValue: 'Body',
            onChanged: (_) {},
            onSubmittedNewBlock: (selection) => submittedSelection = selection,
            onPasteRequested: () async {},
            onDeleteEmptyBlock: () {},
          ),
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.pump();
      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pump();

      expect(submittedSelection, isNotNull);
      expect(submittedSelection!.baseOffset, 4);
      expect(submittedSelection!.extentOffset, 4);
    });

    testWidgets('converts newline insertion into a block submission', (
      tester,
    ) async {
      TextSelection? submittedSelection;
      String? changedValue;

      await tester.pumpWidget(
        wrap(
          MarkdownBlockEditor(
            initialValue: 'Title',
            onChanged: (value) => changedValue = value,
            onSubmittedNewBlock: (selection) => submittedSelection = selection,
            onPasteRequested: () async {},
            onDeleteEmptyBlock: () {},
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Title\n');
      await tester.pump();

      expect(changedValue, 'Title');
      expect(find.text('Title'), findsOneWidget);
      expect(submittedSelection, isNotNull);
      expect(submittedSelection!.baseOffset, 5);
      expect(submittedSelection!.extentOffset, 5);
    });

    testWidgets(
      'updates the controller when the initial value changes externally',
      (tester) async {
        String value = 'old';

        await tester.pumpWidget(
          wrap(
            StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    MarkdownBlockEditor(
                      initialValue: value,
                      onChanged: (_) {},
                      onSubmittedNewBlock: (_) {},
                      onPasteRequested: () async {},
                      onDeleteEmptyBlock: () {},
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          value = 'new';
                        });
                      },
                      child: const Text('update'),
                    ),
                  ],
                );
              },
            ),
          ),
        );

        expect(find.text('old'), findsOneWidget);

        await tester.tap(find.text('update'));
        await tester.pump();

        expect(find.text('new'), findsOneWidget);
        expect(find.text('old'), findsNothing);
      },
    );

    testWidgets(
      'accepts an external value that already matches the controller text',
      (tester) async {
        const sentinel = '\u200B';
        String value = '';

        await tester.pumpWidget(
          wrap(
            StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    MarkdownBlockEditor(
                      initialValue: value,
                      onChanged: (_) {},
                      onSubmittedNewBlock: (_) {},
                      onPasteRequested: () async {},
                      onDeleteEmptyBlock: () {},
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          value = sentinel;
                        });
                      },
                      child: const Text('update-to-sentinel'),
                    ),
                  ],
                );
              },
            ),
          ),
        );

        await tester.tap(find.text('update-to-sentinel'));
        await tester.pump();

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.controller!.text, sentinel);
      },
    );

    testWidgets('backspace on empty content requests block deletion', (
      tester,
    ) async {
      var deleteCalls = 0;

      await tester.pumpWidget(
        wrap(
          MarkdownBlockEditor(
            initialValue: '',
            onChanged: (_) {},
            onSubmittedNewBlock: (_) {},
            onPasteRequested: () async {},
            onDeleteEmptyBlock: () => deleteCalls++,
          ),
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.backspace);

      expect(deleteCalls, 1);
    });

    testWidgets(
      'backspace with a selection deletes the selection instead of the block',
      (tester) async {
        String? changedValue;
        var deleteCalls = 0;

        await tester.pumpWidget(
          wrap(
            MarkdownBlockEditor(
              initialValue: 'hello',
              onChanged: (value) => changedValue = value,
              onSubmittedNewBlock: (_) {},
              onPasteRequested: () async {},
              onDeleteEmptyBlock: () => deleteCalls++,
            ),
          ),
        );

        await tester.tap(find.byType(TextField));
        await tester.pump();

        final textField = tester.widget<TextField>(find.byType(TextField));
        textField.controller!.selection = const TextSelection(
          baseOffset: 1,
          extentOffset: 4,
        );

        await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
        await tester.pump();

        expect(changedValue, 'ho');
        expect(deleteCalls, 0);
      },
    );

    testWidgets('backspace at the start of non-empty text does nothing', (
      tester,
    ) async {
      var deleteCalls = 0;

      await tester.pumpWidget(
        wrap(
          MarkdownBlockEditor(
            initialValue: 'hello',
            onChanged: (_) {},
            onSubmittedNewBlock: (_) {},
            onPasteRequested: () async {},
            onDeleteEmptyBlock: () => deleteCalls++,
          ),
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.pump();

      final textField = tester.widget<TextField>(find.byType(TextField));
      textField.controller!.selection = const TextSelection.collapsed(
        offset: 0,
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
      await tester.pump();

      expect(deleteCalls, 0);
      expect(find.text('hello'), findsOneWidget);
    });

    testWidgets('clearing an empty field via IME requests block deletion', (
      tester,
    ) async {
      var deleteCalls = 0;

      await tester.pumpWidget(
        wrap(
          MarkdownBlockEditor(
            initialValue: '',
            onChanged: (_) {},
            onSubmittedNewBlock: (_) {},
            onPasteRequested: () async {},
            onDeleteEmptyBlock: () => deleteCalls++,
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '');
      await tester.pump();

      expect(deleteCalls, 1);
    });

    testWidgets('strips the invisible sentinel when the IME leaves it behind', (
      tester,
    ) async {
      String? changedValue;

      await tester.pumpWidget(
        wrap(
          MarkdownBlockEditor(
            initialValue: '',
            onChanged: (value) => changedValue = value,
            onSubmittedNewBlock: (_) {},
            onPasteRequested: () async {},
            onDeleteEmptyBlock: () {},
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      textField.controller!.value = const TextEditingValue(
        text: '\u200BHello',
        selection: TextSelection.collapsed(offset: 6),
      );
      await tester.pump();

      expect(changedValue, 'Hello');
      expect(textField.controller!.text, 'Hello');
    });

    testWidgets('context menu builder exposes paste when clipboard has text', (
      tester,
    ) async {
      var pasteCalls = 0;

      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          switch (call.method) {
            case 'Clipboard.hasStrings':
              return <String, dynamic>{'value': true};
            case 'Clipboard.getData':
              return <String, dynamic>{'text': 'clipboard text'};
          }

          return null;
        },
      );
      addTearDown(() {
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        );
      });

      await tester.pumpWidget(
        wrap(
          MarkdownBlockEditor(
            initialValue: 'hello',
            onChanged: (_) {},
            onSubmittedNewBlock: (_) {},
            onPasteRequested: () async => pasteCalls++,
            onDeleteEmptyBlock: () {},
          ),
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.pump();

      final textField = tester.widget<TextField>(find.byType(TextField));
      final editableTextState = tester.state<EditableTextState>(
        find.byType(EditableText),
      );
      await editableTextState.clipboardStatus.update();
      await tester.pump();

      final context = tester.element(find.byType(TextField));
      final toolbar =
          textField.contextMenuBuilder!(context, editableTextState)
              as AdaptiveTextSelectionToolbar;

      expect(
        toolbar.buttonItems!.any(
          (item) =>
              item.label == 'Paste' || item.type == ContextMenuButtonType.paste,
        ),
        isTrue,
      );

      final pasteButton = toolbar.buttonItems!.firstWhere(
        (item) =>
            item.label == 'Paste' || item.type == ContextMenuButtonType.paste,
      );
      pasteButton.onPressed!();
      await tester.pump();

      expect(pasteCalls, 1);
    });

    testWidgets(
      'backspace in the middle of text removes the previous character',
      (tester) async {
        String? changedValue;

        await tester.pumpWidget(
          wrap(
            MarkdownBlockEditor(
              initialValue: 'hello',
              onChanged: (value) => changedValue = value,
              onSubmittedNewBlock: (_) {},
              onPasteRequested: () async {},
              onDeleteEmptyBlock: () {},
            ),
          ),
        );

        await tester.tap(find.byType(TextField));
        await tester.pump();

        final textField = tester.widget<TextField>(find.byType(TextField));
        textField.controller!.selection = const TextSelection.collapsed(
          offset: 3,
        );

        await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
        await tester.pump();

        expect(changedValue, 'helo');
        expect(find.text('helo'), findsOneWidget);
      },
    );
  });
}
