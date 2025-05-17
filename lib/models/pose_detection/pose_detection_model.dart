import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';


enum ExerciseType {
  shoulderAbductionActive,
  shoulderForwardElevationActive,
  shoulderExternalRotation,
}
enum ArmSelection { none, left, right }

// part of AngleLimitsDeg (enum cannot be declared in class)
enum LimitType{
  inLimits,   // must be in limits to return true
  reachLimits,  // must reach limits to return true
}


abstract class ShoulderExercise {
  final ExerciseType type;
  final List<List<PoseLandmarkType>> jointAngleLocations;
  final List<AngleLimitsDeg> jointLimits;
  final int targetRepetitions;
  final ArmSelection arm;

  bool correctRepetition = false;
  bool outOfLimits = true;

  ShoulderExercise({
    required this.type,
    required this.jointAngleLocations,
    required this.jointLimits,
    required this.targetRepetitions,
    required this.arm,
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
  static ShoulderExercise create(ExerciseType type, int numberOfRepetitions, ArmSelection arm) {
    switch (type) {
      case ExerciseType.shoulderAbductionActive:
        return ShoulderAbductionActive(reps: numberOfRepetitions, arm: arm);
      case ExerciseType.shoulderForwardElevationActive:
        return ShoulderForwardElevationActive(reps: numberOfRepetitions, arm: arm);
      case ExerciseType.shoulderExternalRotation:
      // return ShoulderExternalRotation(reps: numberOfRepetitions, arm: arm);
        throw Exception('ShoulderExternalRotation not implemented'); // for now...
      default:
        throw Exception('Unsupported exercise type: $type');
    }
  }
}


class ShoulderAbductionActive extends ShoulderExercise {
  static List<PoseLandmarkType> _getShoulderPoints(ArmSelection arm) {
    return arm == ArmSelection.left
        ? [PoseLandmarkType.leftHip, PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow]
        : [PoseLandmarkType.rightHip, PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow];
  }

  static List<PoseLandmarkType> _getElbowPoints(ArmSelection arm) {
    return arm == ArmSelection.left
        ? [PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist]
        : [PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist];
  }

  static List<List<PoseLandmarkType>> _getAnglePoints(ArmSelection arm) {
    return [
      _getShoulderPoints(arm),
      _getElbowPoints(arm),
    ];
  }

  static List<AngleLimitsDeg> limits = [
    AngleLimitsDeg(
      limitType: LimitType.reachLimits,
      upper: 90,
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

  ShoulderAbductionActive({required int reps, required super.arm})
      : super(
    type: ExerciseType.shoulderAbductionActive,
    jointAngleLocations: _getAnglePoints(arm),
    jointLimits: limits,
    targetRepetitions: reps,
  );
}


class ShoulderForwardElevationActive extends ShoulderExercise {
  static List<PoseLandmarkType> _getShoulderPoints(ArmSelection arm) {
    return arm == ArmSelection.left
        ? [PoseLandmarkType.leftHip, PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow]
        : [PoseLandmarkType.rightHip, PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow];
  }

  static List<PoseLandmarkType> _getElbowPoints(ArmSelection arm) {
    return arm == ArmSelection.left
        ? [PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist]
        : [PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist];
  }

  static List<List<PoseLandmarkType>> _getAnglePoints(ArmSelection arm) {
    return [
      _getShoulderPoints(arm),
      _getElbowPoints(arm),
    ];
  }

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

  ShoulderForwardElevationActive({required int reps, required super.arm})
      : super(
    type: ExerciseType.shoulderForwardElevationActive,
    jointAngleLocations: _getAnglePoints(arm),
    jointLimits: limits,
    targetRepetitions: reps,
  );
}
