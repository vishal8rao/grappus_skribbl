import 'dart:convert';

import 'package:broadcast_bloc/broadcast_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:player_repository/player_repository.dart';

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
    emit(
      state.copyWith(
        players: <Player>[...state.players, event.player],
        currentPlayerDrawingId: '',
        currentPlayerId: currentPlayerId,
      ),
    );
  }

  void _onAddPoints(OnPointsAdded event, Emitter<SessionState> emit) {
    emit(state.copyWith(points: event.points));
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
