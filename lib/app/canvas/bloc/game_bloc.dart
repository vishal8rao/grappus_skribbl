import 'dart:async';

import 'package:api/session/bloc/session_bloc.dart';
import 'package:api/session/bloc/session_state.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:game_repository/game_repository.dart';

part 'game_event.dart';

part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc({required GameRepository gameRepository})
      : _gameRepository = gameRepository,
        super(const GameState()) {
    on<OnGameConnected>(_connect);
  }

  final GameRepository _gameRepository;

  Future<void> _connect(OnGameConnected event, Emitter<GameState> emit) async {
    debugPrint('Connect');
    try {
      await emit.forEach(
        _gameRepository.session,
        onData: (data) {
          return state.copyWith(sessionState: data);
        },
      );
    } catch (e) {
      addError(e, StackTrace.current);
    }
  }
}
