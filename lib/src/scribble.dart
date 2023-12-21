///+----------------------+
///|      CONTROLLER      |
///+----------------------+
// class TypesetController {
//   TypesetController(this.input);

//   final String input;
//   List<TypeValueModel> list = [];

//   List<TypeValueModel> manipulateString() {
//     const boldLiteral = '*';
//     const italicLiteral = '_';
//     const underlineLiteral = '#';
//     const monoLiteral = '`';
//     const strikeThroughLiteral = '~';
//     const linkLiteral = '§';

//     var typeOfString = StyleTypeEnum.plain;

//     final normalString = StringBuffer();
//     final boldString = StringBuffer();
//     final italicString = StringBuffer();
//     final underlineString = StringBuffer();
//     final strikeThroughString = StringBuffer();
//     final monoString = StringBuffer();
//     final linkString = StringBuffer();

//     for (var i = 0; i < input.length; i++) {
//       if (input[i] == boldLiteral && typeOfString == StyleTypeEnum.plain) {
//         typeOfString = StyleTypeEnum.bold;
//         continue;
//       }
//       if (input[i] == italicLiteral && typeOfString == StyleTypeEnum.plain) {
//         typeOfString = StyleTypeEnum.italic;
//         continue;
//       }
//       if (input[i] == underlineLiteral && typeOfString == StyleTypeEnum.plain
//) {
//         typeOfString = StyleTypeEnum.underline;
//         continue;
//       }
//       if (input[i] == monoLiteral && typeOfString == StyleTypeEnum.plain) {
//         typeOfString = StyleTypeEnum.monospace;
//         continue;
//       }
//       if (input[i] == strikeThroughLiteral &&
//           typeOfString == StyleTypeEnum.plain) {
//         typeOfString = StyleTypeEnum.strikethrough;
//         continue;
//       }
//       if (input[i] == linkLiteral && typeOfString == StyleTypeEnum.plain) {
//         typeOfString = StyleTypeEnum.link;
//         continue;
//       }

//       if (typeOfString == StyleTypeEnum.bold) {
//         if (input[i] == '/' &&
//             input[i + 1] == boldLiteral &&
//             i < input.length - 2) {
//           boldString.write(boldLiteral);
//           i++;
//           continue;
//         }
//         if (input[i] == boldLiteral) {
//           _addNormalStringToList(normalString);

//           typeOfString = StyleTypeEnum.plain;
//           list.add(
//             TypeValueModel(
//               StyleTypeEnum.bold,
//               boldString.toString().split('').join(),
//             ),
//           );

//           boldString.clear();
//           continue;
//         }
//         boldString.write(input[i]);
//         continue;
//       }

//       if (typeOfString == StyleTypeEnum.italic) {
//         if (input[i] == '/' &&
//             input[i + 1] == italicLiteral &&
//             i < input.length - 2) {
//           italicString.write(italicLiteral);
//           i++;
//           continue;
//         }
//         if (input[i] == italicLiteral) {
//           _addNormalStringToList(normalString);

//           typeOfString = StyleTypeEnum.plain;
//           list.add(
//             TypeValueModel(
//               StyleTypeEnum.italic,
//               italicString.toString().split('').join(),
//             ),
//           );

//           italicString.clear();
//           continue;
//         }
//         italicString.write(input[i]);
//         continue;
//       }

//       if (typeOfString == StyleTypeEnum.underline) {
//         if (input[i] == '/' &&
//             input[i + 1] == underlineLiteral &&
//             i < input.length - 2) {
//           underlineString.write(underlineLiteral);
//           i++;
//           continue;
//         }
//         if (input[i] == underlineLiteral) {
//           _addNormalStringToList(normalString);

//           typeOfString = StyleTypeEnum.plain;
//           list.add(
//             TypeValueModel(
//               StyleTypeEnum.underline,
//               underlineString.toString().split('').join(),
//             ),
//           );

//           underlineString.clear();
//           continue;
//         }
//         underlineString.write(input[i]);
//         continue;
//       }

//       if (typeOfString == StyleTypeEnum.monospace) {
//         if (input[i] == '/' &&
//             input[i + 1] == monoLiteral &&
//             i < input.length - 2) {
//           monoString.write(monoLiteral);
//           i++;
//           continue;
//         }
//         if (input[i] == monoLiteral) {
//           _addNormalStringToList(normalString);

//           typeOfString = StyleTypeEnum.monospace;
//           list.add(
//             TypeValueModel(
//               StyleTypeEnum.monospace,
//               monoString.toString().split('').join(),
//             ),
//           );

//           monoString.clear();
//           continue;
//         }
//         monoString.write(input[i]);
//         continue;
//       }

//       if (typeOfString == StyleTypeEnum.strikethrough) {
//         if (input[i] == '/' &&
//             input[i + 1] == strikeThroughLiteral &&
//             i < input.length - 2) {
//           strikeThroughString.write(strikeThroughLiteral);
//           i++;
//           continue;
//         }
//         if (input[i] == strikeThroughLiteral) {
//           _addNormalStringToList(normalString);

//           typeOfString = StyleTypeEnum.strikethrough;
//           list.add(
//             TypeValueModel(
//               StyleTypeEnum.strikethrough,
//               strikeThroughString.toString().split('').join(),
//             ),
//           );

//           strikeThroughString.clear();
//           continue;
//         }
//         strikeThroughString.write(input[i]);
//         continue;
//       }

//       if (typeOfString == StyleTypeEnum.link) {
//         if (input[i] == '/' &&
//             input[i + 1] == linkLiteral &&
//             i < input.length - 2) {
//           linkString.write(linkLiteral);
//           i++;
//           continue;
//         }
//         if (input[i] == linkLiteral) {
//           _addNormalStringToList(normalString);

//           typeOfString = StyleTypeEnum.link;
//           list.add(
//             TypeValueModel(
//               StyleTypeEnum.link,
//               linkString.toString().split('').join(),
//             ),
//           );

//           linkString.clear();
//           continue;
//         }
//         linkString.write(input[i]);
//         continue;
//       }

//       normalString.write(input[i]);
//     }
//     _addNormalStringToList(normalString);
//     return list;
//   }

//   void _addNormalStringToList(StringBuffer normalString) {
//     if (normalString.isNotEmpty) {
//       list.add(
//         TypeValueModel(
//           StyleTypeEnum.plain,
//           normalString.toString().split('').join(),
//         ),
//       );
//       normalString.clear();
//     }
//   }
// }

///+----------------------+
///|        PARSER        |
///+----------------------+
///
///  // static List<TextSpan> parser({
//   required String inputText,
//   TextStyle? linkStyle,
//   GestureRecognizer? recognizer,
//   TextStyle? monospaceStyle,
// }) {
//   final controller = TypesetController(inputText);
//   final spans = <TextSpan>[];

//   controller.manipulateString().forEach(
//     (text) {
//       double? fontSize;
//       var justText = text.value;
//       try {
//         final regex = RegExp(r'(.+?)<(\d+)>');
//         final match = regex.firstMatch(text.value);
//         if (match != null) {
//           justText = match.group(1)!;
//           fontSize = double.parse(match.group(2)!);
//         }
//       } catch (e) {
//         fontSize = null;
//       }
//       if (text.type == StyleTypeEnum.link) {
//         final linkData = text.value.split('|');
//         spans.add(
//           TextSpan(
//             text: fontSize != null
//                 ? justText
//                 : linkData.isNotEmpty
//                     ? linkData[0]
//                     : '',
//             style: linkStyle?.copyWith(
//                   fontSize: fontSize,
//                 ) ??
//                 TextStyle(
//                   color: Colors.blue,
//                   decoration: TextDecoration.underline,
//                   fontSize: fontSize,
//                 ),
//             recognizer: recognizer ??
//                 (TapGestureRecognizer()
//                   ..onTap = () async {
//                     if (await canLaunchUrl(
//                       Uri.parse(
//                         linkData.length == 2 ? linkData[1] : '',
//                       ),
//                     )) {
//                       await launchUrl(
//                         Uri.parse(
//                           linkData.length == 2 ? linkData[1] : '',
//                         ),
//                       );
//                     }
//                   }),
//           ),
//         );
//       } else {
//         final style = text.type == StyleTypeEnum.monospace
//             ? monospaceStyle ??
//                 GoogleFonts.sourceCodePro(
//                   textStyle: TextStyle(
//                     fontWeight: FontWeight.normal,
//                     fontSize: fontSize,
//                   ),
//                 )
//             : TextStyle(
//                 fontWeight:
//                     text.type == StyleTypeEnum.bold ? FontWeight.bold :
// null,
//                 fontStyle: text.type == StyleTypeEnum.italic
//                     ? FontStyle.italic
//                     : null,
//                 decoration: text.type == StyleTypeEnum.strikethrough
//                     ? TextDecoration.lineThrough
//                     : text.type == StyleTypeEnum.underline
//                         ? TextDecoration.underline
//                         : null,
//                 fontSize: fontSize,
//               );

//         spans.add(
//           TextSpan(
//             text: justText,
//             style: style,
//           ),
//         );
//       }
//     },
//   );
//   return spans;
// }
