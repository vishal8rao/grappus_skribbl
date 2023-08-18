import 'dart:async';

import 'package:api/session/bloc/session_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:game_repository/game_repository.dart';
import 'package:player_repository/models/drawing_points.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit({required GameRepository gameRepository})
      : _gameRepository = gameRepository,
        super(const GameState());

  final GameRepository _gameRepository;
  StreamSubscription<SessionState>? _sessionStateSub;

  Future<void> connect() async {
    debugPrint('Connect');
    _sessionStateSub = _gameRepository.session.listen((sessionState) {
      emit(state.copyWith(sessionState: sessionState));
    });
    // _sessionStateSub?.onData((data) {
    //   print('player: ${data.pointsList}');
    // });
  }

  Future<void> addPoints(DrawingPointsWrappper points) async {
    try{
      _gameRepository.sendPoints(points);
      // _sessionStateSub = _gameRepository.session.listen((sessionState) {
      //   emit(state.copyWith(sessionState: sessionState));
      // });
      // _sessionStateSub?.onData((data) {
      //   print('data: ${data.pointsList}');
      // });
    }catch(e){
      debugPrint('Exception here: $e');
    }
  }
}
