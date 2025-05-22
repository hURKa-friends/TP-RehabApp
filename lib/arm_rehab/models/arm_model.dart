import 'dart:math';

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

class Setpoint {
  static late double setpoint0X;
  static late double setpoint0Y;
  static late double setpoint0Z;
  static late double setpoint1X;
  static late double setpoint1Y;
  static late double setpoint1Z;

  Setpoint();
}

class Angles {
  static late double currentAngleX;
  static late double currentAngleY;
  static late double currentAngleZ;

  Angles();
}

class ArmImuData {
  static List<ImuSensorData> userAcclData = List.empty(growable: true);
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

double complementaryFilter(double previousAngle, double gyro, double acclAngle, double alpha, DateTime currentTime, DateTime lastTime) {
  return (1 - alpha) * (previousAngle + gyro * currentTime.difference(lastTime).inMilliseconds / 1000) + alpha * acclAngle;
}

double getAcclRoll(double acclX, double acclY, double acclZ) {
  return atan(acclY / sqrt(pow(acclX, 2) + pow(acclZ, 2)));
}

double getAcclPitch(double acclX, double acclY, double acclZ) {
  return atan(acclX / sqrt(pow(acclY, 2) + pow(acclZ, 2)));
}

double getAcclYaw(double acclX, double acclY, double acclZ) {
  return atan(sqrt(pow(acclX, 2) + pow(acclY, 2)) / acclZ);
}

class Setpoints {
  late final double frontRaises0X;
  late final double frontRaises0Y;
  late final double frontRaises0Z;
  late final double frontRaises1X;
  late final double frontRaises1Y;
  late final double frontRaises1Z;

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

  late final double glassTurning0X;
  late final double glassTurning0Y;
  late final double glassTurning0Z;
  late final double glassTurning1X;
  late final double glassTurning1Y;
  late final double glassTurning1Z;

  Setpoints() {
    switch (SelectedOptions.pos) {
      case SelectedPos.shoulder:
        switch (SelectedOptions.arm) {
          case SelectedArm.right:
            frontRaises0X = -3.5;
            frontRaises0Y = -9.1;
            frontRaises0Z = 0.3;
            frontRaises1X = -9.8;
            frontRaises1Y = -0.1;
            frontRaises1Z = -0.2;

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

            glassTurning0X = -7;
            glassTurning0Y = -6;
            glassTurning0Z = 3.5;
            glassTurning1X = -6.5;
            glassTurning1Y = -7.3;
            glassTurning1Z = 0.7;

            break;
          case SelectedArm.left:
            frontRaises0X = 4;
            frontRaises0Y = -8.8;
            frontRaises0Z = 0.5;
            frontRaises1X = 9.8;
            frontRaises1Y = 0.3;
            frontRaises1Z = 0.1;

            chestPress0X = 4.5;
            chestPress0Y = -7.5;
            chestPress0Z = 4.7;
            chestPress1X = 9.7;
            chestPress1Y = 0.5;
            chestPress1Z = 0.6;

            bicepCurls0X = 2.5;
            bicepCurls0Y = -9.4;
            bicepCurls0Z = -1;
            bicepCurls1X = 2.5;
            bicepCurls1Y = -9.4;
            bicepCurls1Z = 0.8;

            drinking0X = 0.8;
            drinking0Y = -9.5;
            drinking0Z = 1.7;
            drinking1X = 9.8;
            drinking1Y = 0.3;
            drinking1Z = 0.5;

            glassTurning0X = 5.3;
            glassTurning0Y = -7.7;
            glassTurning0Z = 3;
            glassTurning1X = 4.3;
            glassTurning1Y = -8.7;
            glassTurning1Z = -1.1;

            break;
        }

        break;
      case SelectedPos.wrist:
        switch (SelectedOptions.arm) {
          case SelectedArm.right:
            frontRaises0X = -4;
            frontRaises0Y = -8.9;
            frontRaises0Z = -0.1;
            frontRaises1X = -8.7;
            frontRaises1Y = 0.6;
            frontRaises1Z = 4.6;

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

            drinking0X = -8.9;
            drinking0Y = 2.3;
            drinking0Z = -3.3;
            drinking1X = -1.7;
            drinking1Y = 7.5;
            drinking1Z = 5.6;

            glassTurning0X = -3;
            glassTurning0Y = -6.1;
            glassTurning0Z = 6.7;
            glassTurning1X = -8.1;
            glassTurning1Y = -5.5;
            glassTurning1Z = 1;

            break;
          case SelectedArm.left:
            frontRaises0X = 3.5;
            frontRaises0Y = -8.9;
            frontRaises0Z = 2.2;
            frontRaises1X = 6.3;
            frontRaises1Y = 0.3;
            frontRaises1Z = 7;

            chestPress0X = 7.9;
            chestPress0Y = 3.5;
            chestPress0Z = 4.5;
            chestPress1X = 6.5;
            chestPress1Y = 0.5;
            chestPress1Z = 7.3;

            bicepCurls0X = 4.7;
            bicepCurls0Y = -8;
            bicepCurls0Z = -3;
            bicepCurls1X = 4;
            bicepCurls1Y = 8.5;
            bicepCurls1Z = -2.6;

            drinking0X = 9.4;
            drinking0Y = 2.1;
            drinking0Z = -2;
            drinking1X = -1.1;
            drinking1Y = 7.7;
            drinking1Z = 6.5;

            glassTurning0X = 2.8;
            glassTurning0Y = -8.2;
            glassTurning0Z = 4.2;
            glassTurning1X = 6.7;
            glassTurning1Y = -7.1;
            glassTurning1Z = -1.1;

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