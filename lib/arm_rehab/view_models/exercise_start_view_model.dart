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

class ExerciseStartViewModel extends ChangeNotifier {
  late Timer _countdownTimer;
  late bool _isTimerActive;
  late int _timerCount;
  late int _nextSetpoint;
  late int _currentSetpoint;
  late int _repetitionCount;
  late String? _ownerID;
  late bool _writeSuccessful;
  late bool _exerciseFinished;
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
  late double setpoint0X;
  late double setpoint0Y;
  late double setpoint0Z;
  late double setpoint1X;
  late double setpoint1Y;
  late double setpoint1Z;
  final _toleranceX = 0.35;
  final _toleranceY = 0.35;
  final _toleranceZ = 0.35;
  final setpoints = Setpoints();
  final double imageSize = 300;
  final double _alpha = 0.95;

  ExerciseStartViewModel() {
    // Default constructor
  }

  Future<void> onInit() async {
    // Here you can call ViewModel initialization code.
    _countdownTimer = Timer.periodic(Duration(seconds: 1), _timerFinish);
    _isTimerActive = true;
    _timerCount = 5;
    _nextSetpoint = 1;
    _currentSetpoint = 0;
    _repetitionCount = 0;
    _exerciseFinished = false;

    _playerShort = AudioPlayer();
    _playerLong = AudioPlayer();
    await _playerShort.setSource(AssetSource("arm_rehab/sounds/beeps/short_beep.m4a"));
    await _playerLong.setSource(AssetSource("arm_rehab/sounds/beeps/long_beep.m4a"));
    await _playerShort.setReleaseMode(ReleaseMode.stop);
    await _playerLong.setReleaseMode(ReleaseMode.stop);

    _ownerID = await LoggerService().openCsvLogChannel(
        access: ChannelAccess.private,
        fileName:
        switch (SelectedOptions.exercise) {
        1 => "arm_rehab_shoulder_blades",
        2 => "arm_rehab_chest_press",
        3 => "arm_rehab_bicep_curls",
        4 => "arm_rehab_drinking",
        int() => "ErrorFile", // Out of range, this shouldn't happen
        },
        headerData: "Timestamp, AcclX, AcclY, AcclZ, GyroX, GyroY, GyroZ"
    );

    _currentTimestamp = DateTime.now();
    _lastTimestamp = _currentTimestamp;

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
    LoggerService().closeLogChannelSafely(ownerId: _ownerID!, channel: LogChannel.csv);
    SensorService().stopAcclDataStream();
    SensorService().stopUserAcclDataStream();
    SensorService().stopGyroDataStream();
    _exerciseFinished = false;
  }

  void getAcclData(ImuSensorData data) {
    if (!exerciseFinished) {
      _acclData = data;
    }
  }

  void getUserAcclData(ImuSensorData data) {
    if (!exerciseFinished) {
      _userAcclData = data;

      _currentGravityX = _acclData.x - _userAcclData.x;
      _currentGravityY = _acclData.y - _userAcclData.y;
      _currentGravityZ = _acclData.z - _userAcclData.z;

      notifyListeners();
    }
  }
  
  void getGyroData(ImuSensorData data) {
    if (!exerciseFinished) {
      _gyroData = data;
      _lastTimestamp = _currentTimestamp;
      _currentTimestamp = _gyroData.timeStamp;

      _currentAcclAngleX = getAcclRoll(_currentGravityX, _currentGravityY, _currentGravityZ);
      _currentAcclAngleY = getAcclPitch(_currentGravityX, _currentGravityY, _currentGravityZ);

      Angles.currentAngleX = complementaryFilter(Angles.currentAngleX, _gyroData.x, _currentAcclAngleX, _alpha, _currentTimestamp, _lastTimestamp);
      Angles.currentAngleY = complementaryFilter(Angles.currentAngleY, _gyroData.y, _currentAcclAngleY, _alpha, _currentTimestamp, _lastTimestamp);
      Angles.currentAngleZ += _gyroData.z * _currentTimestamp.difference(_lastTimestamp).inMilliseconds / 1000;

      ArmImuData.userAcclData.add(_userAcclData);
      ArmImuData.gyroData.add(_gyroData);
      Angles.angles.add(AngleGraph(angleX: Angles.currentAngleX, angleY: Angles.currentAngleY, angleZ: Angles.currentAngleZ, timestamp: _currentTimestamp));

      writeToCsv("${_gyroData.timeStamp}, ${_userAcclData.x}, ${_userAcclData
          .y}, ${_userAcclData.z}, ${_gyroData.x}, ${_gyroData.y}, ${_gyroData
          .z}\n");
    }
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
        _exerciseFinished = false;
        _countdownTimer.cancel();
      }
    }
  }

  Future<void> playShortBeep() async {
    await _playerShort.seek(Duration(milliseconds: 10));
    await _playerShort.resume();
  }

  Future<void> playLongBeep() async {
    await _playerLong.seek(Duration(milliseconds: 10));
    await _playerLong.resume();
  }

  void writeToCsv(String data) {
    if (!_isTimerActive && !exerciseFinished) {
      _writeSuccessful = LoggerService().log(channel: LogChannel.csv, ownerId: _ownerID!, data: data);

      switch (_nextSetpoint) {
        case 0:
          checkSetpoint(Setpoint.setpoint0X, Setpoint.setpoint0Y, Setpoint.setpoint0Z);

          break;
        case 1:
          checkSetpoint(Setpoint.setpoint1X, Setpoint.setpoint1Y, Setpoint.setpoint1Z);

          break;
        default:
          break;
      }
    }
  }

  void checkSetpoint(double x, double y, double z) {
    if (Angles.currentAngleX < x + _toleranceX && Angles.currentAngleX > x - _toleranceX &&
        Angles.currentAngleY < y + _toleranceY && Angles.currentAngleY > y - _toleranceY &&
        Angles.currentAngleZ < z + _toleranceZ && Angles.currentAngleZ > z - _toleranceZ) {
      _currentSetpoint++;
    }

    if (_currentSetpoint > 1) {
      _currentSetpoint = 0;
      _repetitionCount++;
    }

    if (_currentSetpoint == _nextSetpoint) {
      if (_repetitionCount != SelectedOptions.repetitions) {
        playShortBeep();
      }
      _nextSetpoint++;

      if (_nextSetpoint > 1) {
        _nextSetpoint = 0;
      }
    }

    if (_repetitionCount == SelectedOptions.repetitions) {
      playLongBeep();
      _exerciseFinished = true;
    }

    notifyListeners();
  }

  void selectPage(BuildContext context, StatelessPage page) {
    var navigatorViewModel = Provider.of<PageNavigatorViewModel>(context, listen: false);
    navigatorViewModel.selectPage(context, page);
  }

  bool get isTimerActive => _isTimerActive;
  int get timerCount => _timerCount;
  ImuSensorData get acclData => _acclData;
  ImuSensorData get userAcclData => _userAcclData;
  ImuSensorData get gyroData => _gyroData;
  DateTime get currentTimestamp => _currentTimestamp;
  DateTime get lastTimestamp => _lastTimestamp;
  int get nextSetpoint => _nextSetpoint;
  int get repetitionCount => _repetitionCount;
  bool get exerciseFinished => _exerciseFinished;
  double get currentGravityX => _currentGravityX;
  double get currentGravityY => _currentGravityY;
  double get currentGravityZ => _currentGravityZ;
}