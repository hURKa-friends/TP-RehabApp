import 'package:rehab_app/models/sensor_models.dart';
import '../internal/sensor_service_internal.dart';

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
    return _internalService.initializeGyroStream(samplingPeriod);
  }
  bool startMagDataStream({required Duration samplingPeriod}) {
    return _internalService.initializeMagStream(samplingPeriod);
  }
  bool startLuxDataStream() {
    return _internalService.initializeLuxStream();
  }

  bool registerAcclDataStream({required Function(ImuSensorData) callback}) {
    return _internalService.registerAcclStream(callback);
  }
  bool registerGyroDataStream({required Function(ImuSensorData) callback}) {
    return _internalService.registerGyroStream(callback);
  }
  bool registerMagDataStream({required Function(ImuSensorData) callback}) {
    return _internalService.registerMagStream(callback);
  }
  bool registerLuxDataStream({required Function(LuxSensorData) callback}) {
    return _internalService.registerLuxStream(callback);
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
    return _internalService.cancelGyroStream();
  }
  bool stopMagDataStream() {
    return _internalService.cancelMagStream();
  }
  bool stopLuxDataStream() {
    return _internalService.cancelLuxStream();
  }
}
