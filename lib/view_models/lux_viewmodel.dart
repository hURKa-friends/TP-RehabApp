import 'package:flutter/material.dart';
import 'package:rehab_app/services/sensor_models.dart';
import 'package:rehab_app/services/sensor_service.dart';

class LuxViewModel extends ChangeNotifier {
  late List<LuxSensorData> luxData;
  late SensorService service;
  int index = 0;

  LuxViewModel() {
    service = SensorService();
    luxData = List.empty(growable: true);
    service.startLuxDataStream();
    service.registerLuxDataStream(callback: onDataChanged);
  }

  void onDataChanged() {
    if (luxData.length > 100) {
      luxData.removeAt(0);
    }
    luxData.add(service.getLuxData());
    index++;
    notifyListeners();
  }

}