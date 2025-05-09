import 'package:flutter/material.dart';
import 'package:rehab_app/models/sensor_models.dart';

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

class ArmImuData {
  static List<ImuSensorData> acclData = List.empty(growable: true);
  static List<ImuSensorData> gyroData = List.empty(growable: true);
}

class NormalizeSensorValues {
  late double gyroMaxX;
  late double gyroMaxY;
  late double gyroMaxZ;
  late double acclMaxX;
  late double acclMaxY;
  late double acclMaxZ;

  NormalizeSensorValues(
      this.gyroMaxX,
      this.gyroMaxY,
      this.gyroMaxZ,
      this.acclMaxX,
      this.acclMaxY,
      this.acclMaxZ,
  );
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
        switch (SelectedOptions.arm) {
          case SelectedArm.right:
            /*shoulderBlades0X = ;
            shoulderBlades0Y = ;
            shoulderBlades0Z = ;
            shoulderBlades1X = ;
            shoulderBlades1Y = ;
            shoulderBlades1Z = ;*/

            chestPress0X = -5.3;
            chestPress0Y = -7.1;
            chestPress0Z = 4;
            chestPress1X = -9.8;
            chestPress1Y = -0.7;
            chestPress1Z = 0.1;

            bicepCurls0X = -1.9;
            bicepCurls0Y = -9.6;
            bicepCurls0Z = 0;
            bicepCurls1X = -2.2;
            bicepCurls1Y = -9.4;
            bicepCurls1Z = 1.2;

            drinking0X = -2.9;
            drinking0Y = -9.3;
            drinking0Z = -0.4;
            drinking1X = -8.7;
            drinking1Y = -4.5;
            drinking1Z = -1;

            break;
          case SelectedArm.left:

            break;
        }

        break;
      case SelectedPos.wrist:
        switch (SelectedOptions.arm) {
          case SelectedArm.right:
            /*shoulderBlades0X = ;
            shoulderBlades0Y = ;
            shoulderBlades0Z = ;
            shoulderBlades1X = ;
            shoulderBlades1Y = ;
            shoulderBlades1Z = ;*/

            chestPress0X = -9;
            chestPress0Y = 3.3;
            chestPress0Z = 2.1;
            chestPress1X = -9.7;
            chestPress1Y = -0.2;
            chestPress1Z = 0.1;

            bicepCurls0X = -3.8;
            bicepCurls0Y = -9;
            bicepCurls0Z = -1.2;
            bicepCurls1X = -4.9;
            bicepCurls1Y = 7.6;
            bicepCurls1Z = -2.5;

            drinking0X = -3.5;
            drinking0Y = -9.1;
            drinking0Z = 0.3;
            drinking1X = -9.8;
            drinking1Y = -0.1;
            drinking1Z = -0.2;

            break;
          case SelectedArm.left:

            break;
        }

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