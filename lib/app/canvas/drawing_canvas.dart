import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grappus_skribbl/app/canvas/cubit/game_cubit.dart';
import 'package:player_repository/player_repository.dart';

class DrawingCanvas extends StatefulWidget {
  const DrawingCanvas({super.key});

  @override
  State<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  // final points = <DrawingPoints>[];

  @override
  Widget build(BuildContext context) {
    final players =
        context.select((GameCubit cubit) => cubit.state.sessionState?.players);

    return Scaffold(
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            final renderBox = context.findRenderObject() as RenderBox?;
            final globalToLocal =
                renderBox?.globalToLocal(details.globalPosition);
            // points.add(
            //   DrawingPoints(
            //     points: globalToLocal,
            //     paint: paint,
            //   ),
            // );
            context.read<GameCubit>().addPoints(
                  DrawingPointsWrappper(
                    points: OffsetWrapper(
                      dx: globalToLocal!.dx,
                      dy: globalToLocal.dy,
                    ),
                    paint: PaintWrapper(isAntiAlias: true, strokeWidth: 2),
                  ),
                );
          });
        },
        onPanStart: (details) {
          setState(() {
            final renderBox = context.findRenderObject() as RenderBox?;
            final globalToLocal =
                renderBox?.globalToLocal(details.globalPosition);
            // points.add(
            //   DrawingPoints(
            //     points: globalToLocal,
            //     paint: paint,
            //   ),
            // );
            context.read<GameCubit>().addPoints(
                  DrawingPointsWrappper(
                    points: OffsetWrapper(
                      dx: globalToLocal!.dx,
                      dy: globalToLocal.dy,
                    ),
                    paint: PaintWrapper(isAntiAlias: true, strokeWidth: 2),
                  ),
                );
          });
        },
        onPanEnd: (details) {
          setState(() {
            context.read<GameCubit>().addPoints(
                  DrawingPointsWrappper(
                    points: null,
                    paint: null,
                  ),
                );
            // points.add(DrawingPoints(points: null, paint: null));
          });
        },
        child: RepaintBoundary(
          child: Stack(
            children: [
              CustomPaint(
                size: Size.infinite,
                painter: DrawingPainter(
                  pointsList: context
                      .select<GameCubit, List<DrawingPointsWrappper>>(
                    (cubit) => cubit.state.sessionState?.pointsList ?? [],
                  )
                      .map((wrapper) {
                    final points = wrapper.points != null
                        ? Offset(wrapper.points!.dx, wrapper.points!.dy)
                        : null;
                    final paint = wrapper.paint != null
                        ? (Paint()
                          ..isAntiAlias = wrapper.paint!.isAntiAlias
                          ..strokeWidth = wrapper.paint!.strokeWidth)
                        : null;
                    return DrawingPoints(points: points, paint: paint);
                  }).toList(),
                ),
              ),
              Flexible(
                child: ListView.builder(
                  itemBuilder: (context, index) => Text(
                    players![index].userId,
                    style: const TextStyle(color: Colors.black87),
                  ),
                  itemCount: players?.length,
                ),
              ),
            ],
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
    print('drawingPoints: $pointsList');
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

  @override
  String toString() {
    return 'DrawingPoints{paint: $paint, points: $points}';
  }
}
