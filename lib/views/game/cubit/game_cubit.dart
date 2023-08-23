import 'dart:async';

import 'package:api/session/bloc/session_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:game_repository/game_repository.dart';
import 'package:player_repository/models/drawing_points.dart';
import 'package:player_repository/models/room.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit({required GameRepository gameRepository})
      : _gameRepository = gameRepository,
        super(const GameState());

  final GameRepository _gameRepository;
  StreamSubscription<Room>? _roomStreamSubscription;

  Future<void> connect() async {
    debugPrint('Connect');
    try {
      _roomStreamSubscription = _gameRepository.session.listen((room) {
        emit(state.copyWith(room: room));
      });
    } catch (e) {
      print('Session state subscription error: $e');
    }
  }

  Future<void> addPoints(DrawingPointsWrapper points) async {
    try {
      _gameRepository.sendPoints(points);
    } catch (e) {
      print('Sending points error from GameCubit: $e');
    }
  }

  @override
  Future<void> close() async {
    await _roomStreamSubscription?.cancel();
    try {
      _gameRepository.close();
    } catch (e) {
      print('Closing connection error from GameCubit: $e');
    }
    return super.close();
  }
}
