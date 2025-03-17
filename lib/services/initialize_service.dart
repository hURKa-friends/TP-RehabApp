import 'internal/initialize_service_internal.dart';
import 'package:rehab_app/services/models/init_models.dart';

/// Public API for InitializeService
/// Public API for LoggerService
class InitResourcesService {
  // Singleton of this class - constructed by internal constructor
  static final InitResourcesService _instance = InitResourcesService._internal();
  static final InitResourcesServiceInternal _internalService = InitResourcesServiceInternal();

  // External "Constructor" always returns single instance of this class
  factory InitResourcesService() => _instance;

  // Internal "Constructor" initializes single instance of this class
  InitResourcesService._internal() {
    _internalService.initialize();
  }

  Future<void> _initializeService() async {
    await _internalService.initialize();
  }

  // Public Methods
  SensorInfo? getAccel() {
    return _internalService.accelData();
  }

  SensorInfo? getGyro() {
    return _internalService.gyroData();
  }

  SensorInfo? getMagneto() {
    return _internalService.magnetoData();
  }

  SensorInfo? getLight() {
    return _internalService.lightData();
  }
}