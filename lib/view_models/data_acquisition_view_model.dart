import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../models/sensor_models.dart';
import '../services/external/logger_service.dart';
import '../services/external/sensor_service.dart';
import '../services/internal/logger_service_internal.dart';

class AcqViewModel extends ChangeNotifier {
  late List<ImuSensorData> acclData;
  late List<ImuSensorData> gyroData;
  //late LoggerService logger;
  late String? UOID;
  int index = 0;
  bool on = false;
  bool isFork = false; // false if spoon, true if fork
  bool isLeft = false; // right/left hand switch
  bool writeInfo = true;
  // Create a StreamController to manage the countdown values
  late StreamController<String> countdownController;

  // Repetition detection
  int repetitions = 0;
  bool wasAboveThreshold = false;
  final double threshold = 4.5;
  List<DateTime> repetitionTimestamps = [];

  // Impact detection
  double impactThreshold = 20.0;
  bool impactDetected = false;
  int impactCount = 0;
  final Duration impactCooldown = Duration(seconds: 1);

  // Shaking detection
  final int shakingWindowSize = 40; // ~1 second
  double shakingVarianceThreshold = 4.0;
  bool isShaking = false;
  DateTime? _shakingStartedAt;
  Duration totalShakingDuration = Duration.zero;
  DateTime? _lastShakingWarningShown;

  bool showImpactWarning = false;
  bool showShakingWarning = false;
  DateTime? lastImpactTime;
  DateTime? lastShakingTime;
  final Duration alertDuration = Duration(seconds: 2);

  DateTime? measurementStartTime;

  // String? ownerId;

  void setImpactThreshold(double value) {
    impactThreshold = value;
    notifyListeners();
  }

  void setShakingVarianceThreshold(double value) {
    shakingVarianceThreshold = value;
    notifyListeners();
  }

  AcqViewModel() {
    acclData = [];
    gyroData = [];
  }

  void onDataChanged(ImuSensorData data) {
    ImuSensorData accl = SensorService().getAcclData();
    ImuSensorData gyro = SensorService().getGyroData();
    if (acclData.length > 1000) {
      acclData.removeAt(0);
    }
    acclData.add(SensorService().getAcclData());

    if (gyroData.length > 1000) {
      gyroData.removeAt(0);
    }
    gyroData.add(SensorService().getGyroData());

    if (writeInfo) {
      String forkText = isFork ? 'Fork' : 'Spoon';
      String leftText = isLeft ? 'Left' : 'Right';
      LoggerService().log(channel: LogChannel.csv, ownerId: UOID!,
          data:'$forkText$leftText\n');
      writeInfo = false;
    }

    detectRepetition(accl.y);
    detectImpact(accl);
    detectShaking();

    bool wasSuccessful = LoggerService().log(channel: LogChannel.csv, ownerId: UOID!,
        data: '${accl.timeStamp.toString()},'
            '${accl.x.toStringAsFixed(2)},'
            '${accl.y.toStringAsFixed(2)},'
            '${accl.z.toStringAsFixed(2)},'
            '${gyro.x.toStringAsFixed(2)},'
            '${gyro.y.toStringAsFixed(2)},'
            '${gyro.z.toStringAsFixed(2)},');
    index++;
    notifyListeners();
  }

  void detectRepetition(double currentY) {
    if (currentY > threshold && !wasAboveThreshold) {
      repetitions++;
      repetitionTimestamps.add(DateTime.now()); // Track when repetition happens
      wasAboveThreshold = true;
    } else if (currentY < threshold) {
      wasAboveThreshold = false;
    }
  }

  void detectImpact(ImuSensorData accl) {
    double magnitude = sqrt(accl.x * accl.x + accl.y * accl.y + accl.z * accl.z);
    final now = DateTime.now();

    if (magnitude > impactThreshold) {
      if (lastImpactTime == null || now.difference(lastImpactTime!) > impactCooldown) {
        impactCount++;
        lastImpactTime = now;
      }
    }

    showImpactWarning = lastImpactTime != null &&
        now.difference(lastImpactTime!) < alertDuration;
  }

  void detectShaking() {
    if (gyroData.length < shakingWindowSize) {
      isShaking = false;
      return;
    }

    final recent = gyroData.sublist(gyroData.length - shakingWindowSize);
    final variances = ['x', 'y', 'z'].map((axis) {
      List<double> values = recent.map((d) {
        switch (axis) {
          case 'x': return d.x;
          case 'y': return d.y;
          case 'z': return d.z;
          default: return 0.0;
        }
      }).toList();
      double mean = values.reduce((a, b) => a + b) / values.length;
      double variance = values.map((v) => pow(v - mean, 2)).reduce((a, b) => a + b) / values.length;
      return variance;
    }).toList();

    final currentlyShaking = variances.any((v) => v > shakingVarianceThreshold);

    if (currentlyShaking && !isShaking) {
      _shakingStartedAt = DateTime.now();
    } else if (!currentlyShaking && isShaking) {
      if (_shakingStartedAt != null) {
        final shakingEnd = DateTime.now();
        totalShakingDuration += shakingEnd.difference(_shakingStartedAt!);
        _shakingStartedAt = null;
      }
    }

    isShaking = currentlyShaking;

    if (currentlyShaking) {
      showShakingWarning = true;
      _lastShakingWarningShown = DateTime.now();
    } else if (_lastShakingWarningShown != null) {
      final elapsed = DateTime.now().difference(_lastShakingWarningShown!);
      if (elapsed > Duration(seconds: 2)) {
        showShakingWarning = false;
        _lastShakingWarningShown = null;
      }
    }
  }


  void resetSession() {
    measurementStartTime = DateTime.now(); // Spustenie merania
    repetitions = 0;
    repetitionTimestamps.clear();
    wasAboveThreshold = false;
    impactDetected = false;
    impactCount = 0;
    isShaking = false;
    totalShakingDuration = Duration.zero;
    acclData.clear();
    gyroData.clear();
    index = 0;
  }


  // UI Accessors
  int getRepetitionCount() => repetitions;
  bool wasImpactDetected() => impactDetected;
  int getImpactCount() => impactCount;
  bool isHandShaking() => isShaking;

  bool shouldShowImpactWarning() => showImpactWarning;
  bool shouldShowShakingWarning() => showShakingWarning;

  String getTotalMeasurementDuration() {
    if (measurementStartTime == null) return "0s";
    final duration = DateTime.now().difference(measurementStartTime!);
    return _formatDuration(duration);
  }

  String getShakingDuration() {
    final seconds = totalShakingDuration.inSeconds;
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inMinutes)}:${twoDigits(d.inSeconds % 60)}";
  }

  String getAverageRepetitionDuration() {
    if (repetitionTimestamps.length < 2) return "N/A";

    List<int> intervals = [];
    for (int i = 1; i < repetitionTimestamps.length; i++) {
      intervals.add(repetitionTimestamps[i].difference(repetitionTimestamps[i - 1]).inMilliseconds);
    }

    int avgMs = intervals.reduce((a, b) => a + b) ~/ intervals.length;

    Duration avg = Duration(milliseconds: avgMs);
    return "${avg.inSeconds}.${(avg.inMilliseconds % 1000 ~/ 100)}s";
  }


  void registerSensorService() {
    SensorService().startAcclDataStream(samplingPeriod: Duration(milliseconds: 50));
    SensorService().registerAcclDataStream(callback: (ImuSensorData data) => onDataChanged(data));

    SensorService().startGyroDataStream(samplingPeriod: Duration(milliseconds: 50));
    SensorService().registerGyroDataStream(callback: (ImuSensorData data) => onDataChanged(data));
  }

  Future<void> onInit() async {
    UOID = await LoggerService().openCsvLogChannel(access: ChannelAccess.private, fileName: 'eatingAccData', headerData: 'TimeStamp, AccX, AccY, AccZ, GyroX, GyroY, GyroZ');
    countdownController = StreamController<String>.broadcast();  // Create a new StreamController
  }


  void onClose() {
    // Here you can call ViewModel disposal code.
    SensorService().stopAcclDataStream();
    SensorService().stopGyroDataStream();
    LoggerService().closeLogChannelSafely(ownerId: UOID!, channel: LogChannel.csv);
    countdownController.close();
    on = false;
    notifyListeners();
  }

  Future<void> startStream() async {
    //UOID = await LoggerService().openCsvLogChannel(access: ChannelAccess.protected, fileName: 'eatingAccData', headerData: 'HeaderData1, HeaderData2, HeaderData3');
    resetSession();
    registerSensorService();
    acclData = List.empty(growable: true);
    SensorService().startAcclDataStream(samplingPeriod: Duration(milliseconds: 50));
    SensorService().registerAcclDataStream(callback: (ImuSensorData data) => onDataChanged(data));

    gyroData = List.empty(growable: true);
    SensorService().startGyroDataStream(samplingPeriod: Duration(milliseconds: 50));
    SensorService().registerGyroDataStream(callback: (ImuSensorData data) => onDataChanged(data));
    on = true;
  }

  void stopStream() {
    SensorService().stopAcclDataStream();
    SensorService().stopGyroDataStream();
    //LoggerService().closeLogChannelSafely(ownerId: UOID!, channel: LogChannel.csv);
    on = false;
    if (isShaking && _shakingStartedAt != null) {
      totalShakingDuration += DateTime.now().difference(_shakingStartedAt!);
      _shakingStartedAt = null;
    }
    notifyListeners();
  }
}