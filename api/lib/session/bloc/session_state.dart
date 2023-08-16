part of 'session_bloc.dart';

class SessionState extends Equatable {
  const SessionState({
    this.playerId,
    this.players = const [],
  });

  factory SessionState.fromJson(Map<String, dynamic> json) => SessionState(
        playerId: json['playerId'] as String,
        players: List<Player>.from((json['players'] as Iterable)
            .map((e) => Player.fromJson(e as String))),
      );

  final String? playerId;
  final List<Player> players;

  SessionState copyWith({
    String? playerId,
    List<Player>? players,
  }) =>
      SessionState(
        playerId: playerId ?? this.playerId,
        players: players ?? this.players,
      );

  @override
  List<Object?> get props => [playerId, players];

  Map<String, dynamic> toJson() => {
        'players': List<dynamic>.from(players.map((x) => x)),
        'playerId': playerId,
      };
}
