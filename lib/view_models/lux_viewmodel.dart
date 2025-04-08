import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rehab_app/models/sensor_models.dart';
import 'package:rehab_app/services/external/sensor_service.dart';

class LuxViewModel extends ChangeNotifier {
  late List<LuxSensorData> luxData;
  int index = 0;
  Timer? timer;

  LuxViewModel() {
    luxData = List.empty(growable: true);
  }

  void registerSensorService() {
    SensorService().startLuxDataStream();
    SensorService().registerLuxDataStream(callback: onDataChanged);
    timer = Timer.periodic(const Duration(milliseconds: 50), updateUI);
  }

  void onDataChanged() {
    if (luxData.length > 100) {
      luxData.removeAt(0);
    }
    luxData.add(SensorService().getLuxData());
    index++;
    notifyListeners();
  }

  void updateUI(Timer timer) {
    if (luxData.length > 100) {
      luxData.removeAt(0);
    }
    LuxSensorData data = SensorService().getLuxData();
    luxData.add(
      LuxSensorData(
          lux: data.lux,
          timeStamp: DateTime.now(),
          state: data.state
      )
    );
    index++;
    notifyListeners();
  }

  void onClose() {
    SensorService().stopLuxDataStream();
    luxData = List.empty(growable: true);
  }
}