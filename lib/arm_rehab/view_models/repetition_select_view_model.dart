import 'package:flutter/material.dart';

class RepetitionSelectViewModel extends ChangeNotifier {
  bool _validValue = false;
  late int _repetitions;

  RepetitionSelectViewModel() {
    // Default constructor
  }

  Future<void> onInit() async {
    // Here you can call ViewModel initialization code.
  }

  void onClose() {
    // Here you can call ViewModel disposal code.
  }

  void parseInput(String input) {
    int? reps = int.tryParse(input);

    if (reps == null || reps < 1 || reps > 100) {
      _validValue = false;

      notifyListeners();

      return;
    }

    print("Num of reps: $reps");
    _repetitions = reps;
    _validValue = true;

    notifyListeners();
  }

  bool get validValue => _validValue;
  int get repetitions => _repetitions;
}