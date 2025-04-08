import 'package:flutter/material.dart';
import 'package:rehab_app/models/sensor_models.dart';
import 'package:rehab_app/services/external/sensor_service.dart';

class MagViewModel extends ChangeNotifier {
  late List<ImuSensorData> imuData;
  int index = 0;

  MagViewModel() {
    imuData = List.empty(growable: true);
  }

  void registerSensorService() {
    SensorService().startMagDataStream(samplingPeriod: Duration(milliseconds: 50));
    SensorService().registerMagDataStream(callback: onDataChanged);
  }

  void onDataChanged() {
    if (imuData.length > 100) {
      imuData.removeAt(0);
    }
    imuData.add(SensorService().getMagData());
    index++;
    notifyListeners();
  }

  void onClose() {
    SensorService().stopMagDataStream();
    imuData = List.empty(growable: true);
  }
}