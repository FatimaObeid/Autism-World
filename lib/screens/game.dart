import 'package:flutter/material.dart';
import 'dart:async';

class MatchingGamePage extends StatefulWidget {
  const MatchingGamePage({super.key});

  @override
  State<MatchingGamePage> createState() => _MatchingGamePageState();
}

class _MatchingGamePageState extends State<MatchingGamePage> {
  final List<IconData> _icons = [
    Icons.icecream_rounded,
    Icons.icecream_rounded,
    Icons.rocket_launch_rounded,
    Icons.rocket_launch_rounded,
    Icons.pets_rounded,
    Icons.pets_rounded,
    Icons.local_pizza_rounded,
    Icons.local_pizza_rounded,
    Icons.face_retouching_natural_rounded,
    Icons.face_retouching_natural_rounded,
    Icons.directions_bike_rounded,
    Icons.directions_bike_rounded,
  ];

  final List<Color> _pairColors = [
    Colors.pink.shade300,
    Colors.pink.shade300,
    Colors.purple.shade300,
    Colors.purple.shade300,
    Colors.orange.shade300,
    Colors.orange.shade300,
    Colors.green.shade300,
    Colors.green.shade300,
    Colors.blue.shade300,
    Colors.blue.shade300,
    Colors.amber.shade400,
    Colors.amber.shade400,
  ];

  List<IconData> _shuffledIcons = [];
  List<Color> _shuffledColors = [];
  List<bool> _isFlipped = [];
  List<bool> _isMatched = [];

  int? _firstIndex;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    List<int> indices = Iterable<int>.generate(_icons.length).toList()
      ..shuffle();
    setState(() {
      _shuffledIcons = indices.map((i) => _icons[i]).toList();
      _shuffledColors = indices.map((i) => _pairColors[i]).toList();
      _isFlipped = List.filled(_icons.length, false);
      _isMatched = List.filled(_icons.length, false);
      _firstIndex = null;
      _isProcessing = false;
    });
  }

  void _handleTap(int index) {
    if (_isProcessing || _isFlipped[index] || _isMatched[index]) return;

    setState(() => _isFlipped[index] = true);

    if (_firstIndex == null) {
      _firstIndex = index;
    } else {
      _isProcessing = true;
      if (_shuffledIcons[_firstIndex!] == _shuffledIcons[index]) {
        setState(() {
          _isMatched[_firstIndex!] = true;
          _isMatched[index] = true;
          _firstIndex = null;
          _isProcessing = false;
        });
        if (_isMatched.every((e) => e)) _showWin();
      } else {
        Timer(const Duration(milliseconds: 800), () {
          if (mounted) {
            setState(() {
              _isFlipped[_firstIndex!] = false;
              _isFlipped[index] = false;
              _firstIndex = null;
              _isProcessing = false;
            });
          }
        });
      }
    }
  }

  void _showWin() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        title: const Text("🌈 Perfect!", textAlign: TextAlign.center),
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
                _resetGame();
              },
              child: const Text("Play Again", style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_shuffledIcons.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDE7),
      appBar: AppBar(
        title: const Text(
          "Rainbow Match",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
              ),
              itemCount: _shuffledIcons.length,
              itemBuilder: (context, index) {
                bool isShow = _isFlipped[index] || _isMatched[index];
                return GestureDetector(
                  onTap: () => _handleTap(index),
                  child: AnimatedContainer(
                    curve: Curves.easeOutBack,
                    duration: const Duration(milliseconds: 500),
                    decoration: BoxDecoration(
                      color: isShow ? _shuffledColors[index] : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: isShow
                          ? Icon(
                              _shuffledIcons[index],
                              size: 40,
                              color: Colors.white,
                            )
                          : Icon(
                              Icons.star_rounded,
                              color: Colors.amber.shade200,
                              size: 30,
                            ),
                    ),
                  ),
                );
              },
            ),
          ),

          // 🔄 THE RESTART BUTTON
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: ElevatedButton.icon(
              onPressed: _resetGame,
              icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              label: const Text(
                "Restart Game",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
