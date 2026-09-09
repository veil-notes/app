import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veil/app/app_theme.dart';
import 'package:veil/features/notes/presentation/editor/note_editor_toolbar.dart';
import 'package:veil/features/notes/presentation/editor/note_save_status.dart';

import '../test_localized_app.dart';

void main() {
  Widget wrap(Widget child) {
    return buildLocalizedApp(
      theme: AppTheme.darkTheme,
      home: Scaffold(body: child),
    );
  }

  group('NoteEditorToolbar', () {
    testWidgets('fires formatting callbacks', (tester) async {
      var boldTapped = false;
      var italicTapped = false;
      var bulletTapped = false;
      var orderedTapped = false;
      var checklistTapped = false;

      await tester.pumpWidget(
        wrap(
          NoteEditorToolbar(
            saveStatus: NoteSaveStatus.saved,
            onBold: () => boldTapped = true,
            onItalic: () => italicTapped = true,
            onHeadingSelected: (_) {},
            currentHeadingLevel: null,
            onBullet: () => bulletTapped = true,
            onOrdered: () => orderedTapped = true,
            onChecklist: () => checklistTapped = true,
            isBulletActive: false,
            isOrderedActive: false,
            isChecklistActive: false,
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.format_bold));
      await tester.tap(find.byIcon(Icons.format_italic));
      await tester.tap(find.byIcon(Icons.format_list_bulleted_rounded));
      await tester.tap(find.byIcon(Icons.format_list_numbered_rounded));
      await tester.tap(find.byIcon(Icons.check_box_outlined));
      await tester.pumpAndSettle();

      expect(boldTapped, isTrue);
      expect(italicTapped, isTrue);
      expect(bulletTapped, isTrue);
      expect(orderedTapped, isTrue);
      expect(checklistTapped, isTrue);
    });

    testWidgets('shows heading menu and returns selected level', (
      tester,
    ) async {
      int? selectedLevel;

      await tester.pumpWidget(
        wrap(
          NoteEditorToolbar(
            saveStatus: NoteSaveStatus.saving,
            onBold: () {},
            onItalic: () {},
            onHeadingSelected: (level) => selectedLevel = level,
            currentHeadingLevel: 2,
            onBullet: () {},
            onOrdered: () {},
            onChecklist: () {},
            isBulletActive: true,
            isOrderedActive: false,
            isChecklistActive: true,
          ),
        ),
      );

      await tester.tap(find.text('H'));
      await tester.pumpAndSettle();

      expect(find.text('Heading 1'), findsOneWidget);
      expect(find.text('Heading 5'), findsOneWidget);

      await tester.tap(find.text('Heading 4'));
      await tester.pumpAndSettle();

      expect(selectedLevel, 4);
    });

    testWidgets('renders the expected icon and color for each save status', (
      tester,
    ) async {
      final expectations = [
        (
          status: NoteSaveStatus.saved,
          icon: Icons.check,
          color: const Color(0xFF5AD13F),
        ),
        (
          status: NoteSaveStatus.saving,
          icon: Icons.save_outlined,
          color: const Color(0xFFE2B93B),
        ),
        (
          status: NoteSaveStatus.error,
          icon: Icons.priority_high,
          color: const Color(0xFFE25555),
        ),
      ];

      for (final expectation in expectations) {
        await tester.pumpWidget(
          wrap(
            NoteEditorToolbar(
              saveStatus: expectation.status,
              onBold: () {},
              onItalic: () {},
              onHeadingSelected: (_) {},
              currentHeadingLevel: null,
              onBullet: () {},
              onOrdered: () {},
              onChecklist: () {},
              isBulletActive: false,
              isOrderedActive: false,
              isChecklistActive: false,
            ),
          ),
        );

        expect(find.byType(NoteEditorToolbar), findsOneWidget);
        final icon = tester.widget<Icon>(find.byIcon(expectation.icon));
        expect(icon.color, expectation.color);

        if (expectation.status == NoteSaveStatus.saving) {
          expect(find.byType(ScaleTransition), findsOneWidget);
        } else {
          expect(find.byType(ScaleTransition), findsNothing);
        }
      }
    });
  });
}
