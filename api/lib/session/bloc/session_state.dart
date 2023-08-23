part of 'session_bloc.dart';

class SessionState extends Equatable {
  const SessionState({
    this.currentPlayerId = '',
    this.players = const [],
    this.points = const DrawingPointsWrapper(points: null, paint: null),
    this.eventType = EventType.invalid,
  });

  factory SessionState.fromJson(Map<String, dynamic> json) => SessionState(
        currentPlayerId: json['currentPlayerId'] as String,
        players: List<Player>.from(
          (json['players'] as Iterable)
              .map((e) => Player.fromJson(e as String)),
        ),
        points: DrawingPointsWrapper.fromJson(
          json['points'] as Map<String, dynamic>,
        ),
        eventType: json['evenType'] as EventType,
      );

  final String currentPlayerId;
  final List<Player> players;
  final DrawingPointsWrapper points;
  final EventType eventType;

  SessionState copyWith({
    String? currentPlayerId,
    List<Player>? players,
    DrawingPointsWrapper? points,
    EventType? eventType,
  }) {
    return SessionState(
      currentPlayerId: currentPlayerId ?? this.currentPlayerId,
      players: players ?? this.players,
      points: points ?? this.points,
      eventType: eventType ?? this.eventType,
    );
  }

  @override
  List<Object?> get props => [
        points,
        currentPlayerId,
        players,
        eventType,
      ];

  Map<String, dynamic> toJson() => {
        'players': List<dynamic>.from(players.map((x) => x)),
        'currentPlayerId': currentPlayerId,
        'points': points.toJson(),
        'eventType': eventType.toJson(),
      };

  @override
  String toString() {
    return encodedJson();
  }

  String encodedJson() {
    return jsonEncode(toJson());
  }
}
