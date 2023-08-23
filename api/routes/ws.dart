import 'dart:convert';
import 'package:api/session/bloc/session_bloc.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:player_repository/models/drawing_points.dart';
import 'package:player_repository/models/player.dart';
import 'package:uuid/uuid.dart';

/// Websocket Handler
Future<Response> onRequest(RequestContext context) async {
  final handler = webSocketHandler((channel, protocol) async {
    try {
      final player = Player(
        userId: const Uuid().v4(),
        name: 'name',
      );
      final sessionBloc = context.read<SessionBloc>()
        ..subscribe(channel)
        ..add(OnPlayerAdded(player));

      channel.sink.add(sessionBloc.state.toString());

      channel.stream.listen(
        (data) {
          try {
            final jsonData = jsonDecode(data.toString());
            final receivedPoints =
                DrawingPointsWrapper.fromJson(jsonData as Map<String, dynamic>);
            sessionBloc.add(OnPointsAdded(receivedPoints));
          } catch (e) {
            print('JSON decoding error: $e');
          }
        },
        onDone: () {
          final currentUserId = sessionBloc.state.currentPlayerId;
          sessionBloc
            ..add(OnPlayerDisconnect(currentUserId))
            ..unsubscribe(channel);
        },
        onError: (e) {
          print('WebSocket stream error: $e');
        },
      );
    } catch (e) {
      print('WebSocket connection error: $e');
    }
  });
  return handler(context);
}
