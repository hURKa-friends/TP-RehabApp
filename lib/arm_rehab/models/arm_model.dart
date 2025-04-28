import 'package:flutter/material.dart';

enum SelectedArm {left, right}
enum SelectedPos {shoulder, wrist}

class SelectedOptions {
  static late SelectedArm arm;
  static late SelectedPos pos;
  static late int exercise;
  static late int repetitions;
  static bool startTimer = false;

  SelectedOptions();
}

class Setpoints {
  late final double shoulderBlades0X;
  late final double shoulderBlades0Y;
  late final double shoulderBlades0Z;
  late final double shoulderBlades1X;
  late final double shoulderBlades1Y;
  late final double shoulderBlades1Z;

  late final double chestPress0X;
  late final double chestPress0Y;
  late final double chestPress0Z;
  late final double chestPress1X;
  late final double chestPress1Y;
  late final double chestPress1Z;

  late final double bicepCurls0X;
  late final double bicepCurls0Y;
  late final double bicepCurls0Z;
  late final double bicepCurls1X;
  late final double bicepCurls1Y;
  late final double bicepCurls1Z;

  late final double drinking0X;
  late final double drinking0Y;
  late final double drinking0Z;
  late final double drinking1X;
  late final double drinking1Y;
  late final double drinking1Z;

  Setpoints() {
    switch (SelectedOptions.pos) { // Switch aj podla arm?
      case SelectedPos.shoulder:
        /*shoulderBlades0X = ;
        shoulderBlades0Y = ;
        shoulderBlades0Z = ;
        shoulderBlades1X = ;
        shoulderBlades1Y = ;
        shoulderBlades1Z = ;

        chestPress0X = ;
        chestPress0Y = ;
        chestPress0Z = ;
        chestPress1X = ;
        chestPress1Y = ;
        chestPress1Z = ;

        bicepCurls0X = ;
        bicepCurls0Y = ;
        bicepCurls0Z = ;
        bicepCurls1X = ;
        bicepCurls1Y = ;
        bicepCurls1Z = ;

        drinking0X = ;
        drinking0Y = ;
        drinking0Z = ;
        drinking1X = ;
        drinking1Y = ;
        drinking1Z = ;*/

        break;
      case SelectedPos.wrist:
        /*shoulderBlades0X = ;
        shoulderBlades0Y = ;
        shoulderBlades0Z = ;
        shoulderBlades1X = ;
        shoulderBlades1Y = ;
        shoulderBlades1Z = ;

        chestPress0X = ;
        chestPress0Y = ;
        chestPress0Z = ;
        chestPress1X = ;
        chestPress1Y = ;
        chestPress1Z = ;

        bicepCurls0X = ;
        bicepCurls0Y = ;
        bicepCurls0Z = ;
        bicepCurls1X = ;
        bicepCurls1Y = ;
        bicepCurls1Z = ;

        drinking0X = ;
        drinking0Y = ;
        drinking0Z = ;
        drinking1X = ;
        drinking1Y = ;
        drinking1Z = ;*/

        break;
      };
  }
}

Widget space(double size) {
  return SizedBox(
    height: size,
    width: size,
  );
}

Row exercise(String name, int exerciseNumber, void Function() selectPage) {
  return Row( // Exercise
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Flexible(
        child: Text(
          name,
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