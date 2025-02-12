import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:api/utils/utils.dart';
import 'package:broadcast_bloc/broadcast_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

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
        // ignore: avoid_redundant_argument_values
        currentPlayerId: null,
      ),
    );
    if (state.players.length == 2 && state.correctAnswer.isEmpty) {
      add(const OnRoundStarted());
    }
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
      if (event.chat.player.userId == state.isDrawing) {
        return;
      }
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

      final allPlayersAnsweredCorrectly = state.players.keys
          .where((element) => element != state.isDrawing)
          .any((playerID) => state.players[playerID]!.hasAnsweredCorrectly);

      if (allPlayersAnsweredCorrectly) {
        add(const OnRoundEnded());
      }

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
    const pointsDeductionPerInterval = 5;

    final deductionIntervals = (guessedAt ~/ pointsDeductionPerInterval)
        .clamp(0, SessionState.roundDuration ~/ pointsDeductionPerInterval);

    if (!isDrawing) {
      final points = maxPoints - (numOfGuesses * pointsDeductionPerGuess);
      final totalDeduction = deductionIntervals * pointsDeductionPerGuess;

      return points >= totalDeduction ? points - totalDeduction : 0;
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

  Future<void> _onRoundStarted(
    OnRoundStarted event,
    Emitter<SessionState> emit,
  ) async {
    await _tickerSub?.cancel();

    final players = state.players;

    var currentRound = state.round;

    final remainingPlayers = state.players.keys
        .where((id) => !state.players[id]!.hasCompletedDrawingRound)
        .toList();

    if (remainingPlayers.isEmpty) {
      // TODO: End game here then start a new match with everything reset
      // At this point all players have drawn, we can show leaderboard.
      return;
    }

    // Select a random player from the players who havent drawn yet
    final randomIndex = Random().nextInt(
      max(1, remainingPlayers.length - 1),
    );

    final currentDrawingPlayerID =
        remainingPlayers[max(randomIndex, remainingPlayers.length - 1)];
    players[currentDrawingPlayerID]?.copyWith(isDrawing: true);

    final randomWord = await getRandomWord;
    emit(
      state.copyWith(
        round: ++currentRound,
        isDrawing: currentDrawingPlayerID,
        points: const DrawingPointsWrapper(points: null, paint: null),
        players: players.map(
          (key, value) => MapEntry(
            key,
            value.copyWith(
              hasAnsweredCorrectly: false,
            ),
          ),
        ),
        correctAnswer: randomWord,
        eventType: EventType.roundStart,
      ),
    );
    _tickerSub = _ticker.tick(ticks: SessionState.roundDuration).listen(
          (duration) => add(_TimerTicked(duration: duration)),
        );
  }

  void _onTicked(_TimerTicked event, Emitter<SessionState> emit) {
    emit(state.copyWith(remainingTime: event.duration));
    if (event.duration == 0) {
      add(const OnRoundEnded());
      return;
    }
  }

  Future<void> _onRoundEnded(
    OnRoundEnded event,
    Emitter<SessionState> emit,
  ) async {
    final players = <String, Player>{}..addAll(state.players);
    players.forEach((key, value) {
      final prevScore = value.score;
      players[key] = value.copyWith(
        score: prevScore +
            _calculateScore(
              key == state.isDrawing,
              value.guessedAt,
              value.numOfGuesses,
              state.numOfCorrectGuesses,
            ),
      );
    });
    if (players.keys.contains(state.isDrawing)) {
      players[state.isDrawing] =
          players[state.isDrawing]!.copyWith(hasCompletedDrawingRound: true);
    }

    emit(
      state.copyWith(
        players: players,
        eventType: EventType.roundEnd,
        isDrawing: '',
      ),
    );

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
