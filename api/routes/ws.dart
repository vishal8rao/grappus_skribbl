import 'dart:convert';

import 'package:api/chat/chat_bloc.dart';
import 'package:api/session/bloc/session_bloc.dart';
import 'package:api/utils/websocket_event_handler.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:models/player.dart';
import 'package:models/web_socket_event.dart';
import 'package:models/web_socket_response.dart';
import 'package:uuid/uuid.dart';

/// Websocket Handler
Future<Response> onRequest(RequestContext context) async {
  final handler = webSocketHandler((channel, protocol) {
    final sessionBloc = context.read<SessionBloc>();
    final chatCubit = context.read<ChatCubit>();

    channel.sink.add(
      WebSocketResponse(
        data: chatCubit.state.toMap(),
        eventType: EventType.chat,
      ).encodedJson(),
    );
    sessionBloc.subscribe(channel);
    chatCubit.subscribe(channel);

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
          final websocketEvent =
              WebSocketEventHandler.handleWebSocketEvent(jsonData);

          switch (websocketEvent.runtimeType) {
            case AddDrawingPointsEvent:
              final receivedPoints =
                  (websocketEvent as AddDrawingPointsEvent).data;
              sessionBloc.add(OnPointsAdded(receivedPoints));

            case AddToChatEvent:
              final chatModel = (websocketEvent as AddToChatEvent).data;
              chatCubit.addToChat(chatModel);

            case AddPlayerEvent:
              final name =
                  (websocketEvent as AddPlayerEvent).data;
              final uid = const Uuid().v4();
              final player = Player(userId: uid, name: name);
              sessionBloc.add(OnPlayerAdded(player));
          }
        } catch (e) {
          channel.sink.add(
            jsonEncode({'status': 'error', 'message': e.toString()}),
          );
          rethrow;
        }
      },
      onDone: () {
        final currentUserId = sessionBloc.state.currentPlayerId;
        chatCubit.unsubscribe(channel);
        sessionBloc
          ..add(OnPlayerDisconnect(currentUserId))
          ..unsubscribe(channel);
      },
    );
  });
  return handler(context);
}
