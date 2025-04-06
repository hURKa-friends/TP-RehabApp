import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class ShoulderExercise {
  final Map<List<PoseLandmarkType>, AngleLimitsDeg> jointLimits;
  final double repetitions;

  ShoulderExercise({
    required this.jointLimits,
    required this.repetitions,
  });
}

class ShoulderForwardElevationActive extends ShoulderExercise {

  List<PoseLandmarkType> rightShoulderPoints = [
    PoseLandmarkType.rightHip,
    PoseLandmarkType.rightShoulder,
    PoseLandmarkType.rightElbow,
  ];

  ShoulderForwardElevationActive()
    : super(jointLimits: Map<>,
          repetitions: 5,
  );
}

class AngleLimitsDeg {
  final double upper;
  final double lower;
  final double tolerance;

  AngleLimitsDeg({
    required this.upper,
    required this.lower,
    required this.tolerance,
  });
}