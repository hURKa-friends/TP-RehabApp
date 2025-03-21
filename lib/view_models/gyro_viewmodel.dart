import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rehab_app/services/sensor_models.dart';
import 'package:rehab_app/services/sensor_service.dart';

class GyroViewModel extends ChangeNotifier {
  late List<ImuSensorData> imuData;
  late SensorService service;
  int index = 0;
  Timer? timer;

  GyroViewModel() {
    service = SensorService();
    imuData = List.empty(growable: true);
    service.startGyroDataStream(samplingPeriod: Duration(milliseconds: 200));
    service.registerGyroDataStream(samplingPeriod: Duration(milliseconds: 200), callback: onDataChanged);
    timer = Timer.periodic(const Duration(milliseconds: 50), updateUI);
  }

  void onDataChanged() {
    if (imuData.length > 100) {
      imuData.removeAt(0);
    }
    imuData.add(service.getGyroData());
    index++;
    notifyListeners();
  }

  void updateUI(Timer timer) {
    notifyListeners();
  }
}