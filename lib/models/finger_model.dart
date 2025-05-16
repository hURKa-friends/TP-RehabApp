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
}