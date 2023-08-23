import 'dart:convert';

import 'package:api/session/bloc/session_bloc.dart';
import 'package:player_repository/models/drawing_points.dart';
import 'package:player_repository/models/room.dart';
import 'package:web_socket_client/web_socket_client.dart';

/// {@template game_repository}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
class GameRepository {
  /// {@macro game_repository}
  GameRepository({required Uri uri}) : _ws = WebSocket(uri);

  final WebSocket _ws;

  /// function to get the current session data stream
  Stream<SessionState> get session => _ws.messages.cast<String>().map(
        (event) {
          try {
            return SessionState.fromJson(
              jsonDecode(event) as Map<String, dynamic>,
            );
          } catch (e) {
            print('SessionState JSON decoding error: $e');
            rethrow; // Rethrow the error if needed
          }
        },
      );

  /// function to send the points to the server
  void sendPoints(DrawingPointsWrapper points) {
    try {
      _ws.send(points.toString());
    } catch (e) {
      print('Sending points error: $e');
    }
  }

  /// function to get the connection
  Stream<ConnectionState> get connection => _ws.connection;

  /// function to close the connection
  void close() {
    try {
      _ws.close();
    } catch (e) {
      print('Closing connection error: $e');
    }
  }
}
