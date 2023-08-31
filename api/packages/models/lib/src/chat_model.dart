// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:models/src/player.dart';

class ChatModel {
  const ChatModel({
    required this.player,
    required this.message,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      player: Player.fromMap(map['player'] as Map<String, dynamic>),
      message: map['message'] as String,
    );
  }

  factory ChatModel.fromJson(String source) =>
      ChatModel.fromMap(json.decode(source) as Map<String, dynamic>);
  final Player player;
  final String message;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'player': player.toMap(),
      'message': message,
    };
  }

  String toJson() => json.encode(toMap());

  ChatModel copyWith({
    Player? player,
    String? message,
  }) {
    return ChatModel(
      player: player ?? this.player,
      message: message ?? this.message,
    );
  }
}
