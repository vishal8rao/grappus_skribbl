import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:api/utils/src/random_words.dart';
import 'package:api/utils/src/ticker.dart';
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
    if (state.players.length == 1 && state.correctAnswer.isEmpty) {
      emit(state.copyWith(correctAnswer: getRandomWord));
      add(OnRoundStarted());
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
    players[event.chat.player.userId] =
        players[event.chat.player.userId]!.copyWith();
    final isCorrectAnswer = _checkIfMessageIsCorrectAnswer(event);
    if (isCorrectAnswer) {
      players[event.chat.player.userId] = players[event.chat.player.userId]!
          .copyWith(hasAnsweredCorrectly: true);
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
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        messages: [...state.messages, event.chat],
        eventType: EventType.chat,
      ),
    );
  }

  bool _checkIfMessageIsCorrectAnswer(OnMessageSent event) {
    final message = event.chat.message.trim();
    return message.toUpperCase() == state.correctAnswer.toUpperCase();
  }

  int _calculateScore(
    bool isDrawing,
    int secondsPassed,
    int numOfGuesses,
    int numOfCorrectGuesses,
  ) {
    const maxPoints = 300;
    const pointsDeductionPerGuess = 2;
    if (!isDrawing) {
      return switch (secondsPassed) {
        >= 25 => maxPoints - (numOfGuesses * pointsDeductionPerGuess),
        >= 20 => maxPoints - (numOfGuesses * pointsDeductionPerGuess) - 50,
        >= 15 => maxPoints - (numOfGuesses * pointsDeductionPerGuess) - 100,
        >= 10 => maxPoints - (numOfGuesses * pointsDeductionPerGuess) - 150,
        >= 5 => maxPoints - (numOfGuesses * pointsDeductionPerGuess) - 200,
        >= 0 => maxPoints - (numOfGuesses * pointsDeductionPerGuess) - 250,
        _ => 0,
      };
    }
    final bonusPointsPerGuess = maxPoints ~/ numOfCorrectGuesses;
    return maxPoints + bonusPointsPerGuess * numOfCorrectGuesses;
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

    var currentRound = state.round;
    final isDrawing = state.players.keys.toList()[Random().nextInt(
      state.players.keys.length - 1,
    )];
    emit(
      state.copyWith(
        round: ++currentRound,
        isDrawing: isDrawing,
      ),
    );
    _tickerSub = _ticker.tick(ticks: 30).listen(
          (duration) => add(_TimerTicked(duration: duration)),
        );
  }

  void _onTicked(_TimerTicked event, Emitter<SessionState> emit) {
    emit(state.copyWith(remainingTime: event.duration));
  }

  void _onRoundEnded(OnRoundEnded event, Emitter<SessionState> emit) {
    var currentRound = state.round;

    emit(state.copyWith(round: ++currentRound));
  }

  @override
  Object toMessage(SessionState state) {
    return WebSocketResponse(
      data: state.toJson(),
      eventType: state.eventType,
    ).encodedJson();
  }
}
