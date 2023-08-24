part of 'session_bloc.dart';

class SessionState extends Equatable {
  const SessionState({
    this.currentPlayerId,
    this.players = const {},
    this.points = const DrawingPointsWrapper(points: null, paint: null),
    this.eventType = EventType.invalid,
    this.messages = const [],
  });

  factory SessionState.fromJson(Map<String, dynamic> json) => SessionState(
        currentPlayerId: json['currentPlayerId'] as String,
        players: (json['players'] as Map<String, dynamic>?)?.map(
              (k, e) => MapEntry(k, Player.fromJson(e as String)),
        ) ??
            const {},
        points: DrawingPointsWrapper.fromJson(
          json['points'] as Map<String, dynamic>,
        ),
        eventType:
            EventType.fromJson(json['eventType'] as Map<String, dynamic>),
        messages: List<ChatModel>.from(
          (json['messages'] as List<dynamic>).map<ChatModel>(
            (x) => ChatModel.fromMap(x as Map<String, dynamic>),
          ),
        ),
      );

  final String? currentPlayerId;
  final Map<String, Player> players;
  final DrawingPointsWrapper points;
  final EventType eventType;
  final List<ChatModel> messages;

  SessionState copyWith({
    String? currentPlayerId,
    Map<String, Player>? players,
    DrawingPointsWrapper? points,
    EventType? eventType,
    List<ChatModel>? messages,
  }) {
    return SessionState(
      currentPlayerId: currentPlayerId ?? this.currentPlayerId,
      players: players ?? this.players,
      points: points ?? this.points,
      eventType: eventType ?? this.eventType,
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object?> get props => [
        points,
        currentPlayerId,
        players,
        eventType,
        messages,
      ];

  Map<String, dynamic> toJson() => {
        'players': Map<String, Player>.from(players),
        'currentPlayerId': currentPlayerId,
        'points': points.toJson(),
        'eventType': eventType.toJson(),
        'messages': messages.map((x) => x.toMap()).toList()
      };

  @override
  String toString() {
    return encodedJson();
  }

  String encodedJson() {
    return jsonEncode(toJson());
  }
}
