part of 'game_cubit.dart';

enum GameStatus { connected, disconnected }

class GameState extends Equatable {
  const GameState({
    this.room,
  });

  final Room? room;

  GameState copyWith({
    Room? room,
  }) =>
      GameState(
        room: room ?? this.room,
      );

  @override
  List<Object?> get props => [room];
}
