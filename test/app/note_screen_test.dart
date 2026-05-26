import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:veil/app/app_theme.dart';
import 'package:veil/features/notes/application/notes_service.dart';
import 'package:veil/features/notes/domain/note.dart';
import 'package:veil/features/notes/presentation/editor/markdown_block_editor.dart';
import 'package:veil/features/notes/presentation/editor/note_editor_toolbar.dart';
import 'package:veil/features/notes/presentation/editor/note_save_status.dart';
import 'package:veil/features/notes/presentation/editor/note_screen.dart';
import 'package:veil/features/notes/providers/notes_provider.dart';

import '../test_localized_app.dart';

void main() {
  Widget wrap({required _FakeNotesService service, String? id}) {
    return ProviderScope(
      overrides: [notesServiceProvider.overrideWithValue(service)],
      child: buildLocalizedApp(
        theme: AppTheme.darkTheme,
        home: NoteScreen(id: id),
      ),
    );
  }

  group('NoteScreen', () {
    testWidgets('shows a loading spinner while the note is loading', (
      tester,
    ) async {
      final completer = Completer<Note>();
      final service = _FakeNotesService(openHandler: (_) => completer.future);

      await tester.pumpWidget(wrap(service: service, id: 'note-1'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows the provider error when loading fails', (tester) async {
      final service = _FakeNotesService(
        openHandler: (_) async => throw Exception('load failed'),
      );

      await tester.pumpWidget(wrap(service: service, id: 'note-1'));
      await tester.pumpAndSettle();

      expect(
        find.text('Could not load the information.'),
        findsOneWidget,
      );
    });

    testWidgets(
      'starts editing immediately for a new empty note and saves changes',
      (tester) async {
        final service = _FakeNotesService(
          createEmptyHandler: () async => Note(
            id: 'new-note',
            content: '',
            createdAt: DateTime(2026, 4, 10, 9, 0),
            updatedAt: DateTime(2026, 4, 10, 9, 0),
          ),
        );

        await tester.pumpWidget(wrap(service: service));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 50));

        expect(find.byType(TextField), findsOneWidget);

        await tester.enterText(find.byType(TextField), 'Draft');
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 650));

        expect(service.savedNotes, hasLength(1));
        expect(service.savedNotes.single.content, 'Draft');
      },
    );

    testWidgets('enters edit mode on tap and splits blocks on next action', (
      tester,
    ) async {
      final service = _FakeNotesService(
        openHandler: (_) async => Note(
          id: 'note-1',
          content: 'Title',
          createdAt: DateTime(2026, 4, 10, 9, 0),
          updatedAt: DateTime(2026, 4, 10, 9, 0),
        ),
      );

      await tester.pumpWidget(wrap(service: service, id: 'note-1'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Title'), findsOneWidget);
      expect(find.byType(TextField), findsNothing);

      await tester.tap(find.text('Title'));
      await tester.pump();

      expect(find.byType(TextField), findsOneWidget);

      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'Body');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 650));

      expect(service.savedNotes, isNotEmpty);
      expect(service.savedNotes.last.content, 'Title\nBody');
    });

    testWidgets('splits into a new block when a newline is inserted', (
      tester,
    ) async {
      final service = _FakeNotesService(
        openHandler: (_) async => Note(
          id: 'note-1',
          content: 'Title',
          createdAt: DateTime(2026, 4, 10, 9, 0),
          updatedAt: DateTime(2026, 4, 10, 9, 0),
        ),
      );

      await tester.pumpWidget(wrap(service: service, id: 'note-1'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      await tester.tap(find.text('Title'));
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'Title\nBody');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 650));

      expect(service.savedNotes, isNotEmpty);
      expect(service.savedNotes.last.content, 'Title\nBody');
    });

    testWidgets('toggles checklist items and saves the checked markdown', (
      tester,
    ) async {
      final service = _FakeNotesService(
        openHandler: (_) async => Note(
          id: 'note-1',
          content: '- [ ] task',
          createdAt: DateTime(2026, 4, 10, 9, 0),
          updatedAt: DateTime(2026, 4, 10, 9, 0),
        ),
      );

      await tester.pumpWidget(wrap(service: service, id: 'note-1'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.byType(Checkbox), findsOneWidget);

      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 650));

      expect(service.savedNotes, isNotEmpty);
      expect(service.savedNotes.last.content, '- [x] task');
    });

    testWidgets(
      'formats the editing block from the toolbar and saves the markdown',
      (tester) async {
        final service = _FakeNotesService(
          openHandler: (_) async => Note(
            id: 'note-1',
            content: 'task',
            createdAt: DateTime(2026, 4, 10, 9, 0),
            updatedAt: DateTime(2026, 4, 10, 9, 0),
          ),
        );

        await tester.pumpWidget(wrap(service: service, id: 'note-1'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 50));

        await tester.tap(find.text('task'));
        await tester.pump();

        await tester.tap(find.byIcon(Icons.format_list_bulleted_rounded));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 650));
        expect(service.savedNotes.last.content, '- task');

        await tester.tap(find.byIcon(Icons.format_list_numbered_rounded));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 650));
        expect(service.savedNotes.last.content, '1. task');

        await tester.tap(find.byIcon(Icons.check_box_outlined));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 650));
        expect(service.savedNotes.last.content, '- [ ] task');

        await tester.tap(find.text('H'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Heading 2').last);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 650));

        expect(service.savedNotes.last.content, '## task');
      },
    );

    testWidgets('applies bold and italic formatting to the current selection', (
      tester,
    ) async {
      final service = _FakeNotesService(
        openHandler: (_) async => Note(
          id: 'note-1',
          content: 'word',
          createdAt: DateTime(2026, 4, 10, 9, 0),
          updatedAt: DateTime(2026, 4, 10, 9, 0),
        ),
      );

      await tester.pumpWidget(wrap(service: service, id: 'note-1'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      await tester.tap(find.text('word'));
      await tester.pump();

      final textField = tester.widget<TextField>(find.byType(TextField));
      textField.controller!.selection = const TextSelection(
        baseOffset: 0,
        extentOffset: 4,
      );

      await tester.tap(find.byIcon(Icons.format_bold));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 650));
      expect(service.savedNotes.last.content, '**word**');

      textField.controller!.selection = const TextSelection(
        baseOffset: 2,
        extentOffset: 6,
      );
      await tester.tap(find.byIcon(Icons.format_italic));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 650));

      expect(service.savedNotes.last.content, '***word***');
    });

    testWidgets('toolbar callbacks are no-ops when no block is being edited', (
      tester,
    ) async {
      final service = _FakeNotesService(
        openHandler: (_) async => Note(
          id: 'note-1',
          content: 'task',
          createdAt: DateTime(2026, 4, 10, 9, 0),
          updatedAt: DateTime(2026, 4, 10, 9, 0),
        ),
      );

      await tester.pumpWidget(wrap(service: service, id: 'note-1'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      final toolbar = tester.widget<NoteEditorToolbar>(
        find.byType(NoteEditorToolbar),
      );

      toolbar.onHeadingSelected(2);
      toolbar.onBullet();
      toolbar.onOrdered();
      toolbar.onChecklist();
      await tester.pump();

      expect(service.savedNotes, isEmpty);
    });

    testWidgets('removes an empty block when backspace is pressed on it', (
      tester,
    ) async {
      final service = _FakeNotesService(
        openHandler: (_) async => Note(
          id: 'note-1',
          content: 'First\nSecond',
          createdAt: DateTime(2026, 4, 10, 9, 0),
          updatedAt: DateTime(2026, 4, 10, 9, 0),
        ),
      );

      await tester.pumpWidget(wrap(service: service, id: 'note-1'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      await tester.tap(find.text('Second'));
      await tester.pump();
      await tester.enterText(find.byType(TextField), '');
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 650));

      expect(service.savedNotes.last.content, 'First');
    });

    testWidgets('removes an empty block through the editor callback', (
      tester,
    ) async {
      final service = _FakeNotesService(
        openHandler: (_) async => Note(
          id: 'note-1',
          content: 'First\nSecond',
          createdAt: DateTime(2026, 4, 10, 9, 0),
          updatedAt: DateTime(2026, 4, 10, 9, 0),
        ),
      );

      await tester.pumpWidget(wrap(service: service, id: 'note-1'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      await tester.tap(find.text('Second'));
      await tester.pump();

      final editor = tester.widget<MarkdownBlockEditor>(
        find.byType(MarkdownBlockEditor),
      );
      editor.onDeleteEmptyBlock();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 650));

      expect(service.savedNotes.last.content, 'First');
    });

    testWidgets('splits ordered list items and edits the inserted block', (
      tester,
    ) async {
      final service = _FakeNotesService(
        openHandler: (_) async => Note(
          id: 'note-1',
          content: '1. item',
          createdAt: DateTime(2026, 4, 10, 9, 0),
          updatedAt: DateTime(2026, 4, 10, 9, 0),
        ),
      );

      await tester.pumpWidget(wrap(service: service, id: 'note-1'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      await tester.tap(find.textContaining('item'));
      await tester.pump();

      final textField = tester.widget<TextField>(find.byType(TextField));
      textField.controller!.selection = const TextSelection.collapsed(
        offset: 7,
      );

      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pump();
      await tester.enterText(find.byType(TextField), '2. next');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 650));

      expect(service.savedNotes.last.content, '1. item\n2. next');
    });

    testWidgets('pastes single-line clipboard text into the editing block', (
      tester,
    ) async {
      final service = _FakeNotesService(
        openHandler: (_) async => Note(
          id: 'note-1',
          content: 'body',
          createdAt: DateTime(2026, 4, 10, 9, 0),
          updatedAt: DateTime(2026, 4, 10, 9, 0),
        ),
      );

      await tester.pumpWidget(wrap(service: service, id: 'note-1'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'Clipboard.getData') {
            return <String, dynamic>{'text': ' plus'};
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

      await tester.tap(find.text('body'));
      await tester.pump();

      final textField = tester.widget<TextField>(find.byType(TextField));
      textField.controller!.selection = const TextSelection.collapsed(
        offset: 4,
      );

      final editor = tester.widget<MarkdownBlockEditor>(
        find.byType(MarkdownBlockEditor),
      );
      await editor.onPasteRequested();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 650));

      expect(service.savedNotes.last.content, 'body plus');
    });

    testWidgets('ignores empty clipboard paste requests', (tester) async {
      final service = _FakeNotesService(
        openHandler: (_) async => Note(
          id: 'note-1',
          content: 'body',
          createdAt: DateTime(2026, 4, 10, 9, 0),
          updatedAt: DateTime(2026, 4, 10, 9, 0),
        ),
      );

      await tester.pumpWidget(wrap(service: service, id: 'note-1'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'Clipboard.getData') {
            return <String, dynamic>{'text': ''};
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

      await tester.tap(find.text('body'));
      await tester.pump();

      final editor = tester.widget<MarkdownBlockEditor>(
        find.byType(MarkdownBlockEditor),
      );
      await editor.onPasteRequested();
      await tester.pump();

      expect(service.savedNotes, isEmpty);
    });

    testWidgets('replaces the editing block when pasting multiple lines', (
      tester,
    ) async {
      final service = _FakeNotesService(
        openHandler: (_) async => Note(
          id: 'note-1',
          content: 'body',
          createdAt: DateTime(2026, 4, 10, 9, 0),
          updatedAt: DateTime(2026, 4, 10, 9, 0),
        ),
      );

      await tester.pumpWidget(wrap(service: service, id: 'note-1'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'Clipboard.getData') {
            return <String, dynamic>{'text': 'first\nsecond'};
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

      await tester.tap(find.text('body'));
      await tester.pump();

      final editor = tester.widget<MarkdownBlockEditor>(
        find.byType(MarkdownBlockEditor),
      );
      await editor.onPasteRequested();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 650));

      expect(service.savedNotes.last.content, 'first\nsecond');
    });

    testWidgets('updates non-paragraph blocks using the raw editor callback', (
      tester,
    ) async {
      final service = _FakeNotesService(
        openHandler: (_) async => Note(
          id: 'note-1',
          content: '# Title',
          createdAt: DateTime(2026, 4, 10, 9, 0),
          updatedAt: DateTime(2026, 4, 10, 9, 0),
        ),
      );

      await tester.pumpWidget(wrap(service: service, id: 'note-1'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      await tester.tap(find.text('Title'));
      await tester.pump();

      final editor = tester.widget<MarkdownBlockEditor>(
        find.byType(MarkdownBlockEditor),
      );
      editor.onChanged('## Changed');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 650));

      expect(service.savedNotes.last.content, '## Changed');
    });

    testWidgets('toolbar callbacks format the editing block directly', (
      tester,
    ) async {
      final service = _FakeNotesService(
        openHandler: (_) async => Note(
          id: 'note-1',
          content: 'word',
          createdAt: DateTime(2026, 4, 10, 9, 0),
          updatedAt: DateTime(2026, 4, 10, 9, 0),
        ),
      );

      await tester.pumpWidget(wrap(service: service, id: 'note-1'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      await tester.tap(find.text('word'));
      await tester.pump();

      final toolbar = tester.widget<NoteEditorToolbar>(
        find.byType(NoteEditorToolbar),
      );
      final textField = tester.widget<TextField>(find.byType(TextField));

      textField.controller!.selection = const TextSelection(
        baseOffset: 0,
        extentOffset: 4,
      );
      toolbar.onBold();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 650));
      expect(service.savedNotes.last.content, '**word**');

      textField.controller!.selection = const TextSelection(
        baseOffset: 2,
        extentOffset: 6,
      );
      toolbar.onItalic();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 650));
      expect(service.savedNotes.last.content, '***word***');
    });

    testWidgets('shows error status when silent save fails', (tester) async {
      final service = _FakeNotesService(
        openHandler: (_) async => Note(
          id: 'note-1',
          content: 'text',
          createdAt: DateTime(2026, 4, 10, 9, 0),
          updatedAt: DateTime(2026, 4, 10, 9, 0),
        ),
        saveException: Exception('save failed'),
      );

      await tester.pumpWidget(wrap(service: service, id: 'note-1'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      await tester.tap(find.text('text'));
      await tester.pump();
      await tester.enterText(find.byType(TextField), '# changed');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 650));

      final toolbar = tester.widget<NoteEditorToolbar>(
        find.byType(NoteEditorToolbar),
      );

      expect(toolbar.saveStatus, NoteSaveStatus.error);
    });
  });
}

class _FakeNotesService implements NotesService {
  final Future<Note> Function()? createEmptyHandler;
  final Future<Note> Function(String id)? openHandler;
  final Object? saveException;
  final List<Note> savedNotes = [];

  _FakeNotesService({
    this.createEmptyHandler,
    this.openHandler,
    this.saveException,
  });

  @override
  Future<Note> createEmpty() async {
    if (createEmptyHandler != null) {
      return createEmptyHandler!();
    }

    return Note(
      id: 'new-note',
      content: '',
      createdAt: DateTime(2026, 4, 10, 9, 0),
      updatedAt: DateTime(2026, 4, 10, 9, 0),
    );
  }

  @override
  Future<void> delete(String id) async {}

  @override
  Future<List<Note>> list() async => const [];

  @override
  Future<Note> open(String id) async {
    if (openHandler != null) {
      return openHandler!(id);
    }

    return Note(
      id: id,
      content: 'Opened note',
      createdAt: DateTime(2026, 4, 10, 9, 0),
      updatedAt: DateTime(2026, 4, 10, 9, 0),
    );
  }

  @override
  Future<void> save(Note note) async {
    if (saveException != null) {
      throw saveException!;
    }
    savedNotes.add(note);
  }
}
