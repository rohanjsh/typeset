import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import 'package:flutter/material.dart';
import 'package:typeset/typeset.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      color: Color(0xFF2196F3),
      title: 'TypeSet Demo',
      home: TypeSetExample(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TypeSetExample extends StatelessWidget {
  const TypeSetExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TypeSet Demo'),
      ),
      body: Center(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const Text(
                    'Usage',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    '''
Bold
→ Hello, *World!* 

Italic
→ Hello, _World!_

Strikethrough
→ Hello, ~World!~ 

Underline
→ Hello, #World!#

Monospace
→ Hello, `World!` 

Link
→ §google.com|https://google.com§
''',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),

                  const Divider(),
                  const Text(
                    'Samples',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const Divider(),

                  const SizedBox(
                    height: 12,
                  ),
                  TypeSet(
                    '→ *TypeSet* _can_ #style# ~everything~ `you need` §with|https://rohanjsh.dev/§ _dynamic<18>_ _font<28>_ _size<25>_',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    linkRecognizerBuilder: (linkText, url) {
                      return TapGestureRecognizer()
                        ..onTap = () {
                          debugPrint('URL: $url and Text: $linkText');
                        };
                    },
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const Divider(),
                  const Text(
                    'Supported Stylings',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const Divider(),

                  const SizedBox(
                    height: 12,
                  ),
                  const TypeSet(
                    'Bold:\n→ Hello<20> world',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const TypeSet(
                    'Italic:\n→ _Italic Text_ ',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const TypeSet(
                    'Underline:\n→ #Underline Text#',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const TypeSet(
                    'Strikethrough:\n→ ~Strikethrough Text~',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const TypeSet(
                    'Monospace:\n→ `monospace text`',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  //customized link textstyle and recognizer (tap recognizer)
                  TypeSet(
                    'Link:\n→ §google.com|https://google.com§',
                    style: const TextStyle(
                      fontSize: 24,
                    ),
                    linkRecognizerBuilder: (linkText, url) {
                      return TapGestureRecognizer()
                        ..onTap = () {
                          debugPrint('URL: $url and Text: $linkText');
                        };
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
