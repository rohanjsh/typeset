import 'package:flutter/material.dart';
import 'package:typeset/src/models/style_type_enum.dart';
import 'package:typeset/typeset.dart';

/// Generates a list of [ContextMenuButtonItem]s for text editing actions.
///
/// This method builds context menu items that apply various text styling
/// options to the selected text within a [TextField]. The styles are
/// determined by the [styleTypes] list provided. If no styles are specified,
/// then all available text styles are included by default.
///
/// The method leverages the [EditableTextState]'s `textEditingValue` to
/// customize the text styling and updates the state accordingly.
///
/// ## Parameters:
///
/// - `editableTextState`: The state of the editable text field. It is
///   used to apply the style changes to the current text.
/// - `styleTypes`: An optional list of [StyleTypeEnum] that specifies
///   which styles should be present in the context menu. If not provided,
///   all styles are included.
///
/// ## Returns:
/// A list of [ContextMenuButtonItem] where each item represents a
/// button in the context menu for styling the selected text in
/// the associated text field.
///
/// ## Usage Examples:
///
/// ```dart
/// // Within a [TextField], using the default constructor
/// TextField(
///   contextMenuBuilder: (context, editableTextState) {
///     return AdaptiveTextSelectionToolbar.buttonItems(
///       anchors: editableTextState.contextMenuAnchors,
///       buttonItems: getTypesetContextMenus(editableTextState: editableTextState),
///     );
///   },
/// );
/// ```
///
/// ## Context Menu Item Actions:
///
/// When a context menu item is selected, it applies a specific style to the text.
/// For instance, selecting 'Bold' wraps the selected text with `boldChar`.
/// Similarly, 'Italic', 'Strikethrough', 'Monospace', 'Underline', and 'Link'
/// apply their respective styles as per the definitions in [TypesetReserved].
///
/// ```dart
/// // Applying a single style, for example, Bold
/// var buttonItems = getTypesetContextMenus(
///   editableTextState: editableTextState,
///   styleTypes: [StyleTypeEnum.bold],
/// );
/// buttonItems.firstWhere((item) => item.label == 'Bold').onPressed();
/// // This will embolden the selected text.
/// ```

List<ContextMenuButtonItem> getTypesetContextMenus({
  required EditableTextState editableTextState,
  List<StyleTypeEnum>? styleTypes,
}) {
  final buttonItems = <ContextMenuButtonItem>[];
  final value = editableTextState.textEditingValue;
  final selectionText = value.selection.textInside(value.text);

  // If no specific styles are provided, add all available styles
  if (styleTypes == null || styleTypes.isEmpty) {
    styleTypes = StyleTypeEnum.values.toList();
  }

  //if text is already styled, return
  for (final char in TypesetReserved.all) {
    if (selectionText.startsWith(char) && selectionText.endsWith(char)) {
      return buttonItems;
    }
  }

  // Helper to escape reserved chars with broken bar
  String escapeReservedChars(String originalText) {
    final escapedText = originalText.split('').map((char) {
      if (TypesetReserved.all.contains(char)) {
        // Prepend the escape literal before the reserved char
        return '${TypesetReserved.escapeLiteral}$char';
      }
      return char;
    }).join();
    return escapedText;
  }

  void applyTextStyle(String char) {
    final text = escapeReservedChars(value.selection.textInside(value.text));
    final newText = value.text.replaceRange(
      value.selection.start,
      value.selection.end,
      '$char$text$char',
    );
    editableTextState.updateEditingValue(
      value.copyWith(
        text: newText,
        selection: TextSelection.collapsed(
          offset: value.selection.start + char.length * 2 + text.length,
        ),
      ),
    );
  }

  void applyLinkStyle() {
    final text = escapeReservedChars(value.selection.textInside(value.text));
    final newText = value.text.replaceRange(
      value.selection.start,
      value.selection.end,
      '${TypesetReserved.linkChar}$text${TypesetReserved.linkSplitChar}https://$text${TypesetReserved.linkChar}',
    );
    editableTextState.updateEditingValue(
      value.copyWith(
        text: newText,
        selection: TextSelection.collapsed(
          offset: value.selection.start +
              text.length +
              TypesetReserved.linkChar.length * 2 +
              TypesetReserved.linkSplitChar.length,
        ),
      ),
    );
  }

  // Adding buttons based on the provided style types
  if (styleTypes.contains(StyleTypeEnum.bold)) {
    buttonItems.add(
      ContextMenuButtonItem(
        label: 'Bold',
        onPressed: () => applyTextStyle(TypesetReserved.boldChar),
      ),
    );
  }

  if (styleTypes.contains(StyleTypeEnum.italic)) {
    buttonItems.add(
      ContextMenuButtonItem(
        label: 'Italic',
        onPressed: () => applyTextStyle(TypesetReserved.italicChar),
      ),
    );
  }

  if (styleTypes.contains(StyleTypeEnum.strikethrough)) {
    buttonItems.add(
      ContextMenuButtonItem(
        label: 'Strikethrough',
        onPressed: () => applyTextStyle(TypesetReserved.strikethroughChar),
      ),
    );
  }

  if (styleTypes.contains(StyleTypeEnum.monospace)) {
    buttonItems.add(
      ContextMenuButtonItem(
        label: 'Monospace',
        onPressed: () => applyTextStyle(TypesetReserved.monospaceChar),
      ),
    );
  }

  if (styleTypes.contains(StyleTypeEnum.underline)) {
    buttonItems.add(
      ContextMenuButtonItem(
        label: 'Underline',
        onPressed: () => applyTextStyle(TypesetReserved.underlineChar),
      ),
    );
  }

  if (styleTypes.contains(StyleTypeEnum.link)) {
    buttonItems.add(
      ContextMenuButtonItem(
        label: 'Link',
        onPressed: applyLinkStyle,
      ),
    );
  }

  return buttonItems;
}
