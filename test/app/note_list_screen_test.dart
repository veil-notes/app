import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:veil/app/app_theme.dart';
import 'package:veil/features/notes/application/notes_service.dart';
import 'package:veil/features/notes/domain/note.dart';
import 'package:veil/features/notes/presentation/screens/note_list_screen.dart';
import 'package:veil/features/notes/providers/notes_provider.dart';

void main() {
  testWidgets('shows the empty state when there are no notes', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _wrapHome(
        overrides: [
          notesListProvider.overrideWith((ref) async => const []),
        ],
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('no notes yet.'), findsOneWidget);
  });

  testWidgets('shows a loading spinner while notes are loading', (
    WidgetTester tester,
  ) async {
    final completer = Completer<List<Note>>();

    await tester.pumpWidget(
      _wrapHome(
        overrides: [
          notesListProvider.overrideWith((ref) => completer.future),
        ],
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows the provider error when loading notes fails', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _wrapHome(
        overrides: [
          notesListProvider.overrideWith((ref) async {
            throw Exception('boom');
          }),
        ],
      ),
    );

    await tester.pumpAndSettle();

    expect(find.textContaining('boom'), findsOneWidget);
  });

  testWidgets('strips markdown syntax from note titles in the list', (
    WidgetTester tester,
  ) async {
    final note = Note(
      id: 'note-1',
      content: '# **Launch** plan',
      createdAt: DateTime(2026, 4, 10, 9, 0),
      updatedAt: DateTime(2026, 4, 10, 9, 30),
    );

    await tester.pumpWidget(
      _wrapHome(
        overrides: [
          notesListProvider.overrideWith((ref) async => [note]),
        ],
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Launch plan'), findsOneWidget);
    expect(find.text('# **Launch** plan'), findsNothing);
    expect(find.text('2026-04-10 09:30'), findsOneWidget);
  });

  testWidgets('strips italic and strike markdown syntax from note titles', (
    WidgetTester tester,
  ) async {
    final note = Note(
      id: 'note-2',
      content: '*Italic* ~~done~~',
      createdAt: DateTime(2026, 4, 10, 9, 0),
      updatedAt: DateTime(2026, 4, 10, 9, 30),
    );

    await tester.pumpWidget(
      _wrapHome(
        overrides: [
          notesListProvider.overrideWith((ref) async => [note]),
        ],
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Italic done'), findsOneWidget);
  });

  testWidgets('renders separators between note items', (tester) async {
    final notes = [
      Note(
        id: 'note-1',
        content: 'First',
        createdAt: DateTime(2026, 4, 10, 9, 0),
        updatedAt: DateTime(2026, 4, 10, 9, 30),
      ),
      Note(
        id: 'note-2',
        content: 'Second',
        createdAt: DateTime(2026, 4, 10, 10, 0),
        updatedAt: DateTime(2026, 4, 10, 10, 30),
      ),
    ];

    await tester.pumpWidget(
      _wrapHome(
        overrides: [
          notesListProvider.overrideWith((ref) async => notes),
        ],
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('First'), findsOneWidget);
    expect(find.text('Second'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) => widget is SizedBox && widget.height == 4,
      ),
      findsWidgets,
    );
  });

  testWidgets('opens settings when the settings button is tapped', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _wrapWithRouter(
        overrides: [
          notesListProvider.overrideWith((ref) async => const []),
        ],
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    expect(find.text('settings route'), findsOneWidget);
  });

  testWidgets('opens note creation when the add button is tapped', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _wrapWithRouter(
        overrides: [
          notesListProvider.overrideWith((ref) async => const []),
        ],
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('new note route'), findsOneWidget);
  });

  testWidgets('opens an existing note when a list item is tapped', (
    WidgetTester tester,
  ) async {
    final note = Note(
      id: 'note-42',
      content: 'Project plan',
      createdAt: DateTime(2026, 4, 10, 9, 0),
      updatedAt: DateTime(2026, 4, 10, 9, 30),
    );

    await tester.pumpWidget(
      _wrapWithRouter(
        overrides: [
          notesListProvider.overrideWith((ref) async => [note]),
        ],
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(find.text('Project plan'));
    await tester.pumpAndSettle();

    expect(find.text('note route note-42'), findsOneWidget);
  });

  testWidgets('confirms deletion and calls the notes service', (
    WidgetTester tester,
  ) async {
    final note = Note(
      id: 'note-1',
      content: 'Disposable',
      createdAt: DateTime(2026, 4, 10, 9, 0),
      updatedAt: DateTime(2026, 4, 10, 9, 30),
    );
    final service = _FakeNotesService();

    await tester.pumpWidget(
      _wrapHome(
        overrides: [
          notesListProvider.overrideWith((ref) async => [note]),
          notesServiceProvider.overrideWithValue(service),
        ],
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.drag(find.text('Disposable'), const Offset(-500, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Yes!'));
    await tester.pumpAndSettle();

    expect(service.deletedIds, ['note-1']);
  });

  testWidgets('cancels deletion when the user backs out', (
    WidgetTester tester,
  ) async {
    final note = Note(
      id: 'note-2',
      content: 'Keep me',
      createdAt: DateTime(2026, 4, 10, 9, 0),
      updatedAt: DateTime(2026, 4, 10, 9, 30),
    );
    final service = _FakeNotesService();

    await tester.pumpWidget(
      _wrapHome(
        overrides: [
          notesListProvider.overrideWith((ref) async => [note]),
          notesServiceProvider.overrideWithValue(service),
        ],
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.drag(find.text('Keep me'), const Offset(-500, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('No! Nevermind...'));
    await tester.pumpAndSettle();

    expect(service.deletedIds, isEmpty);
  });
}

Widget _wrapHome({required dynamic overrides}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      theme: AppTheme.darkTheme,
      home: const NoteListScreen(),
    ),
  );
}

Widget _wrapWithRouter({required dynamic overrides}) {
  final router = GoRouter(
    initialLocation: '/list',
    routes: [
      GoRoute(path: '/list', builder: (_, _) => const NoteListScreen()),
      GoRoute(
        path: '/settings',
        builder: (_, _) => const Scaffold(body: Center(child: Text('settings route'))),
      ),
      GoRoute(
        path: '/note',
        builder: (_, _) => const Scaffold(body: Center(child: Text('new note route'))),
      ),
      GoRoute(
        path: '/note/:id',
        builder: (_, state) => Scaffold(
          body: Center(
            child: Text('note route ${state.pathParameters['id']}'),
          ),
        ),
      ),
    ],
  );

  return ProviderScope(
    overrides: overrides,
    child: MaterialApp.router(
      theme: AppTheme.darkTheme,
      routerConfig: router,
    ),
  );
}

class _FakeNotesService implements NotesService {
  final List<String> deletedIds = [];

  @override
  Future<Note> createEmpty() {
    throw UnimplementedError();
  }

  @override
  Future<void> delete(String id) async {
    deletedIds.add(id);
  }

  @override
  Future<List<Note>> list() {
    throw UnimplementedError();
  }

  @override
  Future<Note> open(String id) {
    throw UnimplementedError();
  }

  @override
  Future<void> save(Note note) {
    throw UnimplementedError();
  }
}
