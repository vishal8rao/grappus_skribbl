import 'dart:convert';

import 'package:broadcast_bloc/broadcast_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:player_repository/models/room.dart';
import 'package:player_repository/player_repository.dart';
import 'package:uuid/uuid.dart';

part 'session_event.dart';

part 'session_state.dart';

class SessionBloc extends BroadcastBloc<SessionEvent, SessionState> {
  SessionBloc() : super(const SessionState()) {
    on<OnPlayerAdded>(_onPlayerAdded);
    on<OnPointsAdded>(_onAddPoints);
    on<OnPlayerDisconnect>(_onPlayerDisconnect);
  }

  void _onPlayerAdded(OnPlayerAdded event, Emitter<SessionState> emit) {
    final currentPlayerId = event.player.userId;
    final currentPlayerDrawingId = currentPlayerId;
    final roomId = const Uuid().v4();

    final room = state.room.copyWith(
      players: <Player>[...state.room.players, event.player],
      currentPlayerDrawingId: currentPlayerDrawingId,
      currentPlayerId: currentPlayerDrawingId,
      roomId: state.room.roomId.isEmpty ? roomId : state.room.roomId,
    );
    emit(
      state.copyWith(
        room: room,
      ),
    );
  }

  void _onAddPoints(OnPointsAdded event, Emitter<SessionState> emit) {
    final room = state.room.copyWith(points: event.points);
    emit(state.copyWith(room: room));
  }

  void _onPlayerDisconnect(
      OnPlayerDisconnect event, Emitter<SessionState> emit) {
    final players = [
      ...state.room.players,
    ]..removeWhere((player) => player.userId == event.userId);

    final room = state.room.copyWith(players: players);
    emit(
      state.copyWith(room: room),
    );
  }
}
