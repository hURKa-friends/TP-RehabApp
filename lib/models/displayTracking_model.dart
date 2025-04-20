import 'package:flutter/material.dart';

class DisplayTrackingModel {
  //Variables for tracking
  int numberOfFingers; // sets the number of fingers that it will use
  bool identification;
  String hand; // left or right
  Offset offsetOfFinger; //Offset(80, 80) - finger dead zone to be back assigned
  Offset displayOffset; //Offset(50, 50) - display offset to compensate widgets
  bool fingersDetected = false;
  bool fingersBackAssignment = false;

  Map<int, Offset> activeFingers = {};
  Map<int, List<Offset>> pointerPaths = {};

  DisplayTrackingModel({
    required this.numberOfFingers,
    required this.hand,
    required this.identification,
    required this.fingersBackAssignment,
    required this.offsetOfFinger,
    required this.displayOffset,
  });
}