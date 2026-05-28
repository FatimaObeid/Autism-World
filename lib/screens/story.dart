import 'package:flutter/material.dart';

class StoryTimePage extends StatefulWidget {
  const StoryTimePage({super.key});

  @override
  State<StoryTimePage> createState() => _StoryTimePageState();
}

class _StoryTimePageState extends State<StoryTimePage> {
  final PageController _controller = PageController();
  int _page = 0;

  final List<Map<String, String>> _story = [
    {"text": "The little star loves to glow at night.", "color": "0xFFE3F2FD"},
    {"text": "It says hello to the moon and the owls.", "color": "0xFFF3E5F5"},
    {"text": "When the sun comes up, the star rests.", "color": "0xFFFFF3E0"},
    {"text": "Goodnight little star, see you tomorrow!", "color": "0xFFE8F5E9"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(int.parse(_story[_page]["color"]!)),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (i) => setState(() => _page = i),
              itemCount: _story.length,
              itemBuilder: (context, i) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.auto_awesome,
                        size: 100,
                        color: Colors.amber,
                      ),
                      const SizedBox(height: 40),
                      Text(
                        _story[i]["text"]!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _story.length,
                (index) => Container(
                  margin: const EdgeInsets.all(5),
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _page == index ? Colors.black87 : Colors.black12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
