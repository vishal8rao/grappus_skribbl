part of 'session_bloc.dart';

abstract class SessionEvent extends Equatable {
  const SessionEvent();
}

class OnPlayerAdded extends SessionEvent {
  const OnPlayerAdded(this.player);

  final Player player;

  @override
  List<Object?> get props => [player];
}

class OnPointsAdded extends SessionEvent {
  const OnPointsAdded(this.points);

  final DrawingPointsWrapper points;

  @override
  List<Object?> get props => [points];
}

class OnPlayerDisconnect extends SessionEvent {
  const OnPlayerDisconnect(this.userId);

  final String userId;

  @override
  List<Object?> get props => [userId];
}

class OnMessageSent extends SessionEvent {
  const OnMessageSent(this.chat);

  final ChatModel chat;

  @override
  List<Object?> get props => [chat];
}

class UpdateName extends SessionEvent {
  const UpdateName({required this.name, required this.userId});

  final String name;
  final String userId;

  @override
  List<Object?> get props => [name, userId];
}
