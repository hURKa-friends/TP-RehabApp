import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class ShoulderExercise {
  final List<List<PoseLandmarkType>> jointAngleLocations;
  final List<AngleLimitsDeg> jointLimits;
  final double repetitions;

  ShoulderExercise({
    required this.jointAngleLocations,
    required this.jointLimits,
    required this.repetitions,
  });
}

class ShoulderForwardElevationActive extends ShoulderExercise {

  static List<PoseLandmarkType> rightShoulderPoints = [
    PoseLandmarkType.rightHip,
    PoseLandmarkType.rightShoulder,
    PoseLandmarkType.rightElbow,
  ];

  static List<List<PoseLandmarkType>> anglePoints = [
    rightShoulderPoints,
  ];

  static List<AngleLimitsDeg> limits = [
    AngleLimitsDeg(
        upper: 180,
        lower: 20,
        tolerance: 10,
        ),
  ];

  ShoulderForwardElevationActive()
    : super(jointAngleLocations: anglePoints,
            jointLimits: limits,
            repetitions: 5,
    ); //super
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