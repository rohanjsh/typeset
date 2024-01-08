import 'package:flutter/material.dart';
import 'package:typeset/src/core/typeset_parser.dart';

///
class TypesetEditingController extends TextEditingController {
  ///

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final spans = TypesetParser.parser(
      inputText: text,
    );

    return TextSpan(
      style: style,
      children: spans,
    );
  }
}
