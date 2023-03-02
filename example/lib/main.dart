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
      home: TypeSetDemo(),
    );
  }
}

class TypeSetDemo extends StatelessWidget {
  const TypeSetDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TypeSet Demo'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 22,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 22.0,
              ),
              child: Text(
                '''
A simple widget to display text with whatsapp like formatting
Text style that will support bold, italic and underline text coming from the server
The implementation will be same as we see on WhatsApp.

i.e.
1. Bold Text will be wrapped in *asterisk*
2. Italic Text will be wrapped in _underscore_
3. Underline Text will be wrapped in ~tilde~

Example:
Hello, *World!*
Hello, _World!_
Hello, ~World!~
''',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
            const Divider(
              thickness: 1.4,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 22.0,
                vertical: 22,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('DEMO:'),
                  SizedBox(
                    height: 20,
                  ),
                  TypeSetDisplay(
                    text: "'Hello, World!' will be:",
                    formattedText: 'Hello, World!',
                  ),
                  //describe the above text as normal
                  SizedBox(
                    height: 20,
                  ),
                  TypeSetDisplay(
                    text: "'Hello, *World!*' will be:",
                    formattedText: 'Hello, *World!*',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TypeSetDisplay(
                    text: "'Hello, _World!_' will be:",
                    formattedText: 'Hello, _World!_',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TypeSetDisplay(
                    text: "'Hello, ~World!~' will be:",
                    formattedText: 'Hello, ~World!~',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TypeSetDisplay(
                    text: "Make asterisk bold -> %%9*********7%%",
                    formattedText: 'Make asterisk bold -> %%9*********7%%',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(':::Improvements coming soon:::'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TypeSetDisplay extends StatelessWidget {
  const TypeSetDisplay({
    Key? key,
    required this.text,
    required this.formattedText,
  }) : super(key: key);

  final String text;
  final String formattedText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
        ),

        //TypeSet accepts text and style as parameters
        //style is optional
        TypeSet(
          inputText: formattedText,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
