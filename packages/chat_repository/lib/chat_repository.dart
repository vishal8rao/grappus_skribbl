import 'dart:convert';

import 'package:api/chat/chat_model.dart';
import 'package:api/chat/chat_state.dart';
import 'package:web_socket_client/web_socket_client.dart';

class ChatRepository {
  ChatRepository({required Uri uri}) : _ws = WebSocket(uri);

  final WebSocket _ws;

  /// function to get the current session chatting data from stream
  Stream<ChatState> get session {
    return _ws.messages.cast<String>().map(
      (event) {
        return ChatState.fromMap(jsonDecode(event) as Map<String, dynamic>);
      },
    );
  }

  /// function to send the chats to the server
  void sendChat(ChatModel chat) {
    _ws.send(chat.toJson());
  }

  /// function to get the connection
  Stream<ConnectionState> get connection => _ws.connection;

  /// function to close the connection
  void close() => _ws.close();
}
