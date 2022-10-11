import 'package:flutter/foundation.dart';

class SpeedButtonNotifier extends ValueNotifier<SpeedState> {
  SpeedButtonNotifier() : super(_initialValue);
  static const _initialValue = SpeedState.x1;

  void nextState(SpeedState newState) {
    value = newState;
  }

  List<String> speedState() {
    List<String> list = [];
    for (var values in SpeedState.values) {
      list.add(values.name.toString());
    }
    return list;
  }
}

enum SpeedState {
  x0v25,
  x0v5,
  x0v75,
  x1,
  x1v25,
  x1v5,
  x1v75,
  x2,
}
