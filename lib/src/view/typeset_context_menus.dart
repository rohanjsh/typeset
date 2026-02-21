import 'package:flutter/material.dart';
import 'package:typeset/src/models/typeset_reserved.dart';

/// Style types available in the context menu.
enum StyleTypeEnum {
  /// Bold formatting.
  bold('Bold'),

  /// Italic formatting.
  italic('Italic'),

  /// Strikethrough formatting.
  strikethrough('Strikethrough'),

  /// Monospace/inline code formatting.
  monospace('Monospace'),

  /// Underline formatting.
  underline('Underline');

  const StyleTypeEnum(this.label);

  /// The display label for this style type.
  final String label;
}

/// Generates a list of [ContextMenuButtonItem]s for text editing.
///
/// Builds context menu items that apply text styling to selected text
/// within a [TextField].
/// Supports: Bold (`*text*`), Italic (`_text_`), Underline (`__text__`),
/// Strikethrough (`~text~`), Monospace (`` `text` ``).
///
/// Parameters:
/// - `editableTextState`: The state of the editable text field.
/// - `styleTypes`: Optional list of styles to include. If not provided,
///   all styles are included.
List<ContextMenuButtonItem> getTypesetContextMenus({
  required EditableTextState editableTextState,
  List<StyleTypeEnum>? styleTypes,
}) {
  final buttonItems = <ContextMenuButtonItem>[];
  final value = editableTextState.textEditingValue;
  final selectionText = value.selection.textInside(value.text);

  if (selectionText.isEmpty) {
    return buttonItems;
  }

  final effectiveStyleTypes = (styleTypes == null || styleTypes.isEmpty)
      ? StyleTypeEnum.values.toList()
      : styleTypes;

  for (final delim in TypesetReserved.all) {
    if (selectionText.startsWith(delim) && selectionText.endsWith(delim)) {
      return buttonItems;
    }
  }

  String escapeReserved(String originalText) {
    final buf = StringBuffer();
    for (var i = 0; i < originalText.length; i++) {
      final ch = originalText[i];
      if (TypesetReserved.allSingle.contains(ch)) {
        buf.write(r'\');
      }
      buf.write(ch);
    }
    return buf.toString();
  }

  void applyTextStyle(String delimiter) {
    final text = escapeReserved(
      value.selection.textInside(value.text),
    );
    final newText = value.text.replaceRange(
      value.selection.start,
      value.selection.end,
      '$delimiter$text$delimiter',
    );
    editableTextState.updateEditingValue(
      value.copyWith(
        text: newText,
        selection: TextSelection.collapsed(
          offset: value.selection.start + delimiter.length * 2 + text.length,
        ),
      ),
    );
  }

  if (effectiveStyleTypes.contains(StyleTypeEnum.bold)) {
    buttonItems.add(
      ContextMenuButtonItem(
        label: StyleTypeEnum.bold.label,
        onPressed: () => applyTextStyle(TypesetReserved.boldChar),
      ),
    );
  }

  if (effectiveStyleTypes.contains(StyleTypeEnum.italic)) {
    buttonItems.add(
      ContextMenuButtonItem(
        label: StyleTypeEnum.italic.label,
        onPressed: () => applyTextStyle(TypesetReserved.italicChar),
      ),
    );
  }

  if (effectiveStyleTypes.contains(StyleTypeEnum.strikethrough)) {
    buttonItems.add(
      ContextMenuButtonItem(
        label: StyleTypeEnum.strikethrough.label,
        onPressed: () => applyTextStyle(
          TypesetReserved.strikethroughChar,
        ),
      ),
    );
  }

  if (effectiveStyleTypes.contains(StyleTypeEnum.monospace)) {
    buttonItems.add(
      ContextMenuButtonItem(
        label: StyleTypeEnum.monospace.label,
        onPressed: () => applyTextStyle(TypesetReserved.monospaceChar),
      ),
    );
  }

  if (effectiveStyleTypes.contains(StyleTypeEnum.underline)) {
    buttonItems.add(
      ContextMenuButtonItem(
        label: StyleTypeEnum.underline.label,
        onPressed: () => applyTextStyle(TypesetReserved.underlineChar),
      ),
    );
  }

  return buttonItems;
}
