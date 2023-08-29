import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:api/utils/utils.dart';
import 'package:broadcast_bloc/broadcast_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:models/chat_model.dart';
import 'package:models/drawing_points.dart';
import 'package:models/player.dart';
import 'package:models/web_socket_event.dart';
import 'package:models/web_socket_response.dart';

part 'session_event.dart';part 'session_state.dart';

class SessionBloc extends BroadcastBloc<SessionEvent, SessionState> {
  SessionBloc(Ticker ticker)
      : _ticker = ticker,
        super(const SessionState()) {
    on<OnPlayerAdded>(_onPlayerAdded);
    on<OnPointsAdded>(_onAddPoints);
    on<OnPlayerDisconnect>(_onPlayerDisconnect);
    on<OnMessageSent>(_onMessageSent);
    on<OnRoundStarted>(_onRoundStarted);
    on<OnRoundEnded>(_onRoundEnded);
    on<_TimerTicked>(_onTicked);
  }

  final Ticker _ticker;
  StreamSubscription<int>? _tickerSub;

  @override
  Future<void> close() {
    _tickerSub?.cancel();
    return super.close();
  }

  void _onPlayerAdded(OnPlayerAdded event, Emitter<SessionState> emit) {
    // Round has started when the second player joins the game
    if (state.players.length == 2 && state.correctAnswer.isEmpty) {
      add(const OnRoundStarted());
    }
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

        ///Making [currentPlayerId] null so that it does not override
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
    final players = state.players;
    var guesses = players[event.chat.player.userId]?.numOfGuesses ?? 0;

    final isCorrectAnswer = _checkIfMessageIsCorrectAnswer(event);
    if (isCorrectAnswer) {
      players[event.chat.player.userId] =
          players[event.chat.player.userId]!.copyWith(
        hasAnsweredCorrectly: true,
        numOfGuesses: ++guesses,
        guessedAt: state.remainingTime,
      );
      var correctGuesses = state.numOfCorrectGuesses;
      emit(
        state.copyWith(
          messages: [
            ...state.messages,
            event.chat.copyWith(
              player: event.chat.player.copyWith(hasAnsweredCorrectly: true),
            ),
          ],
          players: players,
          eventType: EventType.chat,
          numOfCorrectGuesses: ++correctGuesses,
        ),
      );
      return;
    }
    players[event.chat.player.userId]?.copyWith(numOfGuesses: ++guesses);
    emit(
      state.copyWith(
        messages: [...state.messages, event.chat],
        eventType: EventType.chat,
        players: players,
      ),
    );
  }

  bool _checkIfMessageIsCorrectAnswer(OnMessageSent event) {
    final message = event.chat.message.trim();
    return message.toUpperCase() == state.correctAnswer.toUpperCase();
  }

  int _calculateScore(
    bool isDrawing,
    int guessedAt,
    int numOfGuesses,
    int numOfCorrectGuesses,
  ) {
    const maxPoints = 300;
    const baseDrawingPoints = 100;
    const pointsDeductionPerGuess = 2;
    if (!isDrawing) {
      return switch (guessedAt) {
        >= 25 => maxPoints - (numOfGuesses * pointsDeductionPerGuess),
        >= 20 => maxPoints - (numOfGuesses * pointsDeductionPerGuess) - 50,
        >= 15 => maxPoints - (numOfGuesses * pointsDeductionPerGuess) - 100,
        >= 10 => maxPoints - (numOfGuesses * pointsDeductionPerGuess) - 150,
        >= 5 => maxPoints - (numOfGuesses * pointsDeductionPerGuess) - 200,
        >= 0 => maxPoints - (numOfGuesses * pointsDeductionPerGuess) - 250,
        _ => 0,
      };
    }
    final bonusPointsPerGuess =
        numOfCorrectGuesses == 0 ? 0 : maxPoints ~/ numOfCorrectGuesses;
    return baseDrawingPoints + bonusPointsPerGuess * numOfCorrectGuesses;
  }

  void _onPlayerDisconnect(
    OnPlayerDisconnect event,
    Emitter<SessionState> emit,
  ) {
    final map = state.players;
    final players = map..removeWhere((key, value) => value == event.player);

    emit(state.copyWith(players: players));
  }

  void _onRoundStarted(OnRoundStarted event, Emitter<SessionState> emit) {
    _tickerSub?.cancel();
    //FIXME(*): getRandomWord messes players mapping
    // final correctAnswer = getRandomWord;

    final players = state.players;

    var currentRound = state.round;
    final isDrawing = state.players.keys.toList()[Random().nextInt(
      state.players.keys.length - 1,
    )];
    players[isDrawing]?.copyWith(isDrawing: true);
    emit(
      state.copyWith(
        round: ++currentRound,
        isDrawing: isDrawing,
        players: players,
        correctAnswer: 'correctAnswer',
      ),
    );
    _tickerSub = _ticker.tick(ticks: 30).listen(
          (duration) => add(_TimerTicked(duration: duration)),
        );
  }

  void _onTicked(_TimerTicked event, Emitter<SessionState> emit) {
    if (event.duration <= 0) {
      add(const OnRoundEnded());
      return;
    }
    emit(state.copyWith(remainingTime: event.duration));
  }

  Future<void> _onRoundEnded(
    OnRoundEnded event,
    Emitter<SessionState> emit,
  ) async {
    final players = <String, Player>{}..addAll(state.players);
    players.forEach((key, value) {
      players[key] = value.copyWith(
        score: _calculateScore(
          key == state.isDrawing,
          value.guessedAt,
          value.numOfGuesses,
          state.numOfCorrectGuesses,
        ),
      );
    });
    emit(state.copyWith(players: players));
    await Future.delayed(
      const Duration(seconds: 5),
      () => add(const OnRoundStarted()),
    );
  }

  @override
  Object toMessage(SessionState state) {
    return WebSocketResponse(
      data: state.toJson(),
      eventType: state.eventType,
    ).encodedJson();
  }
}
