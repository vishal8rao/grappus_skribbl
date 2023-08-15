import 'package:api/cubit/offset_cubit.dart';
import 'package:dart_frog/dart_frog.dart';

final _offsetCubit = OffsetCubit();
Handler middleware(Handler handler) {
  return handler.use(provider<OffsetCubit>((context) => _offsetCubit));
}
