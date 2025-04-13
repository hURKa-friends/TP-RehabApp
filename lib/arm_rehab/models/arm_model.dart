import 'package:flutter/cupertino.dart';

enum SelectedArm {left, right}
enum SelectedPos {shoulder, wrist}
enum SelectedOrient {frontUp, frontDown, backUp, backDown}

class SelectedOptions {
  static late SelectedArm arm;
  static late SelectedPos pos;
  static late SelectedOrient orient;
  static late int exercise;
  static late int repetitions;

  SelectedOptions();
}

Widget space(double size) {
  return SizedBox(
    height: size,
    width: size,
  );
}

TextStyle headerStyle() {
  return TextStyle(
    fontSize: 27,
    fontWeight: FontWeight.bold,
  );
}

TextStyle buttonTextStyle() {
  return TextStyle(
    fontSize: 20,
  );
}