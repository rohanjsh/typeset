import 'package:flutter/material.dart';
import 'package:typeset/src/reserved.dart';

/// Formatting actions available in the context menu.
enum TypesetFormatAction {
  /// Bold (`*text*`).
  bold('Bold'),

  /// Italic (`_text_`).
  italic('Italic'),

  /// Strikethrough (`~text~`).
  strikethrough('Strikethrough'),

  /// Monospace (`` `text` ``).
  monospace('Monospace'),

  /// Underline (`__text__`).
  underline('Underline');

  const TypesetFormatAction(this.label);

  /// User-facing label for this action.
  final String label;

  /// The delimiter string that wraps the selected text.
  String get delimiter {
    switch (this) {
      case TypesetFormatAction.bold:
        return TypesetReserved.boldChar;
      case TypesetFormatAction.italic:
        return TypesetReserved.italicChar;
      case TypesetFormatAction.strikethrough:
        return TypesetReserved.strikethroughChar;
      case TypesetFormatAction.monospace:
        return TypesetReserved.monospaceChar;
      case TypesetFormatAction.underline:
        return TypesetReserved.underlineChar;
    }
  }
}

/// Generates [ContextMenuButtonItem]s that wrap the current selection with
/// TypeSet delimiters.
List<ContextMenuButtonItem> getTypesetContextMenus({
  required EditableTextState editableTextState,
  List<TypesetFormatAction>? actions,
}) {
  final value = editableTextState.textEditingValue;
  if (!_hasUsableSelection(value)) {
    return const <ContextMenuButtonItem>[];
  }

  final selectionText = value.selection.textInside(value.text);

  if (selectionText.isEmpty || _isAlreadyWrapped(selectionText)) {
    return const <ContextMenuButtonItem>[];
  }

  final effectiveActions =
      actions == null || actions.isEmpty ? TypesetFormatAction.values : actions;

  return effectiveActions
      .map(
        (action) => ContextMenuButtonItem(
          label: action.label,
          onPressed: () => editableTextState.updateEditingValue(
            _applyFormatAction(value, action),
          ),
        ),
      )
      .toList(growable: false);
}

bool _isAlreadyWrapped(String text) {
  for (final delimiter in TypesetReserved.all) {
    if (text.length > delimiter.length * 2 &&
        text.startsWith(delimiter) &&
        text.endsWith(delimiter)) {
      return true;
    }
  }
  return false;
}

TextEditingValue _applyFormatAction(
  TextEditingValue value,
  TypesetFormatAction action,
) {
  if (!_hasUsableSelection(value)) return value;

  final selectedText = value.selection.textInside(value.text);
  final escapedText = _escapeReservedCharacters(selectedText);
  final replacement = '${action.delimiter}$escapedText${action.delimiter}';
  final newText = value.text.replaceRange(
    value.selection.start,
    value.selection.end,
    replacement,
  );

  return value.copyWith(
    text: newText,
    selection: TextSelection.collapsed(
      offset: value.selection.start + replacement.length,
    ),
    composing: TextRange.empty,
  );
}

bool _hasUsableSelection(TextEditingValue value) {
  final selection = value.selection;
  return selection.isValid &&
      selection.start >= 0 &&
      selection.end <= value.text.length;
}

String _escapeReservedCharacters(String text) {
  final buffer = StringBuffer();
  for (var index = 0; index < text.length; index++) {
    final character = text[index];
    if (character == TypesetReserved.escapeChar ||
        TypesetReserved.allSingle.contains(character)) {
      buffer.write(TypesetReserved.escapeChar);
    }
    buffer.write(character);
  }
  return buffer.toString();
}
