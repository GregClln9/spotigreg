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
  x1,
  x2,
  x3,
}
