import 'package:flutter/material.dart';
import 'package:rehab_app/models/sensor_models.dart';
import 'package:rehab_app/services/external/sensor_service.dart';
import '../services/external/logger_service.dart';
import '../services/internal/logger_service_internal.dart';


class KneeRehabMainViewModel extends ChangeNotifier {
  late List<ImuSensorData> gyroData;
  late List<ImuSensorData> acclData;
  int? start = 0;
  int firstStarted = 0;
  int gyroIndex = 0, acclIndex = 0;
  String? name;
  int repCount = 0;

// Filtered values (init to 0)
  double filteredGyroX = 0.0;
  double filteredAcclZ = 0.0;

  DateTime? legUpTimestamp;
  bool repInProgress = false;
  bool isHoldingAtTop = false;

// Configurable thresholds
  final double upwardThreshold = -1.0; // leg going up = negative gyroX
  final double downwardThreshold = 1.0; // leg going down = positive gyroX
  final double holdThreshold = 0.4; // for pause detection
  final Duration holdDuration = Duration(milliseconds: 500);

// Filter parameter
  final double alpha = 0.8;

  late String? UOID;
  KneeRehabMainViewModel() {
    // Default constructor
    gyroData = List.empty(growable: true);
    acclData = List.empty(growable: true);
  }

  Future<void> onInit() async {
    // Here you can call ViewModel initialization code.
    SensorService().startAcclDataStream(samplingPeriod: Duration(milliseconds: 50));
    SensorService().registerAcclDataStream(callback: (ImuSensorData data) => onAcclDataChanged(data));
    SensorService().startGyroDataStream(samplingPeriod: Duration(milliseconds: 50));
    SensorService().registerGyroDataStream(callback: (ImuSensorData data) => onGyroDataChanged(data));

    UOID = await LoggerService().openCsvLogChannel(
        access: ChannelAccess.private,
        fileName: 'knee_rehab',
        headerData: 'time, gyro_x, gyro_y, gyro_z, accl_x, accl_y, accl_z, side');
  }

  void onClose() {
    // Here you can call ViewModel disposal code.
    start = 0;
    repCount = 0;
    name = null;
    SensorService().stopGyroDataStream();
    SensorService().stopAcclDataStream();
    gyroData = List.empty(growable: true);
    acclData = List.empty(growable: true);
    LoggerService().closeLogChannel(ownerId: UOID!, channel: LogChannel.csv);
  }

  void onGyroDataChanged(ImuSensorData data) {
    if (gyroData.length > 100) {
      gyroData.removeAt(0);
    }
    gyroData.add(data);

    if (start != 0) {
      // Filtered value
      filteredGyroX = alpha * filteredGyroX + (1 - alpha) * data.x;
      double angularVelocity = filteredGyroX;

      // 1. Leg going up (negative X)
      if (!repInProgress && angularVelocity < upwardThreshold) {
        repInProgress = true;
        isHoldingAtTop = false;
        legUpTimestamp = null;
        //print("Leg going up — rep started");
      }

      // 2. Pause at top: nearly zero angular velocity
      if (repInProgress && !isHoldingAtTop && angularVelocity > -holdThreshold && angularVelocity < holdThreshold) {
        legUpTimestamp = DateTime.now();
        isHoldingAtTop = true;
        //print("Leg paused at top — hold timer started");
      }

      // 3. Held long enough — count the rep
      if (repInProgress && isHoldingAtTop && legUpTimestamp != null) {
        final elapsed = DateTime.now().difference(legUpTimestamp!);
        if (elapsed >= holdDuration) {
          repCount++;
          repInProgress = false;
          isHoldingAtTop = false;
          legUpTimestamp = null;
          //print("✅ Rep counted: $repCount");
        }
      }

      // 4. Cancel rep if leg goes down too early (positive gyroX)
      if (repInProgress && angularVelocity > downwardThreshold) {
        //print("Leg going down — rep canceled");
        repInProgress = false;
        isHoldingAtTop = false;
        legUpTimestamp = null;
      }

      // === Logging ===
      bool wasSuccessful = LoggerService().log(
          channel: LogChannel.csv,
          ownerId: UOID!,
          data: "${gyroData.last.timeStamp}, ${gyroData.last.x}, ${gyroData.last.y}, ${gyroData.last.z}, "
              "${acclData.last.x}, ${acclData.last.y}, ${acclData.last.z}, $name\n");
    }

    gyroIndex++;
    notifyListeners();
  }

  void onAcclDataChanged(ImuSensorData data) {
    if (acclData.length > 100) {
      acclData.removeAt(0);
    }
    acclData.add(data);
    acclIndex++;
    notifyListeners();
  }
}
