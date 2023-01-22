import 'package:flutter/painting.dart';
import 'package:typeset/src/typeset.dart';

///TypeSet extension on String to use [typeset] method
extension TypeSetExtension on String {
  ///[typeset] method to format the text with different styles
  TypeSet typeset({
    TextStyle? style,
  }) {
    return TypeSet(
      inputText: this,
      style: style,
    );
  }
}
