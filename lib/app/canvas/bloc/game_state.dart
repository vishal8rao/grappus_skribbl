part of 'game_bloc.dart';

class GameState extends Equatable {
  const GameState({this.sessionState});

  final SessionState? sessionState;

  GameState copyWith({SessionState? sessionState}) =>
      GameState(sessionState: sessionState ?? this.sessionState);

  @override
  List<Object?> get props => [sessionState];
}


