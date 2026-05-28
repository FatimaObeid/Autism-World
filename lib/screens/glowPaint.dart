import 'dart:ui';

import 'package:flutter/material.dart';

class GlowPaint extends StatefulWidget {
  const GlowPaint({super.key});

  @override
  State<GlowPaint> createState() => _GlowPaintState();
}

class _GlowPaintState extends State<GlowPaint>
    with SingleTickerProviderStateMixin {
  List<DrawingPoint?> points = [];
  Color selectedColor = Colors.cyanAccent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          "Zen Glow Paint",
          style: TextStyle(color: Colors.white70),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white70),
            onPressed: () => setState(() => points.clear()),
          ),
        ],
      ),
      body: Stack(
        children: [
          GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                RenderBox renderBox = context.findRenderObject() as RenderBox;
                points.add(
                  DrawingPoint(
                    offset: renderBox.globalToLocal(details.globalPosition),
                    paint: Paint()
                      ..color = selectedColor
                      ..strokeCap = StrokeCap.round
                      ..strokeWidth = 10.0
                      ..maskFilter = const MaskFilter.blur(
                        BlurStyle.normal,
                        5,
                      ), // THE GLOW EFFECT
                  ),
                );
              });
            },
            onPanEnd: (details) => setState(() => points.add(null)),
            child: CustomPaint(
              size: Size.infinite,
              painter: GlowPainter(pointsList: points),
            ),
          ),

          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _colorPicker(Colors.cyanAccent),
                _colorPicker(Colors.pinkAccent),
                _colorPicker(Colors.greenAccent),
                _colorPicker(Colors.orangeAccent),
                _colorPicker(Colors.purpleAccent),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _colorPicker(Color color) {
    return GestureDetector(
      onTap: () => setState(() => selectedColor = color),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selectedColor == color ? Colors.white : Colors.transparent,
            width: 3,
          ),
          boxShadow: [BoxShadow(color: color.withOpacity(0.5), blurRadius: 10)],
        ),
      ),
    );
  }
}

class DrawingPoint {
  Offset offset;
  Paint paint;
  DrawingPoint({required this.offset, required this.paint});
}

class GlowPainter extends CustomPainter {
  final List<DrawingPoint?> pointsList;
  GlowPainter({required this.pointsList});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < pointsList.length - 1; i++) {
      if (pointsList[i] != null && pointsList[i + 1] != null) {
        // Draw the glow layer
        canvas.drawLine(
          pointsList[i]!.offset,
          pointsList[i + 1]!.offset,
          pointsList[i]!.paint,
        );
        // Draw a bright white core for a real neon look
        canvas.drawLine(
          pointsList[i]!.offset,
          pointsList[i + 1]!.offset,
          Paint()
            ..color = Colors.white.withOpacity(0.8)
            ..strokeCap = StrokeCap.round
            ..strokeWidth = 3.0,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
