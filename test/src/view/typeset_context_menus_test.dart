// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:typeset/typeset.dart';

// Mock class for EditableTextState
class MockEditableTextState extends Mock implements EditableTextState {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

// Setup for the tests
void main() {
  setUpAll(() {
    // Register a fallback value for `TextEditingValue`
    registerFallbackValue(TextEditingValue.empty);
  });

  group('getTypesetContextMenus', () {
    late MockEditableTextState mockEditableTextState;

    setUp(() {
      mockEditableTextState = MockEditableTextState();

      // Stub the getter for textEditingValue
      when(() => mockEditableTextState.textEditingValue).thenReturn(
        const TextEditingValue(text: 'Some text'),
      );
    });

    test('returns an empty list when no text is selected', () {
      // Simulate the condition where no text is selected by setting an empty TextSelection
      when(() => mockEditableTextState.textEditingValue).thenReturn(
        const TextEditingValue(
          text: 'Some text',
          selection: TextSelection.collapsed(offset: 0),
        ),
      );

      final buttonItems = getTypesetContextMenus(
        editableTextState: mockEditableTextState,
      );

      expect(buttonItems, isEmpty);
    });

    test('returns an empty list when the selection is out of bounds', () {
      when(() => mockEditableTextState.textEditingValue).thenReturn(
        const TextEditingValue(
          text: 'text',
          selection: TextSelection(baseOffset: 0, extentOffset: 99),
        ),
      );

      final buttonItems = getTypesetContextMenus(
        editableTextState: mockEditableTextState,
      );

      expect(buttonItems, isEmpty);
    });

    test('returns an empty list when the selected text is already styled', () {
      // Simulate the condition where the selected text is already styled
      when(() => mockEditableTextState.textEditingValue).thenReturn(
        const TextEditingValue(
          text: '*bold*',
          selection: TextSelection(baseOffset: 0, extentOffset: 6),
        ),
      );

      final buttonItems = getTypesetContextMenus(
        editableTextState: mockEditableTextState,
      );

      expect(buttonItems, isEmpty);
    });

    test('returns all actions when no actions are provided', () {
      // Simulate the condition where the selected text is not styled
      when(() => mockEditableTextState.textEditingValue).thenReturn(
        const TextEditingValue(
          text: 'text',
          selection: TextSelection(baseOffset: 0, extentOffset: 4),
        ),
      );

      final buttonItems = getTypesetContextMenus(
        editableTextState: mockEditableTextState,
      );

      expect(buttonItems.length, equals(5));
    });

    test('applies bold style when TypesetFormatAction.bold is provided', () {
      // Simulate the condition where the selected text is not styled
      when(() => mockEditableTextState.textEditingValue).thenReturn(
        const TextEditingValue(
          text: 'text',
          selection: TextSelection(baseOffset: 0, extentOffset: 4),
        ),
      );

      final buttonItems = getTypesetContextMenus(
        editableTextState: mockEditableTextState,
        actions: [TypesetFormatAction.bold],
      );

      // Simulate the user tapping the Bold button
      buttonItems.first.onPressed!();

      // Verify that the text is now styled
      verify(
        () => mockEditableTextState.updateEditingValue(
          const TextEditingValue(
            text: '*text*',
            selection: TextSelection.collapsed(offset: 6),
          ),
        ),
      ).called(1);
    });

    test('escapes existing backslashes before wrapping the selection', () {
      when(() => mockEditableTextState.textEditingValue).thenReturn(
        const TextEditingValue(
          text: r'\',
          selection: TextSelection(baseOffset: 0, extentOffset: 1),
        ),
      );

      final buttonItems = getTypesetContextMenus(
        editableTextState: mockEditableTextState,
        actions: [TypesetFormatAction.bold],
      );

      buttonItems.first.onPressed!();

      verify(
        () => mockEditableTextState.updateEditingValue(
          const TextEditingValue(
            text: r'*\\*',
            selection: TextSelection.collapsed(offset: 4),
          ),
        ),
      ).called(1);
    });

    test('clears composing range after applying a format action', () {
      when(() => mockEditableTextState.textEditingValue).thenReturn(
        const TextEditingValue(
          text: 'text',
          selection: TextSelection(baseOffset: 0, extentOffset: 4),
          composing: TextRange(start: 0, end: 4),
        ),
      );

      final buttonItems = getTypesetContextMenus(
        editableTextState: mockEditableTextState,
        actions: [TypesetFormatAction.bold],
      );

      buttonItems.first.onPressed!();

      verify(
        () => mockEditableTextState.updateEditingValue(
          const TextEditingValue(
            text: '*text*',
            selection: TextSelection.collapsed(offset: 6),
          ),
        ),
      ).called(1);
    });

    //simulate tapping on all the other buttons
    test('applies italic style when TypesetFormatAction.italic is provided',
        () {
      // Simulate the condition where the selected text is not styled
      when(() => mockEditableTextState.textEditingValue).thenReturn(
        const TextEditingValue(
          text: 'text',
          selection: TextSelection(baseOffset: 0, extentOffset: 4),
        ),
      );

      final buttonItems = getTypesetContextMenus(
        editableTextState: mockEditableTextState,
        actions: [TypesetFormatAction.italic],
      );

      // Simulate the user tapping the Italic button
      buttonItems.first.onPressed!();

      // Verify that the text is now styled
      verify(
        () => mockEditableTextState.updateEditingValue(
          const TextEditingValue(
            text: '_text_',
            selection: TextSelection.collapsed(offset: 6),
          ),
        ),
      ).called(1);
    });

    //underline
    test(
        'applies underline style when TypesetFormatAction.underline is provided',
        () {
      // Simulate the condition where the selected text is not styled
      when(() => mockEditableTextState.textEditingValue).thenReturn(
        const TextEditingValue(
          text: 'text',
          selection: TextSelection(baseOffset: 0, extentOffset: 4),
        ),
      );

      final buttonItems = getTypesetContextMenus(
        editableTextState: mockEditableTextState,
        actions: [TypesetFormatAction.underline],
      );

      // Simulate the user tapping the Underline button
      buttonItems.first.onPressed!();

      // Verify that the text is now styled (__ = 2 chars)
      verify(
        () => mockEditableTextState.updateEditingValue(
          const TextEditingValue(
            text: '__text__',
            selection: TextSelection.collapsed(offset: 8),
          ),
        ),
      ).called(1);
    });

    test(
        'applies strikethrough style when TypesetFormatAction.strikethrough is provided',
        () {
      // Simulate the condition where the selected text is not styled
      when(() => mockEditableTextState.textEditingValue).thenReturn(
        const TextEditingValue(
          text: 'text',
          selection: TextSelection(baseOffset: 0, extentOffset: 4),
        ),
      );

      final buttonItems = getTypesetContextMenus(
        editableTextState: mockEditableTextState,
        actions: [TypesetFormatAction.strikethrough],
      );

      // Simulate the user tapping the Strikethrough button
      buttonItems.first.onPressed!();

      // Verify that the text is now styled
      verify(
        () => mockEditableTextState.updateEditingValue(
          const TextEditingValue(
            text: '~text~',
            selection: TextSelection.collapsed(offset: 6),
          ),
        ),
      ).called(1);
    });

    test(
        'applies monospace style when TypesetFormatAction.monospace is provided',
        () {
      // Simulate the condition where the selected text is not styled
      when(() => mockEditableTextState.textEditingValue).thenReturn(
        const TextEditingValue(
          text: 'text',
          selection: TextSelection(baseOffset: 0, extentOffset: 4),
        ),
      );

      final buttonItems = getTypesetContextMenus(
        editableTextState: mockEditableTextState,
        actions: [TypesetFormatAction.monospace],
      );

      // Simulate the user tapping the Monospace button
      buttonItems.first.onPressed!();

      // Verify that the text is now styled
      verify(
        () => mockEditableTextState.updateEditingValue(
          const TextEditingValue(
            text: '`text`',
            selection: TextSelection.collapsed(offset: 6),
          ),
        ),
      ).called(1);
    });
  });
}
