import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import 'package:flutter/material.dart';
import 'package:typeset/typeset.dart';

class TypeSetTest extends StatelessWidget {
  const TypeSetTest({
    super.key,
    this.title,
    this.style,
    this.titleForExt,
  });

  final String? title;
  final TextStyle? style;
  final String? titleForExt;

  @override
  Widget build(BuildContext context) {
    final config = TypeSetConfig(
      autoLinkConfig: TypeSetAutoLinkConfig(
        linkRecognizerBuilder: (linkText, url) => TapGestureRecognizer()
          ..onTap = () {
            debugPrint('Link tapped');
          },
      ),
    );

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              if (title != null)
                TypeSet(
                  title!,
                  style: style,
                  config: config,
                ),
              if (titleForExt != null)
                titleForExt!.typeset(
                  style: style,
                  config: config,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
