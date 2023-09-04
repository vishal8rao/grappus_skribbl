// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DrawingPointsWrapper {
  const DrawingPointsWrapper({
    required this.points,
    required this.paint,
  });

  final OffsetWrapper? points;
  final PaintWrapper? paint;

  bool get isNotNull => points != null;

  bool get isNull => points == null;

  Map<String, dynamic> toJson() {
    return {
      'points': points?.toJson(),
      'paint': paint?.toJson(),
    };
  }

  factory DrawingPointsWrapper.fromJson(Map<String, dynamic> json) {
    return DrawingPointsWrapper(
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
    return jsonEncode(toJson());
  }
}

class PaintWrapper {
  final bool isAntiAlias;
  final double strokeWidth;

  const PaintWrapper({
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
    return jsonEncode(toJson());
  }
}

class OffsetWrapper {
  const OffsetWrapper({
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
    return jsonEncode(toJson());
  }
}
