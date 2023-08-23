// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:player_repository/player_repository.dart';

class Room {
  const Room({
    this.roomId = '',
    this.players = const <Player>[],
    this.points = const DrawingPointsWrapper(points: null, paint: null),
    this.currentPlayerDrawingId = '',
    this.currentPlayerId = '',
  });

  final String roomId;
  final List<Player> players;
  final DrawingPointsWrapper points;
  final String currentPlayerDrawingId;
  final String currentPlayerId;

  Room copyWith({
    String? roomId,
    List<Player>? players,
    DrawingPointsWrapper? points,
    String? currentPlayerDrawingId,
    String? currentPlayerId,
  }) {
    return Room(
      roomId: roomId ?? this.roomId,
      players: players ?? this.players,
      points: points ?? this.points,
      currentPlayerDrawingId:
          currentPlayerDrawingId ?? this.currentPlayerDrawingId,
      currentPlayerId: currentPlayerId ?? this.currentPlayerId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'players': List<dynamic>.from(players.map((player) => player.toJson())),
      'points': points.toJson(),
      'currentPlayerDrawingId': currentPlayerDrawingId,
      'currentPlayerId': currentPlayerId,
    };
  }

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      roomId: json['roomId'] as String,
      players: List<Player>.from(
        (json['players'] as Iterable).map((e) => Player.fromJson(e as String)),
      ),
      points: DrawingPointsWrapper.fromJson(
        json['points'] as Map<String, dynamic>,
      ),
      currentPlayerDrawingId: json['currentPlayerDrawingId'] as String,
      currentPlayerId: json['currentPlayerId'] as String,
    );
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

