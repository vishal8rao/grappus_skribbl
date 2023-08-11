import 'dart:convert';
import 'dart:math';

import 'package:api/cubit/offset_cubit.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:domain/events/websocket_event.dart';

/// Websocket Handler
Future<Response> onRequest(RequestContext context) async {
  final handler = webSocketHandler((channel, protocol) {
    final offsetCubit = context.read<OffsetCubit>()..subscribe(channel);

    channel.sink.add(offsetCubit.state.toString());

    channel.stream.listen((message) {
      if (message is String && jsonDecode(message) is Map<String, dynamic>) {
        final map = jsonDecode(message) as Map<String, dynamic>;
        final eventName = map['eventName'];
        switch (eventName) {
          case AddMousePointerEvent.name:
            final event = AddMousePointerEvent.fromMap(map);
            offsetCubit.addOffset(Point(event.mouseX, event.mouseY));
          default:
        }
      }
    });
  });
  return handler(context);
}
