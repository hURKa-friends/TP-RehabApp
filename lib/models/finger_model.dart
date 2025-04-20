import 'package:flutter/material.dart';

class FingerModel{

  String fingerName; // 1 = index, 2 = middle, 3 = ring, 4 = pinky, 5 = thumb
  bool pointerFingerActive = false;
  Map<int, Offset> pointerFinger = {};
  List<Offset> pointerFingerTrajectory = [];

  FingerModel({
    required this.fingerName,
    required this.pointerFingerActive,
    required this.pointerFinger,
    required this.pointerFingerTrajectory,
  });

  //Individual finger data
  /*
  bool pointerIndexActive = false;
  Map<int, Offset> pointerIndex = {};
  List<Offset> pointerIndexTrajectory = [];

  bool pointerMiddleActive = false;
  Map<int, Offset> pointerMiddle = {};
  List<Offset> pointerMiddleTrajectory = [];

  bool pointerRingActive = false;
  Map<int, Offset> pointerRing = {};
  List<Offset> pointerRingTrajectory = [];

  bool pointerPinkyActive = false;
  Map<int, Offset> pointerPinky = {};
  List<Offset> pointerPinkyTrajectory = [];

  bool pointerThumbActive = false;
  Map<int, Offset> pointerThumb = {};
  List<Offset> pointerThumbTrajectory = [];
  */
  /*
  FingerModel({
    required this.numberOfFingers,
    required this.hand,
    required this.offsetOfFinger,
    required this.displayOffset,
  });
   */

  /*
  void initializeTrajectories() {
    pointerIndexTrajectory.add(Offset.zero);
    pointerMiddleTrajectory.add(Offset.zero);
    pointerRingTrajectory.add(Offset.zero);
    pointerPinkyTrajectory.add(Offset.zero);
    pointerThumbTrajectory.add(Offset.zero);
  }
  */
}