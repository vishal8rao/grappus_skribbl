import 'dart:convert';

import 'package:broadcast_bloc/broadcast_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:models/chat_model.dart';
import 'package:models/drawing_points.dart';
import 'package:models/player.dart';
import 'package:models/web_socket_event.dart';
import 'package:models/web_socket_response.dart';

part 'session_event.dart';

part 'session_state.dart';

class SessionBloc extends BroadcastBloc<SessionEvent, SessionState> {
  SessionBloc() : super(const SessionState()) {
    on<OnPlayerAdded>(_onPlayerAdded);
    on<OnPointsAdded>(_onAddPoints);
    on<OnPlayerDisconnect>(_onPlayerDisconnect);
    on<OnMessageSent>(_onMessageSent);
  }

  void _onPlayerAdded(OnPlayerAdded event, Emitter<SessionState> emit) {
    emit(
      state.copyWith(
        currentPlayerId: event.player.userId,
        eventType: EventType.connect,
      ),
    );
    final players = <String, Player>{}
      ..addAll(state.players)
      ..putIfAbsent(event.player.userId, () => event.player);
    emit(
      state.copyWith(
        players: players,
        eventType: EventType.addPlayer,
        points: state.points,
        currentPlayerId: null,
      ),
    );
  }

  void _onAddPoints(OnPointsAdded event, Emitter<SessionState> emit) {
    emit(
      state.copyWith(points: event.points, eventType: EventType.drawing),
    );
  }

  void _onMessageSent(OnMessageSent event, Emitter<SessionState> emit) {
    emit(
      state.copyWith(
        messages: [...state.messages, event.chat],
        eventType: EventType.chat,
      ),
    );
  }

  void _onPlayerDisconnect(
    OnPlayerDisconnect event,
    Emitter<SessionState> emit,
  ) {
    final players = state.players
      ..removeWhere((key, value) => value == event.player);

    emit(state.copyWith(players: players));
  }

  @override
  Object toMessage(SessionState state) {
    return WebSocketResponse(
      data: state.toJson(),
      eventType: state.eventType,
    ).encodedJson();
  }
}
