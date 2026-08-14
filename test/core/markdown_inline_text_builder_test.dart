import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veil/features/notes/presentation/editor/markdown_inline_text_builder.dart';

void main() {
  late MarkdownInlineTextBuilder builder;

  setUp(() {
    builder = MarkdownInlineTextBuilder();
  });

  tearDown(() {
    builder.dispose();
  });

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

    test('builds combined bold and italic spans with triple asterisks', () {
      final span = builder.build('***both***');
      final children = span.children!.cast<TextSpan>();

      expect(children, hasLength(1));
      expect(children.single.text, 'both');
      expect(children.single.style?.fontWeight, FontWeight.bold);
      expect(children.single.style?.fontStyle, FontStyle.italic);
    });

    test('recognizes standard URLs and removes trailing punctuation', () {
      final span = builder.build('Access https://github.com/veil-notes/veil.');

      final link = span.children!.whereType<TextSpan>().singleWhere(
        (child) => child.recognizer != null,
      );

      expect(link.text, 'https://github.com/veil-notes/veil');
      expect(span.toPlainText(), 'Access https://github.com/veil-notes/veil.');
    });

    test('renders Markdown links with their label', () {
      final span = builder.build(
        'Read [the docs](https://github.com/veil-notes/veil).',
      );

      final link = span.children!.whereType<TextSpan>().singleWhere(
        (child) => child.recognizer != null,
      );

      expect(link.text, 'the docs');
      expect(span.toPlainText(), 'Read the docs.');
    });

    test('renders a Markdown link nested in bold text', () {
      final openedLinks = <Uri>[];

      final linkBuilder = MarkdownInlineTextBuilder(
        onOpenLink: openedLinks.add,
      );

      addTearDown(linkBuilder.dispose);

      final span = linkBuilder.build(
        '**Read [the docs](https://github.com/veil-notes/veil)**',
      );

      final boldSpan = span.children!.single as TextSpan;
      final linkSpan = boldSpan.children!.whereType<TextSpan>().singleWhere(
        (child) => child.recognizer != null,
      );
      final recognizer = linkSpan.recognizer! as TapGestureRecognizer;

      expect(boldSpan.style?.fontWeight, FontWeight.bold);
      expect(linkSpan.text, 'the docs');
      expect(linkSpan.style?.fontWeight, FontWeight.bold);
      expect(linkSpan.style?.decoration, TextDecoration.underline);

      recognizer.onTap!.call();

      expect(openedLinks, [Uri.parse('https://github.com/veil-notes/veil')]);
    });
  });
}
