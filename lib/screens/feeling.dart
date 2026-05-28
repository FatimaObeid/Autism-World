import 'package:flutter/material.dart';

class EmotionSortPage extends StatefulWidget {
  const EmotionSortPage({super.key});

  @override
  State<EmotionSortPage> createState() => _EmotionSortPageState();
}

class _EmotionSortPageState extends State<EmotionSortPage> {
  // List of emotions to sort
  final List<Map<String, dynamic>> _emotions = [
    {"emoji": "😊", "label": "Happy", "color": Colors.yellow.shade600},
    {"emoji": "😢", "label": "Sad", "color": Colors.blue.shade400},
    {"emoji": "😡", "label": "Angry", "color": Colors.red.shade400},
    {"emoji": "😴", "label": "Tired", "color": Colors.purple.shade300},
  ];

  String _feedback = "How does the face feel?";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFCF0),
      appBar: AppBar(title: const Text("Feeling Sort"), centerTitle: true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            _feedback,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          // The Draggable Emoji
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _emotions
                .map(
                  (e) => Draggable<String>(
                    data: e['label'],
                    feedback: _buildEmojiCircle(e['emoji'], e['color'], true),
                    childWhenDragging: _buildEmojiCircle(
                      e['emoji'],
                      Colors.grey.shade300,
                      false,
                    ),
                    child: _buildEmojiCircle(e['emoji'], e['color'], false),
                  ),
                )
                .toList(),
          ),

          // The Targets (Buckets)
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: _emotions
                .map(
                  (e) => DragTarget<String>(
                    onAcceptWithDetails: (details) {
                      setState(() {
                        if (details.data == e['label']) {
                          _feedback = "Yes! That is ${e['label']}!";
                        } else {
                          _feedback = "Try again! Look at the face.";
                        }
                      });
                    },
                    builder: (context, candidateData, rejectedData) =>
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: e['color'], width: 4),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inventory_2_rounded,
                                color: e['color'],
                                size: 40,
                              ),
                              Text(
                                e['label'],
                                style: TextStyle(
                                  color: e['color'],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmojiCircle(String emoji, Color color, bool isDragging) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(10),
        width: 80,
        height: 80,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Center(child: Text(emoji, style: const TextStyle(fontSize: 40))),
      ),
    );
  }
}
