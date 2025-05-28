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
    ArmImuData.acclData = List.empty(growable: true);
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

  double calculateAverage(List<double> values) {
    double average = 0;

    for (double value in values) {
      average += value;
    }

    average /= values.length;

    return average;
  }

  double calculateVariance(List<double> values, double average) {
    double variance = 0;

    for (double value in values) {
      variance += pow((value - average), 2);
    }

    variance /= values.length;

    return variance;
  }

  double calculateSD(List<AngleGraph> angles) {
    double sd = (calculateVariance(angles.map((angle) => angle.angleX).toList(), calculateAverage(angles.map((angle) => angle.angleX).toList()))
        + calculateVariance(angles.map((angle) => angle.angleY).toList(), calculateAverage(angles.map((angle) => angle.angleY).toList()))
        + calculateVariance(angles.map((angle) => angle.angleZ).toList(), calculateAverage(angles.map((angle) => angle.angleZ).toList()))) / 3;

    return sd;
  }

  double calculateAC(List<ImuSensorData> acclData) {
    double ac = 0;

    for (ImuSensorData data in acclData) {
      ac += sqrt(pow(data.x, 2) + pow(data.y, 2) + pow(data.z, 2));
    }

    ac /= acclData.length;

    return ac;
  }

  double calculateWAC() {
    return calculateSD(Angles.angles) * calculateAC(ArmImuData.acclData);
  }

  double differentiate(double lastValue, double currentValue, DateTime lastTimestamp, DateTime currentTimestamp) {
    double diff = (currentValue - lastValue) * currentTimestamp.difference(lastTimestamp).inMilliseconds / 1000;

    return diff;
  }

  double calculateLDLJ(List<ImuSensorData> acclData) {
    double ldlj = 0;
    double timeDiff = acclData.last.timeStamp.difference(acclData.first.timeStamp).inMilliseconds / 1000;
    double x, y, z;

    x = acclData.map((data) => data.x.abs()).toList().reduce(max);
    y = acclData.map((data) => data.y.abs()).toList().reduce(max);
    z = acclData.map((data) => data.z.abs()).toList().reduce(max);

    double aPeak = sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2)) - sqrt(pow(calculateAverage(acclData.map((data) => data.x).toList()), 2) + pow(calculateAverage(acclData.map((data) => data.y).toList()), 2) + pow(calculateAverage(acclData.map((data) => data.z).toList()), 2));


    for (int i = 1; i < acclData.length; i++) {
      ldlj += pow(differentiate(acclData[i - 1].x, acclData[i].x, acclData[i - 1].timeStamp, acclData[i].timeStamp), 2)
            + pow(differentiate(acclData[i - 1].y, acclData[i].y, acclData[i - 1].timeStamp, acclData[i].timeStamp), 2)
            + pow(differentiate(acclData[i - 1].z, acclData[i].z, acclData[i - 1].timeStamp, acclData[i].timeStamp), 2);
    }

    ldlj /= (acclData.length - 1);

    ldlj *= timeDiff / pow(aPeak, 2);
    //print(timeDiff);
    //print(aPeak);
    //print(ldlj);
    ldlj = -log(ldlj);

    return ldlj;
  }

  double calculateMI(List<ImuSensorData> acclData) {
    double mi = 0;

    for (ImuSensorData data in acclData) {
      mi += sqrt(pow(data.x, 2) + pow(data.y, 2) + pow(data.z, 2)) / 9.81;
    }

    mi /= acclData.length;
    
    return mi;
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