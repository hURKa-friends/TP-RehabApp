import 'package:flutter/material.dart';
import 'package:rehab_app/services/models/sensor_models.dart';
import 'package:rehab_app/services/sensor_service.dart';

class MagViewModel extends ChangeNotifier {
  late List<ImuSensorData> imuData;
  late SensorService service;
  int index = 0;

  MagViewModel() {
    service = SensorService();
    imuData = List.empty(growable: true);
    service.startMagDataStream(samplingPeriod: Duration(milliseconds: 50));
    service.registerMagDataStream(callback: onDataChanged);
  }

  void onDataChanged() {
    if (imuData.length > 100) {
      imuData.removeAt(0);
    }
    imuData.add(service.getMagData());
    index++;
    notifyListeners();
  }
}