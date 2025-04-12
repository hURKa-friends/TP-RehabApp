import 'package:flutter/material.dart';
import 'package:rehab_app/models/sensor_models.dart';
import 'package:rehab_app/services/external/sensor_service.dart';

class AcclViewModel extends ChangeNotifier {
  late List<ImuSensorData> imuData;
  int index = 0;

  AcclViewModel() {
    imuData = List.empty(growable: true);
  }

  void registerSensorService() {
    SensorService().startAcclDataStream(samplingPeriod: Duration(milliseconds: 50));
    SensorService().registerAcclDataStream(callback: (ImuSensorData data) => onDataChanged(data));
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
    SensorService().stopAcclDataStream();
    imuData = List.empty(growable: true);
  }
}