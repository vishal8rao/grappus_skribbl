part of 'session_bloc.dart';

class SessionState extends Equatable {
  const SessionState({
    this.playerId,
    this.players = const {},
  });

  factory SessionState.fromJson(Map<String, dynamic> json) => SessionState(
        playerId: json['playerId'] as String,
        players: Map<String, Player>.from(json['players'] as Map),
      );

  final String? playerId;
  final Map<String, Player> players;

  SessionState copyWith({
    String? playerId,
    Map<String, Player>? players,
  }) =>
      SessionState(
        playerId: playerId ?? this.playerId,
        players: players ?? this.players,
      );

  @override
  List<Object?> get props => [playerId, players];

  Map<String, dynamic> toJson() => {
        'players': Map<String, Player>.from(players),
        'playerId': playerId,
      };
}
