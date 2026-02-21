import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import 'package:flutter/material.dart';
import 'package:typeset/typeset.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: const Color(0xFFF5F7FB),
      title: 'TypeSet Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3F6DF6),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const TypeSetExample(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TypeSetExample extends StatefulWidget {
  const TypeSetExample({super.key});

  @override
  State<TypeSetExample> createState() => _TypeSetExampleState();
}

class _TypeSetExampleState extends State<TypeSetExample> {
  late final TypeSetEditingController _controller;
  late final TypeSetConfig _customConfig;
  static const _softSurfaceColor = Color(0xFFF7F9FE);
  static const _borderColor = Color(0xFFDDE4F2);

  @override
  void initState() {
    super.initState();
    _customConfig = TypeSetConfig(
      style: const TypeSetStyle(
        boldStyle: TextStyle(fontWeight: FontWeight.w900),
        italicStyle: TextStyle(
          fontStyle: FontStyle.italic,
          color: Color(0xFF6A1B9A),
        ),
        underlineStyle: TextStyle(decorationThickness: 3),
        monospaceStyle: TextStyle(
          fontFamily: 'Courier',
          backgroundColor: Color(0xFFEFF3FF),
        ),
        linkStyle: TextStyle(
          color: Color(0xFF0B5FFF),
          decoration: TextDecoration.underline,
        ),
        markerColor: Color(0xFF8D8D8D),
      ),
      autoLinkConfig: TypeSetAutoLinkConfig(
        allowedSchemes: const {'https'},
        allowedDomains: RegExp(r'^flutter\.dev$'),
        linkRecognizerBuilder: (linkText, url) => TapGestureRecognizer()
          ..onTap = () => debugPrint('$linkText -> $url'),
      ),
    );

    _controller = TypeSetEditingController(
      text:
          'Try *bold*, _italic_, __underline__, ~strikethrough~, and https://flutter.dev',
      config: _customConfig,
    );

    _controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF9FBFF), Color(0xFFF2F5FC)],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const _HeaderBlock(),
              const SizedBox(height: 16),
              const _SectionCard(
                title: 'Simple usage',
                subtitle: 'Use TypeSet like a regular Text widget.',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CodeBlock(
                      code:
                          "const TypeSet('Hello *TypeSet*! Keep it _simple_.');",
                    ),
                    SizedBox(height: 10),
                    TypeSet(
                      'Hello *TypeSet*! Keep it _simple_, __readable__, and ~clean~.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              _SectionCard(
                title: 'Live editing',
                subtitle: 'Edit formatted text and preview it below.',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _controller,
                      minLines: 2,
                      maxLines: 5,
                      style: const TextStyle(height: 1.35),
                      decoration: InputDecoration(
                        hintText: 'Write with *bold* and __underline__',
                        filled: true,
                        fillColor: _softSurfaceColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: _borderColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: _borderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Color(0xFF7A93F5),
                            width: 1.4,
                          ),
                        ),
                      ),
                      contextMenuBuilder: (context, editableTextState) {
                        return AdaptiveTextSelectionToolbar.buttonItems(
                          anchors: editableTextState.contextMenuAnchors,
                          buttonItems: [
                            ...getTypesetContextMenus(
                              editableTextState: editableTextState,
                            ),
                            ...editableTextState.contextMenuButtonItems,
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Rendered preview',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _softSurfaceColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _borderColor),
                      ),
                      child: TypeSet(
                        _controller.text,
                        style: const TextStyle(fontSize: 16),
                        config: _customConfig,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              _SectionCard(
                title: 'Custom config',
                subtitle: 'Customize styles and link rules.',
                child: TypeSet(
                  'This card uses custom styles and allows links only from https://flutter.dev',
                  style: const TextStyle(fontSize: 16),
                  config: _customConfig,
                ),
              ),
              const SizedBox(height: 14),
              const _SyntaxCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderBlock extends StatelessWidget {
  const _HeaderBlock();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD8E1F1)),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFFFF), Color(0xFFF4F7FF)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TypeSet',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A2A52),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'A simple demo for text formatting in Flutter',
            style: TextStyle(color: Color(0xFF5D6F98)),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFDDE4F2)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: Color(0xFF64769D)),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _SyntaxCard extends StatelessWidget {
  const _SyntaxCard();

  @override
  Widget build(BuildContext context) {
    return const _SectionCard(
      title: 'Syntax reference',
      subtitle: 'Supported formatting markers.',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _Pill(text: '*bold*'),
          _Pill(text: '_italic_'),
          _Pill(text: '__underline__'),
          _Pill(text: '~strikethrough~'),
          _Pill(text: '`monospace`'),
          _Pill(text: 'https://flutter.dev'),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF0FF),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFCEDAF8)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF3557A8),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  const _CodeBlock({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDDE4F2)),
      ),
      child: SelectableText(
        code,
        style: const TextStyle(
          fontFamily: 'Courier',
          fontSize: 13,
          color: Color(0xFF2B3D67),
          height: 1.4,
        ),
      ),
    );
  }
}
