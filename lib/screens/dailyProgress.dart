import 'package:flutter/material.dart';
import 'package:autism_world/l10n/app_localizations.dart';

class DailyProgress extends StatefulWidget {
  const DailyProgress({super.key});

  @override
  State<DailyProgress> createState() => _DailyProgressState();
}

class _DailyProgressState extends State<DailyProgress> {
  static const Color accentOrange = Color(0xFFFF9800);

  double _moodLevel = 3.0;
  bool _tookMedicine = false;
  bool _socialInteraction = false;
  final TextEditingController _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dailyProgressTitle),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.howWasDay,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle(l10n.currentMood),
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
              activeColor: accentOrange,
              onChanged: (value) => setState(() => _moodLevel = value),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle(l10n.dailyGoals),
            CheckboxListTile(
              title: Text(l10n.sensoryPlay),
              value: _tookMedicine,
              onChanged: (val) => setState(() => _tookMedicine = val!),
            ),
            CheckboxListTile(
              title: Text(l10n.socialInteraction),
              value: _socialInteraction,
              onChanged: (val) => setState(() => _socialInteraction = val!),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle(l10n.parentNotes),
            TextField(
              controller: _notesController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: l10n.notesHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(l10n.progressSaved)));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentOrange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(l10n.saveEntry),
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
