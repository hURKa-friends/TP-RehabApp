import 'dart:async';

import 'package:flutter/material.dart';

class ExerciseStartViewModel extends ChangeNotifier {
  late Timer _timer;
  late bool _isTimerActive;
  late int _timerCount;

  ExerciseStartViewModel() {
    // Default constructor
  }

  Future<void> onInit() async {
    // Here you can call ViewModel initialization code.
    _timer = Timer.periodic(Duration(seconds: 1), _timerFinish);
    _isTimerActive = true;
    _timerCount = 5;
  }

  void onClose() {
    // Here you can call ViewModel disposal code.
    //_timer.cancel();
    //_isTimerActive = false;
  }

  void _timerFinish(Timer timer) {
    _timerCount--;
    // BEEP

    if (_timerCount < 1) {
      _timer.cancel();
      _isTimerActive = false;
      // LONG BEEP
    }

    notifyListeners();
  }

  bool get isTimerActive => _isTimerActive;
  int get timerCount => _timerCount;
}