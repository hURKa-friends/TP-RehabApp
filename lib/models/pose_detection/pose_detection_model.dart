import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';


enum ExerciseType {
  shoulderAbductionActive,
  shoulderForwardElevationActive,
  shoulderExternalRotation,
}


// part of AngleLimitsDeg (enum cannot be declared in class)
enum LimitType{
  inLimits,   // must be in limits to return true
  reachLimits,  // must reach limits to return true
}


abstract class ShoulderExercise {
  final ExerciseType type;
  final List<List<PoseLandmarkType>> jointAngleLocations;
  final List<AngleLimitsDeg> jointLimits;
  final double repetitions;
  bool correctRepetition = false;
  bool outOfLimits = true;

  ShoulderExercise({
    required this.type,
    required this.jointAngleLocations,
    required this.jointLimits,
    required this.repetitions,
    });
}


class AngleLimitsDeg {
  final LimitType limitType;
  final double upper;
  final double lower;
  final double tolerance;

  bool reachedLow = false;
  bool reachedHigh = false;

  AngleLimitsDeg({
    required this.limitType,
    required this.upper,
    required this.lower,
    required this.tolerance,
  });
}


class ExerciseFactory {
  static ShoulderExercise create(ExerciseType type) {
    switch (type) {
      case ExerciseType.shoulderAbductionActive:
        return ShoulderAbductionActive();
      case ExerciseType.shoulderForwardElevationActive:
        return ShoulderForwardElevationActive();
      default:
        throw Exception('Unsupported exercise type: $type');
    }
  }
}


class ShoulderAbductionActive extends ShoulderExercise {

  static List<PoseLandmarkType> rightShoulderPoints = [
    PoseLandmarkType.rightHip,
    PoseLandmarkType.rightShoulder,
    PoseLandmarkType.rightElbow,
  ];
  static List<PoseLandmarkType> rightElbowPoints = [
    PoseLandmarkType.rightShoulder,
    PoseLandmarkType.rightElbow,
    PoseLandmarkType.rightWrist,
  ];

  static List<List<PoseLandmarkType>> anglePoints = [
    rightShoulderPoints,
    rightElbowPoints,
  ];

  static List<AngleLimitsDeg> limits = [
    AngleLimitsDeg(
        limitType: LimitType.reachLimits,
        upper: 180,
        lower: 20,
        tolerance: 5,
        ),
    AngleLimitsDeg(
        limitType: LimitType.inLimits,
        upper: 180,
        lower: 180,
        tolerance: 15,
        ),
  ];

  ShoulderAbductionActive()
    : super(type: ExerciseType.shoulderAbductionActive,
            jointAngleLocations: anglePoints,
            jointLimits: limits,
            repetitions: 3,
    ); //super
}


class ShoulderForwardElevationActive extends ShoulderExercise {

  static List<PoseLandmarkType> rightShoulderPoints = [
    PoseLandmarkType.rightHip,
    PoseLandmarkType.rightShoulder,
    PoseLandmarkType.rightElbow,
  ];
  static List<PoseLandmarkType> rightElbowPoints = [
    PoseLandmarkType.rightShoulder,
    PoseLandmarkType.rightElbow,
    PoseLandmarkType.rightWrist,
  ];

  static List<List<PoseLandmarkType>> anglePoints = [
    rightShoulderPoints,
    rightElbowPoints,
  ];

  static List<AngleLimitsDeg> limits = [
    AngleLimitsDeg(
      limitType: LimitType.reachLimits,
      upper: 170,
      lower: 20,
      tolerance: 20,
    ),
    AngleLimitsDeg(
      limitType: LimitType.inLimits,
      upper: 170,
      lower: 170,
      tolerance: 20,
    ),
  ];

  ShoulderForwardElevationActive()
      : super(type: ExerciseType.shoulderForwardElevationActive,
    jointAngleLocations: anglePoints,
    jointLimits: limits,
    repetitions: 5,
  ); //super
}
