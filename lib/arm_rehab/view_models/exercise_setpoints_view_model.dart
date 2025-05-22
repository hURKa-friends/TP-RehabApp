import 'dart:async';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import 'package:rehab_app/arm_rehab/models/arm_model.dart';
import 'package:rehab_app/models/sensor_models.dart';
import 'package:rehab_app/services/internal/logger_service_internal.dart';

import '../../services/external/logger_service.dart';
import '../../services/external/sensor_service.dart';
import '../../services/page_management/models/stateless_page_model.dart';
import '../../services/page_management/view_models/page_navigator_view_model.dart';

class ExerciseSetpointsViewModel extends ChangeNotifier {
  late Timer _countdownTimer;
  late Timer _setpointTimer;
  late bool _isTimerActive;
  late int _timerCount;
  late int _nextSetpoint;
  late ImuSensorData _acclData;
  late ImuSensorData _userAcclData;
  late ImuSensorData _gyroData;
  late DateTime _currentTimestamp;
  late DateTime _lastTimestamp;
  late AudioPlayer _playerShort;
  late AudioPlayer _playerLong;
  late double _currentGravityX;
  late double _currentGravityY;
  late double _currentGravityZ;
  late double _currentAcclAngleX;
  late double _currentAcclAngleY;
  late double _currentAcclAngleZ;
  late bool _setpointsSet;
  final double imageSize = 300;
  final double _alpha = 0.95;

  ///
  /// TODO (novy view?)
  /// znova 5s timer
  /// setpoint pre 0
  /// setpoint pre 1
  /// potvrdit dalej
  /// uz cviky ako doteraz

  ExerciseSetpointsViewModel() {
    // Default constructor
  }

  Future<void> onInit() async {
    // Here you can call ViewModel initialization code.
    _countdownTimer = Timer.periodic(Duration(seconds: 1), _timerFinish);
    _isTimerActive = true;
    _setpointsSet = false;
    _timerCount = 5;
    _nextSetpoint = 0;

    _playerShort = AudioPlayer();
    _playerLong = AudioPlayer();
    await _playerShort.setSource(AssetSource("arm_rehab/sounds/beeps/short_beep.m4a"));
    await _playerLong.setSource(AssetSource("arm_rehab/sounds/beeps/long_beep.m4a"));
    await _playerShort.setReleaseMode(ReleaseMode.stop);
    await _playerLong.setReleaseMode(ReleaseMode.stop);

    _currentTimestamp = DateTime.now();
    _lastTimestamp = _currentTimestamp;

    Angles.currentAngleX = 0;
    Angles.currentAngleY = 0;
    Angles.currentAngleZ = 0;

    SensorService().startAcclDataStream(samplingPeriod: Duration(milliseconds: 50));
    SensorService().registerAcclDataStream(callback: (ImuSensorData data) => getAcclData(data));
    SensorService().startUserAcclDataStream(samplingPeriod: Duration(milliseconds: 50));
    SensorService().registerUserAcclDataStream(callback: (ImuSensorData data) => getUserAcclData(data));
    SensorService().startGyroDataStream(samplingPeriod: Duration(milliseconds: 50));
    SensorService().registerGyroDataStream(callback: (ImuSensorData data) => getGyroData(data));
  }

  void onClose() {
    // Here you can call ViewModel disposal code.
    _playerShort.dispose();
    _playerLong.dispose();
    _setpointTimer.cancel();
    SensorService().stopAcclDataStream();
    SensorService().stopUserAcclDataStream();
    SensorService().stopGyroDataStream();
  }

  void getAcclData(ImuSensorData data) {
    _acclData = data;
  }

  void getUserAcclData(ImuSensorData data) {
    _userAcclData = data;

    _currentGravityX = _acclData.x - _userAcclData.x;
    _currentGravityY = _acclData.y - _userAcclData.y;
    _currentGravityZ = _acclData.z - _userAcclData.z;
  }
  
  void getGyroData(ImuSensorData data) {
    _gyroData = data;
    _lastTimestamp = _currentTimestamp;
    _currentTimestamp = _gyroData.timeStamp;

    _currentAcclAngleX = getAcclRoll(_currentGravityX, _currentGravityY, _currentGravityZ);
    _currentAcclAngleY = getAcclPitch(_currentGravityX, _currentGravityY, _currentGravityZ);

    Angles.currentAngleX = complementaryFilter(Angles.currentAngleX, _gyroData.x, _currentAcclAngleX, _alpha, _currentTimestamp, _lastTimestamp);
    Angles.currentAngleY = complementaryFilter(Angles.currentAngleY, _gyroData.y, _currentAcclAngleY, _alpha, _currentTimestamp, _lastTimestamp);
    Angles.currentAngleZ += _gyroData.z * _currentTimestamp.difference(_lastTimestamp).inMilliseconds / 1000;

    notifyListeners();
  }

  void _timerFinish(Timer timer) {
    if (SelectedOptions.startTimer) {
      _timerCount--;

      notifyListeners();

      if (_timerCount >= 1) {
        playShortBeep();
      }

      if (_timerCount == 0) {
        playLongBeep();
        _isTimerActive = false;
        SelectedOptions.startTimer = false;
        _setpointTimer = Timer(Duration(seconds: 3), _saveSetpoints);
        _countdownTimer.cancel();
      }
    }
  }

  void _saveSetpoints() {
    if (_nextSetpoint == 0) {
      Setpoint.setpoint0X = Angles.currentAngleX;
      Setpoint.setpoint0Y = Angles.currentAngleY;
      Setpoint.setpoint0Z = Angles.currentAngleZ;
      playShortBeep();
      _setpointTimer.cancel();
      _setpointTimer = Timer(Duration(seconds: 3), _saveSetpoints);
    }
    if (_nextSetpoint == 1) {
      Setpoint.setpoint1X = Angles.currentAngleX;
      Setpoint.setpoint1Y = Angles.currentAngleY;
      Setpoint.setpoint1Z = Angles.currentAngleZ;
      playLongBeep();
      _setpointsSet = true;
    }
    _nextSetpoint++;
  }

  Future<void> playShortBeep() async {
    await _playerShort.seek(Duration(milliseconds: 10));
    await _playerShort.resume();
  }

  Future<void> playLongBeep() async {
    await _playerLong.seek(Duration(milliseconds: 10));
    await _playerLong.resume();
  }

  void selectPage(BuildContext context, StatelessPage page) {
    var navigatorViewModel = Provider.of<PageNavigatorViewModel>(context, listen: false);
    navigatorViewModel.selectPage(context, page);
  }

  bool get isTimerActive => _isTimerActive;
  bool get setpointsSet => _setpointsSet;
  int get timerCount => _timerCount;
  ImuSensorData get acclData => _acclData;
  ImuSensorData get userAcclData => _userAcclData;
  ImuSensorData get gyroData => _gyroData;
  DateTime get currentTimestamp => _currentTimestamp;
  DateTime get lastTimestamp => _lastTimestamp;
  int get nextSetpoint => _nextSetpoint;
  double get currentGravityX => _currentGravityX;
  double get currentGravityY => _currentGravityY;
  double get currentGravityZ => _currentGravityZ;
}