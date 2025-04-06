import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:typeset/src/core/typeset_parser.dart';
import 'package:typeset/src/core/typeset_reserved.dart';

/// A custom [TextEditingController] that provides WhatsApp-style text
/// formatting capabilities in a text input field.
///
/// This controller extends the standard [TextEditingController] and overrides
/// the [buildTextSpan] method to apply formatting to the text as it's being
/// edited. It uses the [TypesetParser] to parse and format the text according
/// to the formatting rules defined in the package.
///
/// Example usage:
/// ```dart
/// final controller = TypeSetEditingController();
/// TextField(
///   controller: controller,
///   // Other TextField properties
/// );
/// ```
///
/// The text can be formatted using the following syntax:
/// - Bold: *text*
/// - Italic: _text_
/// - Strikethrough: ~text~
/// - Underline: #text#
/// - Monospace: `text`
/// - Link: §text|url§
/// - Font size: text<size>
///
/// The controller automatically renders the formatted text in the TextField
/// while preserving the raw text with formatting markers for editing.
class TypeSetEditingController extends TextEditingController {
  /// Creates a controller for an editable text field with WhatsApp-style
  /// text formatting capabilities.
  ///
  /// The [text] parameter is the initial text to be displayed in the text
  /// field.
  /// The [linkStyle] parameter is the style to apply to links in the text.
  /// The [linkRecognizerBuilder] parameter is a function that builds a gesture
  /// recognizer for links.
  /// The [monospaceStyle] parameter is the style to apply to monospace text.
  /// The [boldStyle] parameter is the style to apply to bold text.
  /// The [markerColor] parameter is the color to use for formatting markers
  /// (like *, _, etc.).
  TypeSetEditingController({
    super.text,
    this.linkStyle,
    this.linkRecognizerBuilder,
    this.monospaceStyle,
    this.boldStyle,
    this.markerColor = const Color(0xFF9E9E9E),
  });

  /// The style to apply to links in the text.
  final TextStyle? linkStyle;

  /// A function that builds a gesture recognizer for links in the text.
  final GestureRecognizer Function(String text, String url)?
      linkRecognizerBuilder;

  /// The style to apply to monospace text.
  final TextStyle? monospaceStyle;

  /// The style to apply to bold text.
  final TextStyle? boldStyle;

  /// The color to use for formatting markers (like *, _, etc.)
  final Color markerColor;

  /// Checks if a character is a formatting marker.
  ///
  /// Returns true if the character is one of the formatting markers defined
  /// in [TypesetReserved].
  bool _isFormattingMarker(String char) {
    return char == TypesetReserved.boldChar ||
        char == TypesetReserved.italicChar ||
        char == TypesetReserved.strikethroughChar ||
        char == TypesetReserved.underlineChar ||
        char == TypesetReserved.monospaceChar ||
        char == TypesetReserved.linkChar;
  }

  TextStyle _getStyleForMarker() {
    return TextStyle(color: markerColor);
  }

  /// Gets the content style for a specific marker.
  ///
  /// This method returns a [TextStyle] for the content between formatting
  /// markers.
  ///
  /// [marker] is the formatting marker character.
  /// [baseStyle] is the base style to extend from if needed.
  TextStyle _getContentStyleForMarker(String marker, TextStyle? baseStyle) {
    switch (marker) {
      case TypesetReserved.boldChar:
        return boldStyle ?? const TextStyle(fontWeight: FontWeight.bold);
      case TypesetReserved.italicChar:
        return const TextStyle(fontStyle: FontStyle.italic);
      case TypesetReserved.strikethroughChar:
        return const TextStyle(decoration: TextDecoration.lineThrough);
      case TypesetReserved.underlineChar:
        return const TextStyle(decoration: TextDecoration.underline);
      case TypesetReserved.monospaceChar:
        return monospaceStyle ?? const TextStyle(fontFamily: 'Courier');
      case TypesetReserved.linkChar:
        return linkStyle ??
            const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            );
      default:
        return baseStyle ?? const TextStyle();
    }
  }

  /// Handles a link formatting in the text.
  ///
  /// This method processes link formatting and adds appropriate [TextSpan]s
  /// to the [spans] list.
  ///
  /// [spans] is the list of [TextSpan]s to add to.
  /// [content] is the content between link markers.
  /// [contentStyle] is the style to apply to the link text.
  /// [closingIndex] is the index of the closing marker.
  /// Returns the index to continue processing from, or -1 to continue normal
  /// processing.
  int _handleLinkFormatting({
    required List<TextSpan> spans,
    required String content,
    required TextStyle contentStyle,
    required int closingIndex,
  }) {
    final linkParts = content.split(TypesetReserved.linkSplitChar);
    final linkText = linkParts.isNotEmpty ? linkParts[0] : '';
    final url = linkParts.length > 1 ? linkParts[1] : '';

    // If we have a link recognizer, use it
    if (linkRecognizerBuilder != null && url.isNotEmpty) {
      spans.add(
        TextSpan(
          text: linkText,
          style: contentStyle,
          recognizer: linkRecognizerBuilder?.call(linkText, url),
        ),
      );

      // If there's a separator, add it with marker style
      if (linkParts.length > 1) {
        spans
          ..add(
            TextSpan(
              text: TypesetReserved.linkSplitChar,
              style: TextStyle(color: markerColor),
            ),
          )
          ..add(
            TextSpan(
              text: url,
              style: contentStyle,
            ),
          );
      }

      // Skip to after the closing marker
      return closingIndex;
    }

    // If no recognizer or URL, just add the content as a normal span
    spans.add(
      TextSpan(
        text: content,
        style: contentStyle,
      ),
    );
    return -1; // Signal to continue normal processing
  }

  /// Finds the index of the next formatting marker in the text.
  ///
  /// [startIndex] is the index to start searching from.
  /// [textLength] is the length of the text.
  /// Returns the index of the next marker, or [textLength] if none is found.
  int _findNextMarkerIndex(int startIndex, int textLength) {
    var nextMarkerIndex = textLength;
    for (final marker in TypesetReserved.all) {
      final index = text.indexOf(marker, startIndex);
      if (index != -1 && index < nextMarkerIndex) {
        nextMarkerIndex = index;
      }
    }
    return nextMarkerIndex;
  }

  /// Handles escaped formatting markers in the text.
  ///
  /// [spans] is the list of [TextSpan]s to add to.
  /// [currentIndex] is the current index in the text.
  /// [style] is the base style to apply to the escaped character.
  /// Returns the new index after processing the escaped character.
  int _handleEscapedMarker({
    required List<TextSpan> spans,
    required int currentIndex,
    required TextStyle? style,
  }) {
    spans
      ..add(
        TextSpan(
          text: TypesetReserved.escapeLiteral,
          style: TextStyle(color: markerColor),
        ),
      )
      ..add(
        TextSpan(
          text: text[currentIndex + 1],
          style: style,
        ),
      );
    return currentIndex + 2;
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    // Handle empty text case
    if (text.isEmpty) {
      return TextSpan(style: style);
    }

    // Create a list to hold our text spans
    final spans = <TextSpan>[];

    // Process the text to find formatting markers and create appropriate spans
    var currentIndex = 0;
    final textLength = text.length;

    // Process the text character by character
    while (currentIndex < textLength) {
      final currentChar = text[currentIndex];

      // Check if the current character is a formatting marker
      if (_isFormattingMarker(currentChar)) {
        // Add the marker with a special style
        spans.add(
          TextSpan(
            text: currentChar,
            style: _getStyleForMarker(),
          ),
        );

        // Find the matching closing marker
        final closingIndex = text.indexOf(currentChar, currentIndex + 1);
        if (closingIndex != -1) {
          // Extract the content between markers
          final content = text.substring(currentIndex + 1, closingIndex);

          // Add the content with appropriate styling
          if (content.isNotEmpty) {
            final contentStyle = _getContentStyleForMarker(currentChar, style);

            // Special handling for links
            if (currentChar == TypesetReserved.linkChar) {
              final newIndex = _handleLinkFormatting(
                spans: spans,
                content: content,
                contentStyle: contentStyle,
                closingIndex: closingIndex,
              );

              if (newIndex != -1) {
                currentIndex = newIndex;
                continue;
              }
            } else {
              // Add the styled content for non-link formatting
              spans.add(
                TextSpan(
                  text: content,
                  style: contentStyle,
                ),
              );
            }
          }

          // Add the closing marker with special style
          spans.add(
            TextSpan(
              text: currentChar,
              style: _getStyleForMarker(),
            ),
          );

          // Move the index past the closing marker
          currentIndex = closingIndex + 1;
        } else {
          // No closing marker found, treat as normal text
          currentIndex++;
        }
      } else if (currentChar == TypesetReserved.escapeLiteral &&
          currentIndex + 1 < textLength &&
          _isFormattingMarker(text[currentIndex + 1])) {
        // Handle escaped formatting markers
        currentIndex = _handleEscapedMarker(
          spans: spans,
          currentIndex: currentIndex,
          style: style,
        );
      } else {
        // Handle normal text
        final nextMarkerIndex = _findNextMarkerIndex(currentIndex, textLength);

        // Add the text up to the next marker
        if (nextMarkerIndex > currentIndex) {
          spans.add(
            TextSpan(
              text: text.substring(currentIndex, nextMarkerIndex),
              style: style,
            ),
          );
          currentIndex = nextMarkerIndex;
        } else {
          // No more markers, add the rest of the text
          spans.add(
            TextSpan(
              text: text.substring(currentIndex),
              style: style,
            ),
          );
          break;
        }
      }
    }

    return TextSpan(
      style: style,
      children: spans,
    );
  }
}
