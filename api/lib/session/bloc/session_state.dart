part of 'session_bloc.dart';

class SessionState extends Equatable {
  const SessionState({
    this.playerId,
    this.players = const [],
    this.pointsList = const [],
  });

  factory SessionState.fromJson(Map<String, dynamic> json) => SessionState(
        playerId: json['playerId'] as String,
        players: List<Player>.from(
          (json['players'] as Iterable)
              .map((e) => Player.fromJson(e as String)),
        ),
        pointsList: List<DrawingPointsWrappper>.from(json['points'] as Iterable)
            .map(
              (e) => DrawingPointsWrappper.fromJson(
                e as Map<String, dynamic>,
              ),
            )
            .toList(),
      );

  final String? playerId;
  final List<Player> players;

  final List<DrawingPointsWrappper> pointsList;

  SessionState copyWith({
    String? playerId,
    List<Player>? players,
    List<DrawingPointsWrappper>? pointsList,
  }) {
    return SessionState(
      playerId: playerId ?? this.playerId,
      players: players ?? this.players,
      pointsList: pointsList ?? this.pointsList,
    );
  }

  @override
  List<Object?> get props => [playerId, players, pointsList];

  Map<String, dynamic> toJson() => {
        'players': List<dynamic>.from(players.map((x) => x)),
        'playerId': playerId,
        'points': List<dynamic>.from(pointsList.map((x) => x)),
      };
}
