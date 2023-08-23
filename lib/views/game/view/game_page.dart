import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_repository/game_repository.dart';
import 'package:grappus_skribbl/views/views.dart';
import 'package:player_repository/player_repository.dart';

class GamePage extends StatelessWidget {
  const GamePage({required this.url, super.key});

  final String url;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameCubit(
        gameRepository: GameRepository(
          uri: Uri.parse(url),
        ),
      )..connect(),
      child: _GamePage(),
    );
  }
}

class _GamePage extends StatelessWidget {
  _GamePage();

  late List<DrawingPoints> pointsList = <DrawingPoints>[];
  late String currentPlayerId = '';
  late List<Player> players = <Player>[];
  late String drawingPlayerId = '';

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<GameCubit>();
    final roomState = context.select((GameCubit cubit) => cubit.state.room);

    if (roomState != null) {
      players = roomState.players;
      drawingPlayerId = roomState.currentPlayerDrawingId;

      if (currentPlayerId.isEmpty) {
        currentPlayerId = roomState.currentPlayerId;
      }

      final newDrawingPoint = roomState.points.toDrawingPoints();
      pointsList.add(newDrawingPoint);
    }

    return Scaffold(
      body: GestureDetector(
        onPanUpdate: (details) => _handlePanUpdate(
          context,
          details,
          cubit,
        ),
        onPanStart: (details) => _handlePanStart(
          context,
          details,
          cubit,
        ),
        onPanEnd: (_) => _handlePanEnd(
          cubit,
        ),
        child: RepaintBoundary(
          child: Stack(
            children: [
              CustomPaint(
                size: Size.infinite,
                painter: DrawingPainter(pointsList: pointsList),
              ),
              Flexible(
                child: ListView.builder(
                  itemBuilder: (context, index) => Text(
                    players[index].userId,
                    style: const TextStyle(color: Colors.black87),
                  ),
                  itemCount: players.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handlePanUpdate(
    BuildContext context,
    DragUpdateDetails details,
    GameCubit cubit,
  ) {
    final renderBox = context.findRenderObject() as RenderBox?;
    final globalToLocal = renderBox?.globalToLocal(details.globalPosition);
    cubit.addPoints(
      DrawingPointsWrapper(
        points: OffsetWrapper(dx: globalToLocal!.dx, dy: globalToLocal.dy),
        paint: const PaintWrapper(isAntiAlias: true, strokeWidth: 2),
      ),
    );
  }

  void _handlePanStart(
    BuildContext context,
    DragStartDetails details,
    GameCubit cubit,
  ) {
    final renderBox = context.findRenderObject() as RenderBox?;
    final globalToLocal = renderBox?.globalToLocal(details.globalPosition);
    cubit.addPoints(
      DrawingPointsWrapper(
        points: OffsetWrapper(dx: globalToLocal!.dx, dy: globalToLocal.dy),
        paint: const PaintWrapper(isAntiAlias: true, strokeWidth: 2),
      ),
    );
  }

  void _handlePanEnd(
    GameCubit cubit,
  ) {
    cubit.addPoints(
      const DrawingPointsWrapper(
        points: null,
        paint: null,
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

  @override
  String toString() {
    return '{paint: $paint, points: $points}';
  }
}

extension _DrawingPointsWrapperExtension on DrawingPointsWrapper {
  DrawingPoints toDrawingPoints() {
    final points =
        this.points != null ? Offset(this.points!.dx, this.points!.dy) : null;
    final paint = this.paint != null
        ? (Paint()
          ..isAntiAlias = this.paint!.isAntiAlias ?? false
          ..strokeWidth = this.paint!.strokeWidth ?? 1.0)
        : null;
    return DrawingPoints(points: points, paint: paint);
  }
}
