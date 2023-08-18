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
  }

  void _onPlayerAdded(OnPlayerAdded event, Emitter<SessionState> emit) {
    var players = <Player>[...state.players, event.player];
    emit(
      state.copyWith(
        players: players,
        playerId: event.player.userId,
        pointsList: state.pointsList,
      ),
    );
  }

  void _onAddPoints(OnPointsAdded event, Emitter<SessionState> emit) {
    final newPointList = <DrawingPointsWrappper>[
      ...state.pointsList,
      event.points
    ];

    print('after adding point: $newPointList');

    emit(
      state.copyWith(pointsList: newPointList),
    );

    print('statepoint: ${state.pointsList}');
  }
}
