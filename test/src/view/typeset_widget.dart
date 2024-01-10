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
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              if (title != null)
                TypeSet(
                  title!,
                  style: style,
                ),
              if (titleForExt != null)
                titleForExt!.typeset(
                  style: style,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
