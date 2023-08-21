part of 'session_bloc.dart';

class SessionState extends Equatable {
  const SessionState({
    this.playerId = '',
    this.players = const [],
    this.points = const DrawingPointsWrappper(points: null, paint: null),
  });

  factory SessionState.fromJson(Map<String, dynamic> json) => SessionState(
        playerId: json['playerId'] as String,
        players: List<Player>.from(
          (json['players'] as Iterable)
              .map((e) => Player.fromJson(e as String)),
        ),
        points: DrawingPointsWrappper.fromJson(
          json['points'] as Map<String, dynamic>,
        ),
      );

  final String playerId;
  final List<Player> players;
  final DrawingPointsWrappper points;

  SessionState copyWith({
    String? playerId,
    List<Player>? players,
    DrawingPointsWrappper? points,
  }) {
    return SessionState(
      playerId: playerId ?? this.playerId,
      players: players ?? this.players,
      points: points ?? this.points,
    );
  }

  @override
  List<Object?> get props => [points, playerId, players];

  Map<String, dynamic> toJson() => {
        'players': List<dynamic>.from(players.map((x) => x)),
        'playerId': playerId,
        'points': points.toJson(),
      };

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
