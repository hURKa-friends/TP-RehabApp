import 'package:flutter/material.dart';
import 'package:rehab_app/services/sensor_service.dart';
import 'package:rehab_app/services/models/sensor_models.dart';

class MotionDetectionViewModel extends ChangeNotifier {

  ImuSensorData _acclData = ImuSensorData(
    x: 0,
    y: 0,
    z: 0,
    timeStamp: DateTime.now(),
    state: SensorState.off,
  );
  ImuSensorData _gyroData = ImuSensorData(
    x: 0,
    y: 0,
    z: 0,
    timeStamp: DateTime.now(),
    state: SensorState.off,
  );

  bool _sensorsRunning = false;
  List<Offset> _touchPoints = [];

  ImuSensorData get acclData => _acclData;
  ImuSensorData get gyroData => _gyroData;
  bool get sensorsRunning => _sensorsRunning;
  List<Offset> get touchPoints => _touchPoints;

  // Methods for handling touch points
  void addTouchPoint(Offset point) {
    _touchPoints.add(point);
    notifyListeners();
  }

  void clearTouchPoints() {
    _touchPoints.clear();
    notifyListeners();
  }

  void startSensors() {
    SensorService().startAcclDataStream(samplingPeriod: Duration(milliseconds: 50));
    SensorService().startGyroDataStream(samplingPeriod: Duration(milliseconds: 50));

    SensorService().registerAcclDataStream(callback: _updateAcclData);
    SensorService().registerGyroDataStream(callback: _updateGyroData);

    _sensorsRunning = true;
    notifyListeners();
  }

  void stopSensors() {
    SensorService().stopAcclDataStream();
    SensorService().stopGyroDataStream();

    _sensorsRunning = false;
    notifyListeners();
  }

  void _updateAcclData() {
    _acclData = SensorService().getAcclData();
    notifyListeners();
  }

  void _updateGyroData() {
    _gyroData = SensorService().getGyroData();
    notifyListeners();
  }
}
