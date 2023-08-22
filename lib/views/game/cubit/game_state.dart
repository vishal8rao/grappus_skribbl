// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'game_cubit.dart';

class GameState extends Equatable {
  const GameState({
    this.sessionState,
    this.chatState,
  });

  final SessionState? sessionState;
  final ChatState? chatState;

  GameState copyWith({
    SessionState? sessionState,
    ChatState? chatState,
  }) {
    return GameState(
      sessionState: sessionState ?? this.sessionState,
      chatState: chatState ?? this.chatState,
    );
  }

  @override
  List<Object?> get props => [sessionState, chatState];
}
