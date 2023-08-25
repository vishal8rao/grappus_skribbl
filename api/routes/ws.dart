import 'dart:convert';

import 'package:api/session/bloc/session_bloc.dart';
import 'package:api/utils/websocket_event_handler.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:models/player.dart';
import 'package:models/web_socket_event.dart';
import 'package:uuid/uuid.dart';

/// Websocket Handler
Future<Response> onRequest(RequestContext context) async {
  final handler = webSocketHandler((channel, protocol) {
    final sessionBloc = context.read<SessionBloc>()..subscribe(channel);
    final player = Player(userId: '', name: '');
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
              sessionBloc.add(OnMessageSent(chatModel));

            case AddPlayerEvent:
              player.name = (websocketEvent as AddPlayerEvent).data;
              player.userId = const Uuid().v4();

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
        sessionBloc
          ..add(OnPlayerDisconnect(player))
          ..unsubscribe(channel);
      },
    );
  });
  return handler(context);
}
