import 'internal/logger_service_internal.dart';

/// Public API for LoggerService
class LoggerService {
  // Singleton of this class - constructed by internal constructor
  static final LoggerService _instance = LoggerService._internal();
  static final LoggerServiceInternal _internalService = LoggerServiceInternal();

  // External "Constructor" always returns single instance of this class
  factory LoggerService() => _instance;

  // Internal "Constructor" initializes single instance of this class
  LoggerService._internal() {
    _internalService.initialize();
  }

  // Public Methods
  Future<String?> openLogChannel({required ChannelAccess access, required String fileName, required LogChannel channel}) async {
    return await _internalService.initializeChannel(channel,access,fileName);
  }
  Future<String?> openCsvLogChannel({required ChannelAccess access, required String fileName, required String headerData}) async {
    return await _internalService.initializeChannel(LogChannel.csv,access,fileName, headerData: headerData);
  }
  Future<String?> openPlainLogChannel({required ChannelAccess access, required String fileName, String subChannel = ""}) async {
    return await _internalService.initializeChannel(LogChannel.plain,access,fileName, subChannel: subChannel);
  }

  bool log({required LogChannel channel, required String ownerId, required String data}) {
    return _internalService.log(channel,ownerId,data);
  }

  bool closeLogChannelSafely({required String ownerId, required LogChannel channel}) {
    throw UnimplementedError();
  }

  bool closeLogChannel({required String ownerId, required LogChannel channel}) {
    throw UnimplementedError();
  }
}