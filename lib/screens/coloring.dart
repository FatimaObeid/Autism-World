import 'package:flutter/material.dart';
import 'dart:ui' as ui; // Added for PointMode

class ColoringPage extends StatefulWidget {
  const ColoringPage({super.key});

  @override
  State<ColoringPage> createState() => _KidsColoringPageState();
}

class _KidsColoringPageState extends State<ColoringPage> {
  List<DrawingPoint?> points = [];
  Color selectedColor = Colors.black;
  double strokeWidth = 5.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Coloring Fun",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: const Color.fromARGB(255, 53, 71, 86).withOpacity(0.1),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildColorCircle(Colors.black),
                  _buildColorCircle(Colors.red),
                  _buildColorCircle(Colors.green),
                  _buildColorCircle(Colors.blue),
                  _buildColorCircle(Colors.orange),
                  _buildColorCircle(Colors.purple),
                  _buildColorCircle(Colors.pink),
                  _buildColorCircle(Colors.cyan),
                  _buildColorCircle(Colors.brown),
                  _buildColorCircle(Colors.yellow),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              children: [
                Icon(
                  Icons.brush,
                  size: 20,
                  color: selectedColor.withOpacity(0.6),
                ),
                Expanded(
                  child: Slider(
                    value: strokeWidth,
                    min: 1.0,
                    max: 20.0,
                    activeColor: selectedColor,
                    onChanged: (value) {
                      setState(() {
                        strokeWidth = value;
                      });
                    },
                  ),
                ),
                Icon(Icons.brush, size: 35, color: selectedColor),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: GestureDetector(
                    onPanStart: (details) {
                      setState(() {
                        points.add(
                          DrawingPoint(
                            offset: details.localPosition,
                            paint: Paint()
                              ..color = selectedColor
                              ..strokeWidth = strokeWidth
                              ..strokeCap = StrokeCap.round,
                          ),
                        );
                      });
                    },
                    onPanUpdate: (details) {
                      setState(() {
                        points.add(
                          DrawingPoint(
                            offset: details.localPosition,
                            paint: Paint()
                              ..color = selectedColor
                              ..strokeWidth = strokeWidth
                              ..strokeCap = StrokeCap.round,
                          ),
                        );
                      });
                    },
                    onPanEnd: (_) {
                      setState(() {
                        points.add(null);
                      });
                    },
                    child: CustomPaint(
                      painter: DrawingPainter(points: points),
                      size: Size.infinite,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 🧹 BOTTOM CONTROLS: CLEAR
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  points.clear();
                });
              },
              icon: const Icon(Icons.delete_sweep),
              label: const Text("Clear Canvas", style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorCircle(Color color) {
    bool isSelected = selectedColor == color;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: isSelected ? 45 : 35,
        height: isSelected ? 45 : 35,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.white : Colors.black12,
            width: isSelected ? 3 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
      ),
    );
  }
}

class DrawingPoint {
  final Offset offset;
  final Paint paint;

  DrawingPoint({required this.offset, required this.paint});
}

class DrawingPainter extends CustomPainter {
  final List<DrawingPoint?> points;

  DrawingPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        // Draw standard line segment
        canvas.drawLine(
          points[i]!.offset,
          points[i + 1]!.offset,
          points[i]!.paint,
        );
      } else if (points[i] != null && points[i + 1] == null) {
        canvas.drawPoints(ui.PointMode.points, [
          points[i]!.offset,
        ], points[i]!.paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant DrawingPainter oldDelegate) => true;
}
