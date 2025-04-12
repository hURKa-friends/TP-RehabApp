import '../internal/initialize_service_internal.dart';

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

  // Public Methods
  bool isFooPresent() {
    ///
    /// Implement some method from InitResourcesServiceInternal
    ///
    throw UnimplementedError();
  }

  ///
  /// Add other meaningful methods that will return state of peripherals or other in app components
  ///

}