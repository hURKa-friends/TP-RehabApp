import 'package:rehab_app/services/sensor_models.dart';

import 'sensor_service_internal.dart';

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
    throw UnimplementedError();
  }
  bool isGyroOn() {
    throw UnimplementedError();
  }
  bool isMagOn() {
    throw UnimplementedError();
  }
  bool isLuxOn() {
    throw UnimplementedError();
  }

  bool startAcclDataStream({required Duration samplingPeriod}) {
    ///
    /// start data aquisition and return if it was succesful
    ///
    throw UnimplementedError();
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
    ///
    /// register callback as acclStream.listen() and return if it was succesful or not
    ///
    throw UnimplementedError();
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
    ///
    /// return last datapoint from acclData
    ///
    throw UnimplementedError();
  }
  ImuSensorData getGyroData() {
    throw UnimplementedError();
  }
  ImuSensorData getMagData() {
    throw UnimplementedError();
  }
  LuxSensorData getLuxData() {
    throw UnimplementedError();
  }

  bool stopAcclDataStream() {
    ///
    /// start data aquisition and unregister callback stop internal datastreams
    ///
    throw UnimplementedError();
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