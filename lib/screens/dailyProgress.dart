import 'package:flutter/material.dart';

class DailyProgress extends StatefulWidget {
  const DailyProgress({super.key});

  @override
  State<DailyProgress> createState() => _DailyProgressState();
}

class _DailyProgressState extends State<DailyProgress> {
  double _moodLevel = 3.0; // 1 to 5
  bool _tookMedicine = false;
  bool _socialInteraction = false;
  final TextEditingController _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daily Progress"),
        backgroundColor: Colors.orangeAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "How was your child's day?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // 1. MOOD SLIDER
            _buildSectionTitle("Current Mood"),
            Center(
              child: Text(
                _getMoodEmoji(_moodLevel),
                style: const TextStyle(fontSize: 50),
              ),
            ),
            Slider(
              value: _moodLevel,
              min: 1,
              max: 5,
              divisions: 4,
              activeColor: Colors.orangeAccent,
              onChanged: (value) => setState(() => _moodLevel = value),
            ),

            const SizedBox(height: 20),

            // 2. DAILY CHECKLIST
            _buildSectionTitle("Daily Goals"),
            CheckboxListTile(
              title: const Text("Completed Sensory Play"),
              value: _tookMedicine,
              onChanged: (val) => setState(() => _tookMedicine = val!),
            ),
            CheckboxListTile(
              title: const Text("Social Interaction (Playdate/Park)"),
              value: _socialInteraction,
              onChanged: (val) => setState(() => _socialInteraction = val!),
            ),

            const SizedBox(height: 20),

            // 3. NOTES
            _buildSectionTitle("Parent Notes"),
            TextField(
              controller: _notesController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Enter any specific triggers or achievements...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // SAVE BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Progress Saved!")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                ),
                child: const Text(
                  "Save Entry",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.blueGrey,
        ),
      ),
    );
  }

  String _getMoodEmoji(double level) {
    if (level <= 1) return "😫";
    if (level <= 2) return "🙁";
    if (level <= 3) return "😐";
    if (level <= 4) return "🙂";
    return "🌟";
  }
}
