// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:typeset/src/models/style_type_enum.dart';
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

    //returns all styles
    test('returns all styles when no styleTypes are provided', () {
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

      expect(buttonItems.length, equals(6));
    });

    test('applies bold style when StyleTypeEnum.bold is provided', () {
      // Simulate the condition where the selected text is not styled
      when(() => mockEditableTextState.textEditingValue).thenReturn(
        const TextEditingValue(
          text: 'text',
          selection: TextSelection(baseOffset: 0, extentOffset: 4),
        ),
      );

      final buttonItems = getTypesetContextMenus(
        editableTextState: mockEditableTextState,
        styleTypes: [StyleTypeEnum.bold],
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

    //simulate tapping on all the other buttons
    test('applies italic style when StyleTypeEnum.italic is provided', () {
      // Simulate the condition where the selected text is not styled
      when(() => mockEditableTextState.textEditingValue).thenReturn(
        const TextEditingValue(
          text: 'text',
          selection: TextSelection(baseOffset: 0, extentOffset: 4),
        ),
      );

      final buttonItems = getTypesetContextMenus(
        editableTextState: mockEditableTextState,
        styleTypes: [StyleTypeEnum.italic],
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
    test('applies underline style when StyleTypeEnum.underline is provided',
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
        styleTypes: [StyleTypeEnum.underline],
      );

      // Simulate the user tapping the Underline button
      buttonItems.first.onPressed!();

      // Verify that the text is now styled
      verify(
        () => mockEditableTextState.updateEditingValue(
          const TextEditingValue(
            text: '#text#',
            selection: TextSelection.collapsed(offset: 6),
          ),
        ),
      ).called(1);
    });

    test(
        'applies strikethrough style when StyleTypeEnum.strikethrough is provided',
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
        styleTypes: [StyleTypeEnum.strikethrough],
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

    test('applies monospace style when StyleTypeEnum.monospace is provided',
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
        styleTypes: [StyleTypeEnum.monospace],
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

    //link
    test('applies link style when StyleTypeEnum.link is provided', () {
      // Simulate the condition where the selected text is not styled
      when(() => mockEditableTextState.textEditingValue).thenReturn(
        const TextEditingValue(
          text: 'text',
          selection: TextSelection(baseOffset: 0, extentOffset: 4),
        ),
      );

      final buttonItems = getTypesetContextMenus(
        editableTextState: mockEditableTextState,
        styleTypes: [StyleTypeEnum.link],
      );

      // Simulate the user tapping the Link button
      buttonItems.first.onPressed!();

      // Verify that the text is now styled
      verify(
        () => mockEditableTextState.updateEditingValue(
          const TextEditingValue(
            text: '§text|https://text§',
            selection: TextSelection.collapsed(offset: 7),
          ),
        ),
      ).called(1);
    });
  });
}
