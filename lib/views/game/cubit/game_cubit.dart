import 'dart:async';

import 'package:api/chat/chat_state.dart';
import 'package:api/session/bloc/session_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:chat_repository/chat_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:game_repository/game_repository.dart';
import 'package:models/chat_model.dart';
import 'package:models/drawing_points.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit({
    required GameRepository gameRepository,
    required ChatRepository chatRepository,
  })  : _gameRepository = gameRepository,
        _chatRepository = chatRepository,
        super(const GameState());

  final GameRepository _gameRepository;
  final ChatRepository _chatRepository;
  StreamSubscription<ChatState?>? _chatStateSub;
  StreamSubscription<SessionState?>? _sessionStateSub;

  Future<void> connect() async {
    _sessionStateSub = _gameRepository.session.listen((sessionState) {
      emit(state.copyWith(sessionState: sessionState));
    });
    _chatStateSub = _chatRepository.session.listen((chatState) {
      emit(state.copyWith(chatState: chatState));
    });
  }

  Future<void> addPoints(DrawingPointsWrapper points) async {
    _gameRepository.sendPoints(points);
  }

  Future<void> addChats(ChatModel chat) async {
    _chatRepository.sendChat(chat);
  }

  @override
  Future<void> close() async {
    await _sessionStateSub?.cancel();
    await _chatStateSub?.cancel();
    _gameRepository.close();
    _chatRepository.close();
    return super.close();
  }
}
