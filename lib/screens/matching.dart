import 'package:flutter/material.dart';

class ShadowMatchPage extends StatefulWidget {
  const ShadowMatchPage({super.key});

  @override
  State<ShadowMatchPage> createState() => _ShadowMatchPageState();
}

class _ShadowMatchPageState extends State<ShadowMatchPage> {
  final Map<String, IconData> _items = {
    "Apple": Icons.apple,
    "Bus": Icons.directions_bus_rounded,
    "Rocket": Icons.rocket_launch_rounded,
    "Cat": Icons.pets_rounded,
  };

  final Map<String, bool> _score = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Shadow Match"), centerTitle: true),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Colorful Draggable Items
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _items.keys
                .map(
                  (key) => Draggable<String>(
                    data: key,
                    feedback: Icon(_items[key], size: 80, color: Colors.orange),
                    childWhenDragging: Icon(
                      _items[key],
                      size: 60,
                      color: Colors.grey.shade200,
                    ),
                    child: _score[key] == true
                        ? const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 60,
                          )
                        : Icon(_items[key], size: 60, color: Colors.orange),
                  ),
                )
                .toList(),
          ),

          // Black Shadow Targets
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: (_items.keys.toList()..shuffle())
                .map(
                  (key) => DragTarget<String>(
                    onAcceptWithDetails: (details) {
                      if (details.data == key) {
                        setState(() => _score[key] = true);
                      }
                    },
                    builder: (context, candidateData, rejectedData) =>
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: _score[key] == true
                                ? Colors.green.withOpacity(0.1)
                                : Colors.black12,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            _items[key],
                            size: 60,
                            color: _score[key] == true
                                ? Colors.green
                                : Colors.black,
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
}
