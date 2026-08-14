import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class MarkdownInlineTextBuilder {
  static final _markdownLink = RegExp(
    r'\[([^\]\r\n]+)\]\(((?:https?:\/\/|www\.)[^)\s]+)\)',
    caseSensitive: false,
  );

  static final _bareUrl = RegExp(
    r'(?:https?:\/\/|www\.)[^\s<>\[\]{}*~]+',
    caseSensitive: false,
  );

  static final _wwwPrefix = RegExp(r'^www\.', caseSensitive: false);

  static const _trailingPunctuation = {'.', ',', '!', '?', ';', ':', '\'', '"'};

  final ValueChanged<Uri>? onOpenLink;
  final List<TapGestureRecognizer> _linkRecognizers = [];

  MarkdownInlineTextBuilder({this.onOpenLink});

  TextSpan build(String text, {TextStyle? style, Color? linkColor}) {
    _disposeLinkRecognizers();

    return TextSpan(
      style: style,
      children: _buildSpans(text, style: style, linkColor: linkColor),
    );
  }

  void dispose() {
    _disposeLinkRecognizers();
  }

  List<InlineSpan> _buildSpans(
    String text, {
    required TextStyle? style,
    required Color? linkColor,
  }) {
    final spans = <InlineSpan>[];
    var buffer = StringBuffer();
    var i = 0;

    void flushBuffer() {
      if (buffer.isEmpty) {
        return;
      }

      spans.add(TextSpan(text: buffer.toString(), style: style));

      buffer = StringBuffer();
    }

    while (i < text.length) {
      final markdownLinkMatch = _markdownLink.matchAsPrefix(text, i);

      if (markdownLinkMatch != null) {
        final label = markdownLinkMatch.group(1)!;
        final target = _trimTrailingUrlPunctuation(markdownLinkMatch.group(2)!);
        final uri = _toHttpUri(target);

        if (uri != null) {
          flushBuffer();

          spans.add(
            _buildLinkSpan(
              label: label,
              uri: uri,
              style: style,
              linkColor: linkColor,
            ),
          );

          i = markdownLinkMatch.end;
          continue;
        }
      }

      final bareUrlMatch = _bareUrl.matchAsPrefix(text, i);

      if (bareUrlMatch != null) {
        final matchedUrl = bareUrlMatch.group(0)!;
        final visibleUrl = _trimTrailingUrlPunctuation(matchedUrl);
        final uri = _toHttpUri(visibleUrl);

        if (uri != null) {
          flushBuffer();

          spans.add(
            _buildLinkSpan(
              label: visibleUrl,
              uri: uri,
              style: style,
              linkColor: linkColor,
            ),
          );

          // Reprocessa a pontuação removida como texto comum.
          i += visibleUrl.length;
          continue;
        }
      }

      if (_startsWith(text, i, '***')) {
        final end = text.indexOf('***', i + 3);

        if (end != -1) {
          flushBuffer();

          final content = text.substring(i + 3, end);
          final combinedStyle = (style ?? const TextStyle()).copyWith(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          );

          spans.add(
            _buildStyledSpan(
              content,
              style: combinedStyle,
              linkColor: linkColor,
            ),
          );

          i = end + 3;
          continue;
        }

        buffer.write('***');
        i += 3;
        continue;
      }

      if (_startsWith(text, i, '**')) {
        final end = text.indexOf('**', i + 2);

        if (end != -1) {
          flushBuffer();

          final content = text.substring(i + 2, end);
          final boldStyle = (style ?? const TextStyle()).copyWith(
            fontWeight: FontWeight.bold,
          );

          spans.add(
            _buildStyledSpan(content, style: boldStyle, linkColor: linkColor),
          );

          i = end + 2;
          continue;
        }

        buffer.write('**');
        i += 2;
        continue;
      }

      if (_startsWith(text, i, '~~')) {
        final end = text.indexOf('~~', i + 2);

        if (end != -1) {
          flushBuffer();

          final content = text.substring(i + 2, end);
          final strikeStyle = (style ?? const TextStyle()).copyWith(
            decoration: TextDecoration.lineThrough,
          );

          spans.add(
            _buildStyledSpan(content, style: strikeStyle, linkColor: linkColor),
          );

          i = end + 2;
          continue;
        }

        buffer.write('~~');
        i += 2;
        continue;
      }

      if (_startsWith(text, i, '*')) {
        final end = text.indexOf('*', i + 1);

        if (end != -1) {
          flushBuffer();

          final content = text.substring(i + 1, end);
          final italicStyle = (style ?? const TextStyle()).copyWith(
            fontStyle: FontStyle.italic,
          );

          spans.add(
            _buildStyledSpan(content, style: italicStyle, linkColor: linkColor),
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

    return spans;
  }

  TextSpan _buildStyledSpan(
    String content, {
    required TextStyle style,
    required Color? linkColor,
  }) {
    final children = _buildSpans(content, style: style, linkColor: linkColor);

    // Mantém a estrutura antiga para texto puro, sem links/formatação aninhada.
    if (children.length == 1 && children.single is TextSpan) {
      final child = children.single as TextSpan;

      if (child.recognizer == null && child.children == null) {
        return TextSpan(text: child.text, style: style);
      }
    }

    return TextSpan(style: style, children: children);
  }

  TextSpan _buildLinkSpan({
    required String label,
    required Uri uri,
    required TextStyle? style,
    required Color? linkColor,
  }) {
    final recognizer = TapGestureRecognizer()
      ..onTap = () => onOpenLink?.call(uri);

    _linkRecognizers.add(recognizer);

    return TextSpan(
      text: label,
      recognizer: recognizer,
      mouseCursor: SystemMouseCursors.click,
      style: (style ?? const TextStyle()).copyWith(
        color: linkColor,
        decoration: TextDecoration.underline,
        decorationColor: linkColor,
      ),
    );
  }

  Uri? _toHttpUri(String rawUrl) {
    final normalized = _wwwPrefix.hasMatch(rawUrl) ? 'https://$rawUrl' : rawUrl;

    final uri = Uri.tryParse(normalized);

    if (uri == null ||
        uri.host.isEmpty ||
        (uri.scheme != 'http' && uri.scheme != 'https')) {
      return null;
    }

    return uri;
  }

  String _trimTrailingUrlPunctuation(String value) {
    var end = value.length;

    while (end > 0 && _trailingPunctuation.contains(value[end - 1])) {
      end--;
    }

    while (end > 0 &&
        value[end - 1] == ')' &&
        _hasUnmatchedClosingParenthesis(value.substring(0, end))) {
      end--;
    }

    return value.substring(0, end);
  }

  bool _hasUnmatchedClosingParenthesis(String value) {
    var depth = 0;

    for (var index = 0; index < value.length; index++) {
      final character = value[index];

      if (character == '(') {
        depth++;
      } else if (character == ')') {
        if (depth == 0) {
          return true;
        }

        depth--;
      }
    }

    return false;
  }

  void _disposeLinkRecognizers() {
    for (final recognizer in _linkRecognizers) {
      recognizer.dispose();
    }

    _linkRecognizers.clear();
  }

  bool _startsWith(String source, int index, String pattern) {
    if (index + pattern.length > source.length) {
      return false;
    }

    return source.substring(index, index + pattern.length) == pattern;
  }
}
