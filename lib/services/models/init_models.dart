import 'package:sensor_manager_android/sensor.dart';
import 'package:camera/camera.dart';

enum SensorAvailEnum { present, notAvail, unknown }

class SensorAvailability {
  final Map<Sensor, SensorInfo> sensorMap = {};
}

class SensorInfo {
  final SensorAvailEnum availability;
  final double? samplingRate;         // Hz
  final double? resolution;

  SensorInfo({
    required this.availability,
    this.samplingRate,
    this.resolution,
  });
}

class CameraDetails {
  final Map<CameraDescription?, bool> cameraInfo = {};
}