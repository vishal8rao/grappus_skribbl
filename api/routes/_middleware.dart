import 'package:api/chat/chat_bloc.dart';
import 'package:api/session/bloc/session_bloc.dart';
import 'package:dart_frog/dart_frog.dart';

import '../headers/headers.dart';

final _sessionBloc = SessionBloc();
final _chatCubit = ChatCubit();

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(provider<SessionBloc>((context) => _sessionBloc))
      .use(provider<ChatCubit>((context) => _chatCubit))
      .use(corsHeaders());
}
