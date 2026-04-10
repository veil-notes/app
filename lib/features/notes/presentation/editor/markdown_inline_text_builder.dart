import 'package:flutter/material.dart';

class MarkdownInlineTextBuilder {
  const MarkdownInlineTextBuilder();

  TextSpan build(
    String text, {
    TextStyle? style,
  }) {
    final spans = <InlineSpan>[];
    var buffer = StringBuffer();
    var i = 0;

    void flushBuffer([TextStyle? overrideStyle]) {
      if (buffer.isEmpty) {
        return;
      }

      spans.add(
        TextSpan(
          text: buffer.toString(),
          style: overrideStyle ?? style,
        ),
      );
      buffer = StringBuffer();
    }

    while (i < text.length) {
      if (_startsWith(text, i, '**')) {
        flushBuffer();

        final end = text.indexOf('**', i + 2);
        if (end != -1) {
          final content = text.substring(i + 2, end);

          spans.add(
            TextSpan(
              text: content,
              style: (style ?? const TextStyle()).copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          );

          i = end + 2;
          continue;
        }

        buffer.write('**');
        i += 2;
        continue;
      }

      if (_startsWith(text, i, '~~')) {
        flushBuffer();

        final end = text.indexOf('~~', i + 2);
        if (end != -1) {
          final content = text.substring(i + 2, end);

          spans.add(
            TextSpan(
              text: content,
              style: (style ?? const TextStyle()).copyWith(
                decoration: TextDecoration.lineThrough,
              ),
            ),
          );

          i = end + 2;
          continue;
        }

        buffer.write('~~');
        i += 2;
        continue;
      }

      if (_startsWith(text, i, '*')) {
        flushBuffer();

        final end = text.indexOf('*', i + 1);
        if (end != -1) {
          final content = text.substring(i + 1, end);

          spans.add(
            TextSpan(
              text: content,
              style: (style ?? const TextStyle()).copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
          );

          i = end + 1;
          continue;
        }

        buffer.write('*');
        i++;
        continue;
      }

      buffer.write(text[i]);
      i++;
    }

    flushBuffer();

    return TextSpan(
      style: style,
      children: spans,
    );
  }

  bool _startsWith(String source, int index, String pattern) {
    if (index + pattern.length > source.length) {
      return false;
    }

    return source.substring(index, index + pattern.length) == pattern;
  }
}
