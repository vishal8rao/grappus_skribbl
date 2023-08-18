import 'package:api/cubit/offset_cubit.dart';
import 'package:api/session/bloc/session_bloc.dart';
import 'package:dart_frog/dart_frog.dart';

import '../headers/headers.dart';

final _offsetCubit = OffsetCubit();
final _sessionBloc = SessionBloc();

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(provider<SessionBloc>((context) => _sessionBloc))
      // .use(provider<OffsetCubit>((context) => _offsetCubit))
      .use(corsHeaders());
}
