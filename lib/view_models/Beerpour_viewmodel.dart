import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fftea/fftea.dart';
import '../models/sensor_models.dart';
import '../services/external/sensor_service.dart';
import '../services/external/logger_service.dart';
import '../services/internal/logger_service_internal.dart';

/// ViewModel for the beer-pouring exercise
class BeerPourViewModel extends ChangeNotifier {
  // Raw IMU data
  ImuSensorData _acclData = ImuSensorData(
    x: 0, y: 0, z: 0,
    timeStamp: DateTime.now(),
    state: SensorState.off,
  );
  ImuSensorData _gyroData = ImuSensorData(
    x: 0, y: 0, z: 0,
    timeStamp: DateTime.now(),
    state: SensorState.off,
  );

  // Sensor and countdown state
  bool _sensorsRunning = false;
  bool _countdownActive = false;
  int  _countdown = 3;
  String? _logOwnerId;

  // Beer‑pouring state
  double _beerLevel = 1.0;
  double _angle     = 0.0;
  bool   _isPouring = false;
  double? _glassWidth;
  double? _glassHeight;

  // Jerk detection
  double   _previousPourRate = 0.0;
  bool     _unevenPouring    = false;
  DateTime? _previousPourTime;
  double    _prevJerk        = 0.0;
  final dominantFrequency = 0.0;

  // Buffers & summary
  final List<ImuSensorData> _accelBuffer = [];
  final List<ImuSensorData> _accelBuffer2 = [];
  final List<ImuSensorData> _gyroBuffer  = [];
  double _accelStdDev = 0.0;
  int    _impactCount = 0;

  // Getters
  ImuSensorData get acclData      => _acclData;
  ImuSensorData get gyroData      => _gyroData;
  bool get sensorsRunning         => _sensorsRunning;
  bool get countdownActive        => _countdownActive;
  int  get countdown              => _countdown;
  double get beerLevel            => _beerLevel;
  double get angle                => _angle;
  bool get isPouring              => _isPouring;
  double? get glassWidth          => _glassWidth;
  double? get glassHeight         => _glassHeight;
  bool get unevenPouring          => _unevenPouring;
  double get accelStdDev          => _accelStdDev;
  int    get impactCount          => _impactCount;

  void setGlassDimensions(double width, double height) {
    _glassWidth = width;
    _glassHeight = height;
  }

  void startExercise() {
    if (_sensorsRunning) return;
    resetExercise();
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
    _unevenPouring = false;
    _countdownActive = false;
    _accelStdDev = 0.0;
    _impactCount = 0;
    _accelBuffer.clear();
    _accelBuffer2.clear();
    _gyroBuffer.clear();
    _previousPourTime = null;
    _previousPourRate = 0.0;
    _prevJerk = 0.0;
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
    _accelBuffer.add(data);
    _accelBuffer2.add(data);

    if (_accelBuffer2.length > 5) {
      _accelBuffer2.removeAt(0);
    }
    final smoothed = _computeSmoothedAccel();
    _acclData = smoothed;
    _updateAngle();
    _checkPourState();
    _logSensorData();
    notifyListeners();
  }

  void _onGyroData(ImuSensorData data) {
    _gyroData = data;
    _gyroBuffer.add(data);
    notifyListeners();
  }

  ImuSensorData _computeSmoothedAccel() {
    if (_accelBuffer2.isEmpty) return _acclData;

    final n = _accelBuffer2.length;
    double sumX = 0, sumY = 0, sumZ = 0;

    for (final d in _accelBuffer2) {
      sumX += d.x;
      sumY += d.y;
      sumZ += d.z;
    }

    return ImuSensorData(
      x: sumX / n,
      y: sumY / n,
      z: sumZ / n,
      timeStamp: _accelBuffer2.last.timeStamp,
      state: _accelBuffer2.last.state,
    );
  }


  void _updateAngle() {
    _angle = atan2(_acclData.x, _acclData.y);
  }

  void _checkPourState() {
    if (_glassWidth == null || _glassHeight == null) return;

    final width  = _glassWidth!;
    final height = _glassHeight!;
    final currentLiquidHeight = height * _beerLevel;
    final tiltOffset = tan(_angle) * width / 2;

    final yLeftRaw  = currentLiquidHeight + tiltOffset;
    final yRightRaw = currentLiquidHeight - tiltOffset;
    final pouringLeft  = yLeftRaw > height;
    final pouringRight = yRightRaw > height;

    _isPouring = (pouringLeft || pouringRight) && _beerLevel > 0;

    if (_isPouring) {
      // compute pour rate
      double pourRate = 0.0005;
      if (pouringLeft)  pourRate += (yLeftRaw  - height) * 0.0002;
      if (pouringRight) pourRate += (yRightRaw - height) * 0.0002;

      // compute jerk
      final rateChange = pourRate - _previousPourRate;
      final now = DateTime.now();
      final prev = _previousPourTime;
      if (prev != null) {
        final dt = now.difference(prev).inMilliseconds / 1000.0;
        if (dt > 0) {
          final jerk = rateChange / dt;
          const jerkThreshold = 0.02;
          _unevenPouring = (jerk - _prevJerk).abs() > jerkThreshold;
          _prevJerk = jerk;
        }
        _previousPourRate = pourRate;
      }
      _previousPourTime = now;

      // apply pour
      _beerLevel = max(0.0, _beerLevel - pourRate);
      if (_beerLevel <= 0) {
        _beerLevel = 0.0;
        _isPouring = false;
        _onExerciseComplete();
      }
    } else {
      _isPouring = false;
      // leave unevenPouring until reset or next pour
    }
  }

  Future<void> _onExerciseComplete() async {
    // 1) stop sensors
    _stopSensors();

    // 2) analyze IMU data
    _analyzeShake();
    notifyListeners(); // so UI can read accelStdDev & impactCount

    // 3) log summary
    final summaryOwner = await LoggerService().openCsvLogChannel(
      access: ChannelAccess.private,
      fileName: 'beer_pour_summary',
      headerData: 'stdDevAcc,impacts',
    );
    final line = '${_accelStdDev.toStringAsFixed(3)},$_impactCount';
    LoggerService().log(
      channel: LogChannel.csv,
      ownerId: summaryOwner!,
      data: line,
    );

    // 4) clear buffers & summary
    _accelBuffer.clear();
    _gyroBuffer.clear();
    _accelStdDev = 0.0;
    _impactCount = 0;

    // 5) close logs
    _closeLogChannel();
    LoggerService().closeLogChannelSafely(
      ownerId: summaryOwner,
      channel: LogChannel.csv,
    );

    // 6) mark sensors stopped
    _sensorsRunning = false;
    notifyListeners();
  }

  void _analyzeShake() {
    if (_accelBuffer.isEmpty) {
      _accelStdDev = 0.0;
      _impactCount = 0;
      return;
    }

    final mags = _accelBuffer
        .map((d) => sqrt(d.x * d.x + d.y * d.y + d.z * d.z))
        .toList();

    final mean = mags.reduce((a, b) => a + b) / mags.length;
    final varSum = mags
        .map((m) => (m - mean) * (m - mean))
        .reduce((a, b) => a + b);

    _accelStdDev = sqrt(varSum / mags.length);

    const impactThreshold = 15.0;
    _impactCount = mags.where((m) => m > impactThreshold).length;
  }

  Future<void> _openLogChannel() async {
    if (_logOwnerId == null) {
      _logOwnerId = await LoggerService().openCsvLogChannel(
        access: ChannelAccess.private,
        fileName: 'beer_pour_data',
        headerData:
        'time,acclX,acclY,acclZ,gyroX,gyroY,gyroZ,angle,beerLevel',
      );
    }
  }

  void _logSensorData() {
    if (_logOwnerId == null) return;
    final d = _acclData;
    final g = _gyroData;
    LoggerService().log(
      channel: LogChannel.csv,
      ownerId: _logOwnerId!,
      data:
      '${d.timeStamp.toString()},'
          '${d.x.toStringAsFixed(3)},'
          '${d.y.toStringAsFixed(3)},'
          '${d.z.toStringAsFixed(3)},'
          '${g.x.toStringAsFixed(3)},'
          '${g.y.toStringAsFixed(3)},'
          '${g.z.toStringAsFixed(3)},'
          '${_angle.toStringAsFixed(3)},'
          '${_beerLevel.toStringAsFixed(3)}'
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