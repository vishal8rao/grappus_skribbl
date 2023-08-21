import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:player_repository/player_repository.dart';

part 'session_state.g.dart';

@JsonSerializable()
class SessionState extends Equatable {
  const SessionState({
    this.playerId,
    this.players = const [],
  });

  //TODO(**): current player
  final String? playerId;

  //TODO(*): Change to map
  final List<Player> players;

  SessionState copyWith({
    String? playerId,
    List<Player>? players,
  }) =>
      SessionState(
        playerId: playerId ?? this.playerId,
        players: players ?? this.players,
      );

  /// Deserializes the given `Map<String, dynamic>` into a [SessionState].
  static SessionState fromJson(Map<String, dynamic> json) =>
      _$SessionStateFromJson(json);

  /// Converts this [SessionState] into a `Map<String, dynamic>`.
  Map<String, dynamic> toJson() => _$SessionStateToJson(this);

  @override
  List<Object?> get props => [playerId, players];
}
