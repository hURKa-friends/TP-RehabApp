import 'dart:async';
import 'package:flutter/material.dart';
import '../models/sensor_models.dart';
import '../services/external/logger_service.dart';
import '../services/external/sensor_service.dart';
import '../services/internal/logger_service_internal.dart';

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
  List<TouchData> _touchDataPoints = [];
  List<ImuSensorData> _acclDataPoints = [];
  List<ImuSensorData> _gyroDataPoints = [];
  bool _countdownActive = false;
  int _countdown = 3;
  String? _logOwnerId;
  bool _isLoggingEnabled = false;
  bool _isAnalyzing = false;

  bool get isAnalyzing => _isAnalyzing;
  bool get isLoggingEnabled => _isLoggingEnabled;
  ImuSensorData get acclData => _acclData;
  ImuSensorData get gyroData => _gyroData;
  bool get sensorsRunning => _sensorsRunning;
  List<Offset> get touchPoints => _touchPoints;
  List<TouchData> get touchDataPoints => _touchDataPoints;
  List<ImuSensorData> get acclDataPoints => _acclDataPoints;
  List<ImuSensorData> get gyroDataPoints => _gyroDataPoints;
  bool get countdownActive => _countdownActive;
  int get countdown => _countdown;

  @override
  void dispose() {
    _closeLogChannel();
    super.dispose();
  }

  void startSensors() {
    _countdown = 3;
    _countdownActive = true;
    notifyListeners();

    Timer.periodic(const Duration(seconds: 1), (timer) {
      _countdown--;
      notifyListeners();
      if (_countdown == 0) {
        timer.cancel();
        _countdownActive = false;
        SensorService().startAcclDataStream(
            samplingPeriod: const Duration(milliseconds: 50));
        SensorService().startGyroDataStream(
            samplingPeriod: const Duration(milliseconds: 50));
        SensorService().registerAcclDataStream(callback: _updateAcclData);
        SensorService().registerGyroDataStream(callback: _updateGyroData);
        clearTouchPoints();
        _sensorsRunning = true;

        _openLogChannel();

        notifyListeners();
      }
    });
  }

  Future<void> _openLogChannel() async {
    if (_logOwnerId == null) {
      _logOwnerId = await LoggerService().openCsvLogChannel(
        access: ChannelAccess.private,
        fileName: 'motion_data',
        headerData:
        'SensorTimestamp, AcclX, AcclY, AcclZ, GyroX, GyroY, GyroZ, TouchTimestamp, TouchX, TouchY',
      );
      print("Log owner ID: $_logOwnerId");
      _isLoggingEnabled = _logOwnerId != null;
    }
    notifyListeners();
  }

  void _closeLogChannel() {
    if (_logOwnerId != null) {
      LoggerService().closeLogChannelSafely(
          ownerId: _logOwnerId!, channel: LogChannel.csv);
      _logOwnerId = null;
      _isLoggingEnabled = false;
    }
  }

  void addTouchPoint(Offset point) {
    _touchPoints.add(point);
    _touchDataPoints.add(TouchData(point: point, timeStamp: DateTime.now()));
    notifyListeners();
  }

  void clearTouchPoints() {
    _touchPoints.clear();
    _touchDataPoints.clear();
    _acclDataPoints.clear();
    _gyroDataPoints.clear();

    notifyListeners();
  }

  void stopSensors() {
    SensorService().stopAcclDataStream();
    SensorService().stopGyroDataStream();
    clearTouchPoints();
    _sensorsRunning = false;
    _closeLogChannel(); // Close channel here
    notifyListeners();
  }

  void _updateAcclData(ImuSensorData data) {
    _acclData = SensorService().getAcclData();
    _acclDataPoints.add(_acclData);
    notifyListeners();
  }

  void _updateGyroData(ImuSensorData data) {
    _gyroData = SensorService().getGyroData();
    _gyroDataPoints.add(_gyroData);
    notifyListeners();
  }

  Future<void> analyzeData() async {
    _isAnalyzing = true;
    notifyListeners();

    print("Analyzing data...");
    print("Touch points count: ${_touchDataPoints.length}");
    print("Accelerometer data points count: ${_acclDataPoints.length}");
    print("Gyroscope data points count: ${_gyroDataPoints.length}");
    print("Log owner ID: $_logOwnerId");
    if (_isLoggingEnabled) {
      // Log sensor data
      for (int i = 0; i < _acclDataPoints.length; i++) {
        LoggerService().log(
          channel: LogChannel.csv,
          ownerId: _logOwnerId!,
          data:
          '${_acclDataPoints[i].timeStamp},${_acclDataPoints[i].x},${_acclDataPoints[i].y},'
              '${_acclDataPoints[i].z},${_gyroDataPoints[i].x},${_gyroDataPoints[i].y},${_gyroDataPoints[i].z},,,,',
        );
      }

      for (final touchData in _touchDataPoints) {
        LoggerService().log(
          channel: LogChannel.csv,
          ownerId: _logOwnerId!,
          data: ',,,,,,${touchData.timeStamp},${touchData.point.dx},${touchData.point.dy}',
        );
      }
    }

    _closeLogChannel(); // Close channel here
    _isAnalyzing = false;
    notifyListeners();
  }

  void resetTry() {
    stopSensors();
    clearTouchPoints();
    notifyListeners();
  }
}

class TouchData {
  final Offset point;
  final DateTime timeStamp;

  TouchData({required this.point, required this.timeStamp});
}