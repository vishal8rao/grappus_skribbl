part of 'session_bloc.dart';

class SessionState extends Equatable {
  const SessionState({
    this.room = const Room(),
  });

  final Room room;

  SessionState copyWith({Room? room}) {
    return SessionState(
      room: room ?? this.room,
    );
  }

  @override
  String toString() {
    return jsonEncode(room.toJson());
  }

  @override
  List<Object?> get props => [room];
}
