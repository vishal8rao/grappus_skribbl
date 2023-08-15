import 'dart:ui';

import 'package:flutter/material.dart';

class DrawingCanvas extends StatefulWidget {
  const DrawingCanvas({super.key});

  @override
  State<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  final points = <DrawingPoints>[];

  @override
  Widget build(BuildContext context) {
    final paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 2;

    return Scaffold(
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            final renderBox = context.findRenderObject() as RenderBox?;
            final globalToLocal =
                renderBox?.globalToLocal(details.globalPosition);
            points.add(
              DrawingPoints(
                points: globalToLocal,
                paint: paint,
              ),
            );
          });
        },
        onPanStart: (details) {
          setState(() {
            final renderBox = context.findRenderObject() as RenderBox?;
            final globalToLocal =
                renderBox?.globalToLocal(details.globalPosition);
            points.add(
              DrawingPoints(
                points: globalToLocal,
                paint: paint,
              ),
            );
          });
        },
        onPanEnd: (details) {
          setState(() {
            points.add(DrawingPoints(points: null, paint: null));
          });
        },
        child: RepaintBoundary(
          child: CustomPaint(
            size: Size.infinite,
            painter: DrawingPainter(
              pointsList: points,
            ),
          ),
        ),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  DrawingPainter({
    required this.pointsList,
  });

  List<DrawingPoints> pointsList;
  List<Offset> offsetPoints = [];

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < pointsList.length - 1; i++) {
      final currentValue = pointsList[i];
      final nextValue = pointsList[i + 1];
      if (currentValue.isNotNull && nextValue.isNotNull) {
        canvas.drawLine(
          currentValue.points!,
          nextValue.points!,
          currentValue.paint!,
        );
      } else if (currentValue.isNotNull && nextValue.isNull) {
        offsetPoints
          ..clear()
          ..add(currentValue.points!)
          ..add(
            Offset(
              currentValue.points!.dx + 0.1,
              currentValue.points!.dy + 0.1,
            ),
          );
        canvas.drawPoints(
          PointMode.points,
          offsetPoints,
          currentValue.paint!,
        );
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}

class DrawingPoints {
  DrawingPoints({
    required this.points,
    required this.paint,
  });

  final Paint? paint;
  final Offset? points;

  bool get isNotNull => points != null && paint != null;

  bool get isNull => points == null || paint == null;
}
