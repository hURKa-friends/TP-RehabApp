import 'package:flutter/material.dart';
import 'package:rehab_app/services/models/sensor_models.dart';
import 'package:rehab_app/services/sensor_service.dart';

class GyroViewModel extends ChangeNotifier {
  late List<ImuSensorData> imuData;
  late SensorService service;
  int index = 0;

  GyroViewModel() {
    service = SensorService();
    imuData = List.empty(growable: true);
    service.startGyroDataStream(samplingPeriod: Duration(milliseconds: 50));
    service.registerGyroDataStream(callback: onDataChanged);
  }

  void onDataChanged() {
    if (imuData.length > 100) {
      imuData.removeAt(0);
    }
    imuData.add(service.getGyroData());
    index++;
    notifyListeners();
  }
}