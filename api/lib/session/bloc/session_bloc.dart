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
    on<UpdateName>(_updateName);
  }

  void _onPlayerAdded(OnPlayerAdded event, Emitter<SessionState> emit) {
    final players = <Player>[...state.players, event.player];
    emit(
      state.copyWith(
        players: players,
        points: state.points,
        eventType: EventType.addPlayer,
        currentPlayerId: event.player.userId,
      ),
    );
  }

  void _updateName(UpdateName event, Emitter<SessionState> emit) {
    final player = state.players.firstWhere(
      (element) => element.userId == event.userId,
    )..copyWith(name: event.name);
    final index =
        state.players.indexWhere((element) => element.userId == event.userId);
    state.players[index] = player;
    emit(
      state.copyWith(
        players: state.players,
        eventType: EventType.addPlayer,
      ),
    );
  }

  @override
  Object toMessage(SessionState state) {
    return WebSocketResponse(
      data: state.toJson(),
      eventType: state.eventType,
    ).encodedJson();
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
    final players = [
      ...state.players,
    ]..removeWhere((player) => player.userId == event.userId);

    emit(
      state.copyWith(players: players),
    );
  }
}
