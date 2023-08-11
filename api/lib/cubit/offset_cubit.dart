import 'dart:math';

import 'package:broadcast_bloc/broadcast_bloc.dart';

class OffsetCubit extends BroadcastCubit<List<Point>> {
  // Create an instance with an initial state of 0.
  OffsetCubit() : super([]);

  void addOffset(Point point) {
    emit([...state, point]);
    if (state.length > 200) {
      emit([]);
    }
  }

  void clearOffsets() {
    emit([]);
  }
}
