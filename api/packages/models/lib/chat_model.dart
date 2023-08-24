import 'dart:convert';

import 'package:models/player.dart';

class ChatModel {
  final Player player;
  final String message;

  const ChatModel({
    required this.player,
    required this.message,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'player': player.toMap(),
      'message': message,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      player: Player.fromMap(map['player'] as Map<String, dynamic>),
      message: map['message'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) =>
      ChatModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
