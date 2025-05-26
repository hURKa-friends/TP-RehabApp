// lib/rehabilitacia/view_models_rehab/exercise_view_model.dart
import 'package:flutter/material.dart';
import 'package:rehab_app/view_models/gyro_viewmodel.dart';
import 'package:rehab_app/models/sensor_models.dart';
import 'package:rehab_app/rehabilitacia/services/exercise_logic_service.dart';

class ExerciseViewModel extends ChangeNotifier {
  final GyroViewModel gyroViewModel;
  final String exerciseType;

  ExerciseViewModel({
    required this.exerciseType,
    required this.gyroViewModel,
  });

  String result = "Prebieha...";

  void evaluate() {
    final data = gyroViewModel.imuData;
    bool success = false;

    switch (exerciseType) {
      case "chair":
        success = ExerciseLogicService.evaluateChair(data);
        break;
      case "bed":
        success = ExerciseLogicService.evaluateBed(data);
        break;
      case "Squat":
        success = ExerciseLogicService.evaluateSquat(data);
        break;
    }

    result = success ? "Successfully completed!" : "Failed to detect exercise.";
    notifyListeners();
  }
}
