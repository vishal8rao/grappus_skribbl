import 'dart:convert';

import 'package:api/session/bloc/session_bloc.dart';
import 'package:api/session/bloc/session_state.dart';
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
        try {
          print(
              '---------Socket Message Start-----------\n\n$event\\n---------------Socket Message End-----------------');
          print('JSONDECODE${json.decode(event)}');
          return SessionState.fromJson(
              json.decode(event) as Map<String, dynamic>);
        } catch (e) {
          throw Exception(e.toString());
        }
      },
    );
  }

  Stream<ConnectionState> get connection => _ws.connection;

  void close() => _ws.close();
}
