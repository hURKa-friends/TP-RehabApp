import 'package:flutter/material.dart';

class FingerModel{
  /*
  //Variables for tracking
  int numberOfFingers; // sets the number of fingers that it will use
  String hand; // left or right
  Offset offsetOfFinger; //Offset(80, 80)
  Offset displayOffset; //Offset(50, 50)
  bool fingerDetected = false;

  Map<int, Offset> activeFingers = {};
  Map<int, List<Offset>> pointerPaths = {};
  */
  String fingerName;
  bool pointerFingerActive = false;
  Map<int, Offset> pointerFinger = {};
  List<Offset> pointerFingerTrajectory = [];

  //Individual finger data
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

  /*
  FingerModel({
    required this.numberOfFingers,
    required this.hand,
    required this.offsetOfFinger,
    required this.displayOffset,
  });
   */
  FingerModel({
    required this.fingerName,
    required this.pointerFingerActive,
    required this.pointerFinger,
    required this.pointerFingerTrajectory,
  });
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