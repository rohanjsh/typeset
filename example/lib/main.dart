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
        title: const Text('TypeSet example'),
      ),
      body: Center(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 22.0,
                vertical: 22,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '''
Make text formatting backend driven (if needed) with one widget!!

Whatsapp like formatting with some addons!!
(input looks like this)

→ Hello, *World!*          <Bold>
→ Hello, _World!_          <Italic>
→ Hello, ~World!~         <Strikethrough>
→ Hello, //World!//         <Underline>
→ Hello, `World!`          <Monospace>
→ [google.com|https://google.com]   <Link>
''',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TypeSet(
                    inputText: 'bold:\n→ *Bold* *Text*',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TypeSet(
                    inputText: 'italic:\n→ _Italic_ _Text_',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TypeSet(
                    inputText: 'underline:\n→ //Underline// //Text//',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TypeSet(
                    inputText: 'strikethrough:\n→ ~Strikethrough~ ~Text~',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TypeSet(
                    inputText: 'monospace:\n→ `monospace` `text`',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TypeSet(
                    inputText: 'link:\n→ [google.com|https://google.com]',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
