import 'dart:convert';

import 'package:api/session/bloc/session_bloc.dart';
import 'package:player_repository/models/drawing_points.dart';
import 'package:web_socket_client/web_socket_client.dart';

/// {@template game_repository}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
class GameRepository {
  /// {@macro game_repository}
  GameRepository({required Uri uri}) : _ws = WebSocket(uri);

  final WebSocket _ws;

  Stream<SessionState> get session {
    return _ws.messages.cast<String>().map(
      (event) {
        print('event  ${jsonDecode(event)}');
        // print('event: $event');
        return SessionState.fromJson(jsonDecode(event) as Map<String, dynamic>);
      },
    );
  }

  void sendPoints(DrawingPointsWrappper points) {
    final jsonString = jsonEncode(points.toJson());
    _ws.send(jsonString);
  }

  Stream<ConnectionState> get connection => _ws.connection;

  void close() => _ws.close();
}
