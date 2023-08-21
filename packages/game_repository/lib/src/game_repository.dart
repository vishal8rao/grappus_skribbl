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

  /// function to get the current session data stream
  Stream<SessionState> get session {
    return _ws.messages.cast<String>().map(
      (event) {
        return SessionState.fromJson(jsonDecode(event) as Map<String, dynamic>);
      },
    );
  }

  /// function to send the points to the server
  void sendPoints(DrawingPointsWrapper points) => _ws.send(points.toString());

  /// function to get the connection
  Stream<ConnectionState> get connection => _ws.connection;

  /// function to close the connection
  void close() => _ws.close();
}
