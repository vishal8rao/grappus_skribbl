import 'dart:convert';
import 'dart:math';

import 'package:api/cubit/offset_cubit.dart';
import 'package:api/session/bloc/session_bloc.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:models/events/websocket_event.dart';
import 'package:player_repository/models/player.dart';
import 'package:uuid/uuid.dart';

/// Websocket Handler
Future<Response> onRequest(RequestContext context) async {
  final sessionBloc = context.read<SessionBloc>();
  final handler = webSocketHandler((channel, protocol) {
    final offsetCubit = context.read<OffsetCubit>()..subscribe(channel);
    final player = Player(
      userId: const Uuid().v4(),
      name: 'name',
    );
    sessionBloc
      ..subscribe(channel)
      ..add(OnPlayerAdded(player));
    channel.sink.add(json.encode(sessionBloc.state.toJson()));

    channel.sink.add(offsetCubit.state.toString());

    channel.stream.listen(
      (message) {

        // if (message is String && jsonDecode(message) is Map<String, dynamic>) {
        //   final map = jsonDecode(message) as Map<String, dynamic>;
        //   final eventName = map['eventName'];
        //   switch (eventName) {
        //     case AddMousePointerEvent.name:
        //       final event = AddMousePointerEvent.fromMap(map);
        //       offsetCubit.addOffset(Point(event.mouseX, event.mouseY));
        //     default:
        //   }
        // }
      },
      onDone: () {
        sessionBloc.unsubscribe(channel);
      },
    );
  });
  return handler(context);
}
