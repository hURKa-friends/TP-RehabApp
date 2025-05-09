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
  late AudioPlayer _playerShort;
  late AudioPlayer _playerLong;
  late double _currentX;
  late double _currentY;
  late double _currentZ;
  final _toleranceX = 0.3;
  final _toleranceY = 0.3;
  final _toleranceZ = 0.3;
  final setpoints = Setpoints();
  final double imageSize = 300;

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
    _acclData = data;
  }

  void getUserAcclData(ImuSensorData data) {
    _userAcclData = data;

    _currentX = _acclData.x - _userAcclData.x;
    _currentY = _acclData.y - _userAcclData.y;
    _currentZ = _acclData.z - _userAcclData.z;

    notifyListeners();
  }
  
  void getGyroData(ImuSensorData data) {
    _gyroData = data;

    if (!_exerciseFinished) {
      ArmImuData.acclData.add(_acclData);
      ArmImuData.gyroData.add(_gyroData);
    }

    writeToCsv("${_gyroData.timeStamp}, ${_userAcclData.x}, ${_userAcclData.y}, ${_userAcclData.z}, ${_gyroData.x}, ${_gyroData.y}, ${_gyroData.z}\n");
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
    if (_currentX < x + _toleranceX && _currentX > x - _toleranceX &&
    _currentY < y + _toleranceY && _currentY > y - _toleranceY &&
    _currentZ < z + _toleranceZ && _currentZ > z - _toleranceZ) {
      _currentSetpoint++;
    }

    if (_currentSetpoint > 1) {
      _currentSetpoint = 0;
      _repetitionCount++;
    }

    if (_currentSetpoint == _nextSetpoint) {
      _nextSetpoint++;
      playShortBeep();

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
  int get nextSetpoint => _nextSetpoint;
  int get repetitionCount => _repetitionCount;
  bool get exerciseFinished => _exerciseFinished;
  double get currentX => _currentX;
  double get currentY => _currentY;
  double get currentZ => _currentZ;
}