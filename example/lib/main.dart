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
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 22,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(),
                  Text(
                    'Usage',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
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

                  Divider(),
                  Text(
                    'Samples',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Divider(),

                  SizedBox(
                    height: 12,
                  ),
                  TypeSet(
                    inputText:
                        '→ *TypeSet* _can_ #style# ~everything~ `you need` §with|https://rohanjsh.dev/§ _dynamic<18>_ _font<28>_ _size<25>_',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Divider(),
                  Text(
                    'Supported Stylings',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Divider(),

                  SizedBox(
                    height: 12,
                  ),
                  TypeSet(
                    inputText: 'Bold:\n→ *Bold Text*',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TypeSet(
                    inputText: 'Italic:\n→ _Italic Text_ ',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TypeSet(
                    inputText: 'Underline:\n→ #Underline Text#',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TypeSet(
                    inputText: 'Strikethrough:\n→ ~Strikethrough Text~',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TypeSet(
                    inputText: 'Monospace:\n→ `monospace text`',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  //customized link textstyle and recognizer (tap recognizer)
                  TypeSet(
                    inputText: 'Link:\n→ §google.com|https://google.com§',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
