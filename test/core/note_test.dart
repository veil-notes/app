import 'package:flutter_test/flutter_test.dart';
import 'package:veil/features/notes/domain/note.dart';

void main() {
  final createdAt = DateTime(2026, 4, 10, 9, 0);
  final updatedAt = DateTime(2026, 4, 10, 9, 30);

  group('Note', () {
    test('returns Untitled when content is blank', () {
      final note = Note(
        id: 'note-1',
        content: '   \n  ',
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(note.title, 'Untitled');
    });

    test('uses the first non-empty trimmed line as title', () {
      final note = Note(
        id: 'note-1',
        content: '  # Launch plan  \nSecond line',
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(note.title, '# Launch plan');
    });

    test('copyWith preserves untouched fields and updates provided ones', () {
      final note = Note(
        id: 'note-1',
        content: 'Initial',
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      final copy = note.copyWith(
        content: 'Updated',
        updatedAt: updatedAt.add(const Duration(minutes: 10)),
      );

      expect(copy.id, note.id);
      expect(copy.createdAt, note.createdAt);
      expect(copy.content, 'Updated');
      expect(copy.updatedAt, updatedAt.add(const Duration(minutes: 10)));
    });

    test('copyWith keeps original content and updatedAt when omitted', () {
      final note = Note(
        id: 'note-1',
        content: 'Initial',
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      final copy = note.copyWith(id: 'note-2');

      expect(copy.id, 'note-2');
      expect(copy.content, note.content);
      expect(copy.updatedAt, note.updatedAt);
    });

    test('serializes and deserializes through json', () {
      final note = Note(
        id: 'note-1',
        content: 'Body',
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      final restored = Note.fromJson(note.toJson());

      expect(restored.id, note.id);
      expect(restored.content, note.content);
      expect(restored.createdAt, note.createdAt);
      expect(restored.updatedAt, note.updatedAt);
    });
  });
}
