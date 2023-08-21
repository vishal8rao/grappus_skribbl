import 'dart:convert';

import 'package:api/session/bloc/session_bloc.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:player_repository/models/player.dart';
import 'package:uuid/uuid.dart';

/// Websocket Handler
Future<Response> onRequest(RequestContext context) async {
  final sessionBloc = context.read<SessionBloc>();
  final handler = webSocketHandler((channel, protocol) {
    // final offsetCubit = context.read<OffsetCubit>()..subscribe(channel);

    final player = Player(
      userId: const Uuid().v4(),
      name: 'name',
    );
    sessionBloc
      ..subscribe(channel)
      ..add(OnPlayerAdded(player));

    print(
      '---------Encoding Json Start-----------\n' +
          json.encode(json.encode(sessionBloc.state.toJson())) +
          '\n---------Encoding Json End-----------',
    );

    channel.sink.add(json.encode(sessionBloc.state.toJson()));
    // channel.sink.add(offsetCubit.state.toString());
  });
  return handler(context);
}
