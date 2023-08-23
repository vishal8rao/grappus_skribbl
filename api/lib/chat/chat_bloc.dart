import 'package:api/chat/chat_state.dart';
import 'package:broadcast_bloc/broadcast_bloc.dart';
import 'package:models/chat_model.dart';
import 'package:models/web_socket_event.dart';
import 'package:models/web_socket_response.dart';

class ChatCubit extends BroadcastCubit<ChatState> {
  ChatCubit() : super(const ChatState([]));

  void addToChat(ChatModel chatModel) {
    emit(state.copyWith(messages: [...state.messages, chatModel]));
  }

  @override
  Object toMessage(ChatState state) {
    return WebSocketResponse(
      data: state.toMap(),
      eventType: EventType.chat,
    ).encodedJson();
  }
}
