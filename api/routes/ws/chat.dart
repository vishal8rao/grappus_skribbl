import 'dart:convert';
import 'package:api/chat/chat_bloc.dart';
import 'package:api/chat/chat_model.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

/// Websocket Handler
Future<Response> onRequest(RequestContext context) async {
  final handler = webSocketHandler((channel, protocol) {
    final chatCubit = context.read<ChatCubit>()..subscribe(channel);

    channel.sink.add(chatCubit.state.toString());
    channel.stream.listen(
      (data) {
        try {
          if (data == null || data.toString().isEmpty) {
            channel.sink.add(
              jsonEncode({
                'status': 'Error invalid data:$data',
              }),
            );

            return;
          }
          final jsonData = jsonDecode(data.toString());
          if (jsonData is! Map<String, dynamic>) {
            channel.sink.add(
              jsonEncode({
                'status': 'Error invalid data:$data',
              }),
            );
            return;
          }
          final chatModel = ChatModel.fromMap(jsonData);
          chatCubit.addToChat(chatModel);
        } catch (e) {
          channel.sink.add(
            jsonEncode({'status': 'error', 'message': e.toString()}),
          );
        }
      },
      onDone: () {
        chatCubit.unsubscribe(channel);
      },
    );
  });
  return handler(context);
}
