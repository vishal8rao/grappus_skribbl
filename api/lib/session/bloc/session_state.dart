part of 'session_bloc.dart';

class SessionState extends Equatable {
  factory SessionState.fromJson(Map<String, dynamic> json) {
    return SessionState(
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

  const SessionState({
    this.players = const <Player>[],
    this.points = const DrawingPointsWrapper(points: null, paint: null),
    this.currentPlayerDrawingId = '',
    this.currentPlayerId = '',
  });

  final List<Player> players;
  final DrawingPointsWrapper points;
  final String currentPlayerDrawingId;
  final String currentPlayerId;

  SessionState copyWith({
    List<Player>? players,
    DrawingPointsWrapper? points,
    String? currentPlayerDrawingId,
    String? currentPlayerId,
  }) {
    return SessionState(
      players: players ?? this.players,
      points: points ?? this.points,
      currentPlayerDrawingId:
          currentPlayerDrawingId ?? this.currentPlayerDrawingId,
      currentPlayerId: currentPlayerId ?? this.currentPlayerId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'players': List<dynamic>.from(players.map((player) => player.toJson())),
      'points': points.toJson(),
      'currentPlayerDrawingId': currentPlayerDrawingId,
      'currentPlayerId': currentPlayerId,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  @override
  List<Object?> get props =>
      [players, points, currentPlayerId, currentPlayerId];
}
