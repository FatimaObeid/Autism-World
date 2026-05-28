import 'package:autism_world/screens/kids/coloring.dart';
import 'package:autism_world/screens/kids/feeling.dart';
import 'package:autism_world/screens/kids/game.dart';
import 'package:autism_world/screens/kids/glowPaint.dart';
import 'package:autism_world/screens/kids/matching.dart';
import 'package:autism_world/screens/kids/music.dart';
import 'package:autism_world/screens/kids/story.dart';
import 'package:flutter/material.dart';

class KidsZonePage extends StatelessWidget {
  const KidsZonePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Hello Kid 👋",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              "Choose a fun activity",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 25),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [
                  _activityCard(
                    title: "Coloring",
                    icon: Icons.brush,
                    color: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ColoringPage(),
                        ),
                      );
                    },
                  ),
                  _activityCard(
                    title: "Rainbow Match",
                    icon: Icons.extension,
                    color: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MatchingGamePage(),
                        ),
                      );
                    },
                  ),
                  _activityCard(
                    title: "Calm Music",
                    icon: Icons.music_note,
                    color: Colors.blue,
                    onTap: () {},
                  ),
                  _activityCard(
                    title: "Story Time",
                    icon: Icons.menu_book,
                    color: Colors.purple,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StoryTimePage(),
                        ),
                      );
                    },
                  ),
                  _activityCard(
                    title: " Glow Paint",
                    icon: Icons.brush_outlined,
                    color: Colors.purple,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GlowPaint(),
                        ),
                      );
                    },
                  ),

                  _activityCard(
                    title: "Mood Sort",
                    icon: Icons.mood,
                    color: Colors.purple,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EmotionSortPage(),
                        ),
                      );
                    },
                  ),

                  _activityCard(
                    title: " Matching Game",
                    icon: Icons.extension,
                    color: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ShadowMatchPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🧩 Activity Card Widget
  Widget _activityCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
