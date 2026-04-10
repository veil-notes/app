import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veil/features/notes/presentation/editor/markdown_inline_text_builder.dart';

void main() {
  const builder = MarkdownInlineTextBuilder();

  group('MarkdownInlineTextBuilder', () {
    test('builds bold, italic and strike spans', () {
      const baseStyle = TextStyle(fontSize: 16);
      final span = builder.build(
        'start **bold** *italic* ~~strike~~ end',
        style: baseStyle,
      );

      final children = span.children!;

      expect(children, hasLength(7));
      expect((children[0] as TextSpan).text, 'start ');
      expect((children[1] as TextSpan).text, 'bold');
      expect((children[1] as TextSpan).style?.fontWeight, FontWeight.bold);
      expect((children[3] as TextSpan).text, 'italic');
      expect((children[3] as TextSpan).style?.fontStyle, FontStyle.italic);
      expect((children[5] as TextSpan).text, 'strike');
      expect(
        (children[5] as TextSpan).style?.decoration,
        TextDecoration.lineThrough,
      );
    });

    test('keeps unmatched markers as plain text', () {
      final span = builder.build('Open **marker and *another');
      final children = span.children!.cast<TextSpan>();

      expect(span.toPlainText(), 'Open **marker and *another');
      expect(
        children.where((child) => child.style?.fontWeight == FontWeight.bold),
        isEmpty,
      );
      expect(
        children.where((child) => child.style?.fontStyle == FontStyle.italic),
        isEmpty,
      );
      expect(
        children.where(
          (child) => child.style?.decoration == TextDecoration.lineThrough,
        ),
        isEmpty,
      );
    });

    test('keeps unmatched strike markers as plain text', () {
      final span = builder.build('Open ~~marker');

      expect(span.toPlainText(), 'Open ~~marker');
      expect(
        span.children!.whereType<TextSpan>().where(
          (child) => child.style?.decoration == TextDecoration.lineThrough,
        ),
        isEmpty,
      );
    });

    test('returns plain text span when markdown markers are absent', () {
      final span = builder.build('Just text');

      expect(span.toPlainText(), 'Just text');
      expect((span.children!.single as TextSpan).text, 'Just text');
    });
  });
}
