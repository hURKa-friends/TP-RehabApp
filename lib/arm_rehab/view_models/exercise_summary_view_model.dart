import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rehab_app/arm_rehab/models/arm_model.dart';
import 'package:rehab_app/models/sensor_models.dart';

import 'package:rehab_app/services/page_management/models/stateless_page_model.dart';
import 'package:rehab_app/services/page_management/view_models/page_navigator_view_model.dart';

class ExerciseSummaryViewModel extends ChangeNotifier {
  final double imageSize = 150;

  ExerciseSummaryViewModel() {
    // Default constructor
  }

  Future<void> onInit() async {
    // Here you can call ViewModel initialization code.
  }

  void onClose() {
    // Here you can call ViewModel disposal code.
    ArmImuData.userAcclData = List.empty(growable: true);
    ArmImuData.gyroData = List.empty(growable: true);
    Angles.angles = List.empty(growable: true);
  }

  double calculateDAV(List<ImuSensorData> userAcclData) { // Difference Acceleration Vector
    double dav = 0;

    for (ImuSensorData data in userAcclData) {
      dav += sqrt(pow(data.x, 2) + pow(data.y, 2) + pow(data.z, 2));
    }

    dav /= userAcclData.length;

    return dav;
  }

  double getMin(List<AngleGraph> angles, List<ImuSensorData> imuData, int param) {
    double x, y, z;

    switch (param) {
      case 1:
        x = angles.map((angle) => angle.angleX).toList().reduce(min);
        y = angles.map((angle) => angle.angleY).toList().reduce(min);
        z = angles.map((angle) => angle.angleZ).toList().reduce(min);

        break;
      case 2:
        x = imuData.map((data) => data.x).toList().reduce(min);
        y = imuData.map((data) => data.y).toList().reduce(min);
        z = imuData.map((data) => data.z).toList().reduce(min);

        break;
      default:
        x = -20;
        y = -20;
        z = -20;

        break;
    }

    return [x, y, z].reduce(min);
  }

  double getMax(List<AngleGraph> angles, List<ImuSensorData> imuData, int param) {
    double x, y, z;

    switch (param) {
      case 1:
        x = angles.map((angle) => angle.angleX).toList().reduce(max);
        y = angles.map((angle) => angle.angleY).toList().reduce(max);
        z = angles.map((angle) => angle.angleZ).toList().reduce(max);

        break;
      case 2:
        x = imuData.map((data) => data.x).toList().reduce(max);
        y = imuData.map((data) => data.y).toList().reduce(max);
        z = imuData.map((data) => data.z).toList().reduce(max);

        break;
      default:
        x = 20;
        y = 20;
        z = 20;

        break;
    }

    return [x, y, z].reduce(max);
  }

  void selectPage(BuildContext context, StatelessPage page) {
    var navigatorViewModel = Provider.of<PageNavigatorViewModel>(context, listen: false);
    navigatorViewModel.selectPage(context, page);
  }
}