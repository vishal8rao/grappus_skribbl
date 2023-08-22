import 'package:api/chat/chat_model.dart';
import 'package:api/chat/chat_state.dart';
import 'package:broadcast_bloc/broadcast_bloc.dart';

class ChatCubit extends BroadcastCubit<ChatState> {
  ChatCubit() : super(const ChatState([]));

  void addToChat(ChatModel chatModel) {
    emit(state.copyWith(messages: [...state.messages, chatModel]));
  }
}
