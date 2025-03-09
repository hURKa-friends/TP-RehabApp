import 'package:rehab_app/services/models/sensor_models.dart';

import 'internal/sensor_service_internal.dart';

/// Public API for SensorService
class SensorService {
  // Singleton of this class - constructed by internal constructor
  static final SensorService _instance = SensorService._internal();
  static final SensorServiceInternal _internalService = SensorServiceInternal();

  // External "Constructor" always returns single instance of this class
  factory SensorService() => _instance;

  // Internal "Constructor" initializes single instance of this class
  SensorService._internal() {
    _internalService.initialize();
  }

  // Public Methods
  bool isAcclOn() {
    return _internalService.isOnAccl();
  }
  bool isGyroOn() {
    return _internalService.isOnGyro();
  }
  bool isMagOn() {
    return _internalService.isOnMag();
  }
  bool isLuxOn() {
    return _internalService.isOnLux();
  }

  bool startAcclDataStream({required Duration samplingPeriod}) {
    return _internalService.initializeAcclStream(samplingPeriod);
  }
  bool startGyroDataStream({required Duration samplingPeriod}) {
    throw UnimplementedError();
  }
  bool startMagDataStream({required Duration samplingPeriod}) {
    throw UnimplementedError();
  }
  bool startLuxDataStream() {
    throw UnimplementedError();
  }

  bool registerAcclDataStream({required Duration samplingPeriod, required Function() callback}) {
    return _internalService.registerAcclStream(samplingPeriod, callback);
  }
  bool registerGyroDataStream({required Duration samplingPeriod, required Function() callback}) {
    throw UnimplementedError();
  }
  bool registerMagDataStream({required Duration samplingPeriod, required Function() callback}) {
    throw UnimplementedError();
  }
  bool registerLuxDataStream({required Function() callback}) {
    throw UnimplementedError();
  }

  ImuSensorData getAcclData() {
    return _internalService.acclData;
  }
  ImuSensorData getGyroData() {
    return _internalService.gyroData;
  }
  ImuSensorData getMagData() {
    return _internalService.magData;
  }
  LuxSensorData getLuxData() {
    return _internalService.luxData;
  }

  bool stopAcclDataStream() {
    return _internalService.cancelAcclStream();
  }
  bool stopGyroDataStream() {
    throw UnimplementedError();
  }
  bool stopMagDataStream() {
    throw UnimplementedError();
  }
  bool stopLuxDataStream() {
    throw UnimplementedError();
  }
}