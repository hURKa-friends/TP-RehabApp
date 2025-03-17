import 'package:flutter/material.dart';
import 'package:rehab_app/services/initialize_service.dart';
import 'package:rehab_app/services/models/init_models.dart';

class InitViewModel extends ChangeNotifier {
  final InitResourcesService _service = InitResourcesService();

  SensorInfo? _accelerometer;
  SensorInfo? _gyroscope;
  SensorInfo? _magnetometer;
  SensorInfo? _lightSensor;

  InitViewModel() {
    initializeSensors();
  }

  Future<void> initializeSensors() async {
    await Future.delayed(Duration(milliseconds: 500));
    _accelerometer = _service.getAccel();
    _gyroscope = _service.getGyro();
    _magnetometer = _service.getMagneto();
    _lightSensor = _service.getLight();
    notifyListeners();
  }

  SensorInfo? get accelerometer => _accelerometer;
  SensorInfo? get gyroscope => _gyroscope;
  SensorInfo? get magnetometer => _magnetometer;
  SensorInfo? get lightSensor => _lightSensor;
}
