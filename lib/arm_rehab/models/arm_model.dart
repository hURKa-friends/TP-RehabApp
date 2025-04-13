import 'package:flutter/material.dart';

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

Row exercise(String name, String description, int exerciseNumber, void Function() selectPage) {
  return Row( // Exercise
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Flexible(
        child: Text(
          name,
        ),
      ),
      space(15),
      Flexible(
        child: Text(
          description,
        ),
      ),
      space(20),
      ElevatedButton(
        onPressed: () {
          selectPage();
          SelectedOptions.exercise = exerciseNumber;
        },
        child: Text(
          "Select",
          style: buttonTextStyle(),
        ),
      ),
    ],
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