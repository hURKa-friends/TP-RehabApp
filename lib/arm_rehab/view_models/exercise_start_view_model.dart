import 'dart:async';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:rehab_app/arm_rehab/models/arm_model.dart';
import 'package:rehab_app/models/sensor_models.dart';
import 'package:rehab_app/services/internal/logger_service_internal.dart';

import '../../services/external/logger_service.dart';
import '../../services/external/sensor_service.dart';

class ExerciseStartViewModel extends ChangeNotifier {
  late Timer _countdownTimer;
  late bool _isTimerActive;
  late int _timerCount;
  late int _nextSetpoint;
  late int _currentSetpoint;
  late int _repetitionCount;
  late String? _ownerID;
  late bool _writeSuccessful;
  late ImuSensorData _acclData;
  late ImuSensorData _gyroData;
  final _playerShort = AudioPlayer();
  final _playerLong = AudioPlayer();
  final toleranceX = 0.5;
  final toleranceY = 0.5;
  final toleranceZ = 0.5;
  final setpoints = Setpoints();

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
    await _playerShort.setSource(AssetSource("arm_rehab/sounds/beeps/short_beep.m4a"));
    await _playerLong.setSource(AssetSource("arm_rehab/sounds/beeps/long_beep.m4a"));
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
    SensorService().startAcclDataStream(samplingPeriod: Duration(milliseconds: 50));
    SensorService().registerAcclDataStream(callback: (ImuSensorData data) => getAcclData(data));
    SensorService().startGyroDataStream(samplingPeriod: Duration(milliseconds: 50));
    SensorService().registerGyroDataStream(callback: (ImuSensorData data) => getGyroData(data));
  }

  void onClose() {
    // Here you can call ViewModel disposal code.
    //_timer.cancel();
    //_isTimerActive = false;
    _playerShort.dispose();
    _playerLong.dispose();
    LoggerService().closeLogChannelSafely(ownerId: _ownerID!, channel: LogChannel.csv);
    SensorService().stopAcclDataStream();
    SensorService().stopGyroDataStream();
  }

  void getAcclData(ImuSensorData data) {
    _acclData = data;
  }
  
  void getGyroData(ImuSensorData data) {
    _gyroData = data;
    writeToCsv("${_gyroData.timeStamp}, ${_acclData.x}, ${_acclData.y}, ${_acclData.z}, ${_gyroData.x}, ${_gyroData.y}, ${_gyroData.z}\n");
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
        _countdownTimer.cancel();
      }
    }
  }

  Future<void> playShortBeep() async {
    //await _playerShort.stop();
    await _playerShort.seek(Duration(milliseconds: 10));
    await _playerShort.resume();
  }

  Future<void> playLongBeep() async {
    await _playerLong.seek(Duration(milliseconds: 10));
    await _playerLong.resume();
  }

  void writeToCsv(String data) {
    if (!_isTimerActive) {
      _writeSuccessful = LoggerService().log(channel: LogChannel.csv, ownerId: _ownerID!, data: data);

      switch (SelectedOptions.exercise) {
        case 1:
          switch (_nextSetpoint) {
            case 0:
              checkSetpoint(
                  setpoints.shoulderBlades0X, setpoints.shoulderBlades0Y,
                  setpoints.shoulderBlades0Z);

              break;
            case 1:
              checkSetpoint(
                  setpoints.shoulderBlades1X, setpoints.shoulderBlades1Y,
                  setpoints.shoulderBlades1Z);

              break;
            default:
              break;
          }

          break;
        case 2:
          switch (_nextSetpoint) {
            case 0:
              checkSetpoint(setpoints.chestPress0X, setpoints.chestPress0Y,
                  setpoints.chestPress0Z);

              break;
            case 1:
              checkSetpoint(setpoints.chestPress1X, setpoints.chestPress1Y,
                  setpoints.chestPress1Z);

              break;
            default:
              break;
          }

          break;
        case 3:
          switch (_nextSetpoint) {
            case 0:
              checkSetpoint(setpoints.bicepCurls0X, setpoints.bicepCurls0Y,
                  setpoints.bicepCurls0Z);

              break;
            case 1:
              checkSetpoint(setpoints.bicepCurls1X, setpoints.bicepCurls1Y,
                  setpoints.bicepCurls1Z);

              break;
            default:
              break;
          }

          break;
        case 4:
          switch (_nextSetpoint) {
            case 0:
              checkSetpoint(setpoints.drinking0X, setpoints.drinking0Y,
                  setpoints.drinking0Z);

              break;
            case 1:
              checkSetpoint(setpoints.drinking1X, setpoints.drinking1Y,
                  setpoints.drinking1Z);

              break;
            default:
              break;
          }

          break;
        default:
          break;
      }
    }
  }

  void checkSetpoint(double x, double y, double z) {
    if (gyroData.x < x + toleranceX && gyroData.x > x - toleranceX &&
    gyroData.y < y + toleranceY && gyroData.y > y - toleranceY &&
    gyroData.z < z + toleranceZ && gyroData.z > z - toleranceZ) {
      _currentSetpoint++;
    }

    if (_currentSetpoint == _nextSetpoint) {
      _nextSetpoint++;
      playShortBeep();
    }

    if (_nextSetpoint > 1) {
      _nextSetpoint = 0;
    }
    if (_currentSetpoint > 1) {
      _currentSetpoint = 0;
      _repetitionCount++;
    }

    if (_repetitionCount == SelectedOptions.repetitions) {
      playLongBeep();
      // navigacia na dalsiu stranku//////////////////////////////////////////////////////////////////////////////
    }

    notifyListeners();
  }

  bool get isTimerActive => _isTimerActive;
  int get timerCount => _timerCount;
  ImuSensorData get acclData => _acclData;
  ImuSensorData get gyroData => _gyroData;
  int get nextSetpoint => _nextSetpoint;
  int get repetitionCount => _repetitionCount;
}