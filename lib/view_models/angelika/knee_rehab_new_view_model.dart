import 'package:flutter/material.dart';
import 'package:rehab_app/models/sensor_models.dart';
import 'package:rehab_app/services/external/sensor_service.dart';
import '../../services/external/logger_service.dart';
import '../../services/internal/logger_service_internal.dart';


class KneeRehabNewViewModel extends ChangeNotifier {
  late List<ImuSensorData> gyroData;
  late List<ImuSensorData> acclData;
  int gyroIndex = 0, acclIndex = 0;
  String? name;

  late String? UOID;
  KneeRehabNewViewModel() {
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

    if (name != null) {
      bool wasSuccessful = LoggerService().log(
          channel: LogChannel.csv,
          ownerId: UOID!,
          data:
          "${gyroData.last.timeStamp}, ${gyroData.last.x}, ${gyroData.last.y}, ${gyroData.last.z}, "
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