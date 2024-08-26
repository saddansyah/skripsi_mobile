import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class CountdownTimerController extends FamilyNotifier<num, num> {
  num initialTime = 30;
  bool isRunning = false;
  Timer? timer;

  @override
  num build(num arg) {
    initialTime = arg;
    return initialTime;
  }

  void setTimer(num time) {
    initialTime = time;
    state = time;
    isRunning = true;
  }

  void pauseTimer() {
    timer?.cancel();
    timer = null;
    isRunning = false;
  }

  void resetTimer() {
    timer?.cancel();
    timer = null;
    state = initialTime;
    isRunning = false;
  }

  void startTimer() {
    if (timer != null || state == 0) return;

    isRunning = true;
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state > 0) {
        state--;
      } else {
        timer?.cancel();
        timer = null;
        isRunning = false;
      }
    });
  }
}

final timerControllerProvider =
    NotifierProvider.family<CountdownTimerController, num, num>(
        CountdownTimerController.new);
