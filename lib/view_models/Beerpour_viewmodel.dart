import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import '../models/sensor_models.dart';
import '../services/external/sensor_service.dart';
import '../services/external/logger_service.dart';
import '../services/internal/logger_service_internal.dart';

/// ViewModel for the beer-pouring exercise
class BeerPourViewModel extends ChangeNotifier {
  // Raw IMU data
  ImuSensorData _acclData = ImuSensorData(x: 0, y: 0, z: 0, timeStamp: DateTime.now(), state: SensorState.off);
  ImuSensorData _gyroData = ImuSensorData(x: 0, y: 0, z: 0, timeStamp: DateTime.now(), state: SensorState.off);

  // Sensor and countdown state
  bool _sensorsRunning = false;
  bool _countdownActive = false;
  int _countdown = 3;
  String? _logOwnerId;

  // Beer‑pouring state
  double _beerLevel = 1.0;
  double _angle = 0.0;
  bool _isPouring = false;

  // Getters
  ImuSensorData get acclData => _acclData;
  ImuSensorData get gyroData => _gyroData;
  bool get sensorsRunning => _sensorsRunning;
  bool get countdownActive => _countdownActive;
  int get countdown => _countdown;
  double get beerLevel => _beerLevel;
  double get angle => _angle;
  bool get isPouring => _isPouring;

  void startExercise() {
    if (_sensorsRunning) return;
    _countdown = 3;
    _countdownActive = true;
    notifyListeners();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _countdown--;
      notifyListeners();
      if (_countdown == 0) {
        timer.cancel();
        _countdownActive = false;
        _openLogChannel();
        _startSensors();
        notifyListeners();
      }
    });
  }

  void stopExercise() {
    _stopSensors();
    _closeLogChannel();
    _sensorsRunning = false;
    notifyListeners();
  }

  void resetExercise() {
    stopExercise();
    _beerLevel = 1.0;
    _angle = 0.0;
    _isPouring = false;
    _countdownActive = false;
    notifyListeners();
  }

  void _startSensors() {
    SensorService().startAcclDataStream(samplingPeriod: const Duration(milliseconds: 50));
    SensorService().startGyroDataStream(samplingPeriod: const Duration(milliseconds: 50));
    SensorService().registerAcclDataStream(callback: _onAcclData);
    SensorService().registerGyroDataStream(callback: _onGyroData);
    _sensorsRunning = true;
  }

  void _stopSensors() {
    SensorService().stopAcclDataStream();
    SensorService().stopGyroDataStream();
  }

  void _onAcclData(ImuSensorData data) {
    _acclData = data;
    _updateAngle();
    _checkPourState();
    _logSensorData();
    notifyListeners();
  }

  void _onGyroData(ImuSensorData data) {
    _gyroData = data;
    notifyListeners();
  }

  void _updateAngle() {
    _angle = atan2(_acclData.x, _acclData.y);
  }

  void _checkPourState() {
    const double threshold = pi / 4;
    if (!_isPouring && _angle.abs() > threshold && _beerLevel > 0) {
      _isPouring = true;
    }
    if (_isPouring) {
      _beerLevel = max(0.0, _beerLevel - 0.005);
      if (_beerLevel <= 0) {
        _beerLevel = 0.0;
        _isPouring = false;
      }
    }
    if (_angle.abs() < threshold) {
      _isPouring = false;
    }
  }

  Future<void> _openLogChannel() async {
    if (_logOwnerId == null) {
      _logOwnerId = await LoggerService().openCsvLogChannel(
        access: ChannelAccess.private,
        fileName: 'beer_pour_data',
        headerData: 'time,acclX,acclY,acclZ,gyroX,gyroY,gyroZ,angle,beerLevel',
      );
    }
  }

  void _logSensorData() {
    if (_logOwnerId == null) return;
    final d = _acclData;
    LoggerService().log(
      channel: LogChannel.csv,
      ownerId: _logOwnerId!,
      data: '${d.timeStamp},${d.x},${d.y},${d.z},'
          '${_gyroData.x},${_gyroData.y},${_gyroData.z},'
          '${_angle.toStringAsFixed(3)},${_beerLevel.toStringAsFixed(3)}',
    );
  }

  void _closeLogChannel() {
    if (_logOwnerId != null) {
      LoggerService().closeLogChannelSafely(
        ownerId: _logOwnerId!,
        channel: LogChannel.csv,
      );
      _logOwnerId = null;
    }
  }
}