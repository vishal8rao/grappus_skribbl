// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:models/chat_model.dart';

class ChatState extends Equatable {
  const ChatState(this.messages);
  final List<ChatModel> messages;

  @override
  List<Object?> get props => [messages];

  ChatState copyWith({
    List<ChatModel>? messages,
  }) {
    return ChatState(
      messages ?? this.messages,
    );
  }

  String encodedJson() {
    return toJson();
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'messages': messages.map((x) => x.toMap()).toList(),
    };
  }

  factory ChatState.fromMap(Map<String, dynamic> map) {
    return ChatState(
      List<ChatModel>.from(
        (map['messages'] as List<dynamic>).map<ChatModel>(
          (x) => ChatModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatState.fromJson(String source) =>
      ChatState.fromMap(json.decode(source) as Map<String, dynamic>);
}
