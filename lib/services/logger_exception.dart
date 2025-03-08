class LoggerException implements Exception {
  final String message;

  LoggerException(this.message);

  @override
  String toString() {
    return "LoggerServiceException: $message";
  }
}