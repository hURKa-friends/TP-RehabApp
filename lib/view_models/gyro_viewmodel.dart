import 'package:flutter/material.dart';
import 'package:rehab_app/models/sensor_models.dart';
import 'package:rehab_app/services/external/sensor_service.dart';

class GyroViewModel extends ChangeNotifier {
  late List<ImuSensorData> imuData;
  int index = 0;

  GyroViewModel() {
    imuData = List.empty(growable: true);
  }

  void registerSensorService() {
    SensorService().startGyroDataStream(samplingPeriod: Duration(milliseconds: 50));
    SensorService().registerGyroDataStream(callback: (ImuSensorData data) => onDataChanged(data));
  }

  void onDataChanged(ImuSensorData data) {
    if (imuData.length > 100) {
      imuData.removeAt(0);
    }
    imuData.add(data);
    index++;
    notifyListeners();
  }

  void onClose() {
    SensorService().stopGyroDataStream();
    imuData = List.empty(growable: true);
  }
}