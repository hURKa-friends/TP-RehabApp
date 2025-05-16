import 'package:flutter/material.dart';

class ExerciseBallModel{

  String objectType; // 1 = ball, 2 = cube, 3 = cylinder
  bool showObject = false;
  List<double?> wightAndHeight = List.filled(2, null);
  Offset ?currentPosition;
  List<Offset> trajectoryOfObject = [];

  ExerciseBallModel({
    required this.objectType,
  });
}