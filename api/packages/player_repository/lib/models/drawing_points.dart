
class DrawingPointsWrappper {
  DrawingPointsWrappper({
    required this.points,
    required this.paint,
  });

  final OffsetWrapper? points;
  final PaintWrapper? paint;

  // final Offset? points;
  // final Paint? paint;

  bool get isNotNull => points != null;

  bool get isNull => points == null;

  Map<String, dynamic> toJson() {
    return {
      'points': points?.toJson(),
      'paint': paint?.toJson(),
    };
  }

  factory DrawingPointsWrappper.fromJson(Map<String, dynamic> json) {
    return DrawingPointsWrappper(
      points: json['points'] != null
          ? OffsetWrapper.fromJson(json['points'] as Map<String, dynamic>)
          : null,
      paint: json['paint'] != null
          ? PaintWrapper.fromJson(json['paint'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  String toString() {
    return 'DrawingPointsWrappper{points: $points, paint: $paint}';
  }
}

class PaintWrapper {
  final bool isAntiAlias;
  final double strokeWidth;

  PaintWrapper({
    required this.isAntiAlias,
    required this.strokeWidth,
  });

  Map<String, dynamic> toJson() {
    return {
      'isAntiAlias': isAntiAlias,
      'strokeWidth': strokeWidth,
    };
  }

  factory PaintWrapper.fromJson(Map<String, dynamic> json) {
    return PaintWrapper(
      isAntiAlias: json['isAntiAlias'] as bool,
      strokeWidth: double.parse(json['strokeWidth'].toString()),
    );
  }

  @override
  String toString() {
    return 'PaintWrapper{isAntiAlias: $isAntiAlias, strokeWidth: $strokeWidth}';
  }
}

class OffsetWrapper {
  OffsetWrapper({
    required this.dx,
    required this.dy,
  });

  factory OffsetWrapper.fromJson(Map<String, dynamic> json) {
    return OffsetWrapper(
      dx: double.parse(json['dx'].toString()),
      dy: double.parse(json['dy'].toString()),
    );
  }

  final double dx;
  final double dy;

  Map<String, dynamic> toJson() {
    return {
      'dx': dx,
      'dy': dy,
    };
  }

  @override
  String toString() {
    return 'OffsetWrapper{dx: $dx, dy: $dy}';
  }
}
