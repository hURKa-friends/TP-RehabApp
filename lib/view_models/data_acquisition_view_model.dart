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
  // String? ownerId;

  AcqViewModel() {
  }

  void onDataChanged(ImuSensorData data) {
    ImuSensorData accl = SensorService().getAcclData();
    ImuSensorData gyro = SensorService().getGyroData();
    if (acclData.length > 100) {
      acclData.removeAt(0);
    }
    acclData.add(SensorService().getAcclData());

    if (gyroData.length > 100) {
      gyroData.removeAt(0);
    }
    gyroData.add(SensorService().getGyroData());

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

  void registerSensorService() {
    SensorService().startAcclDataStream(samplingPeriod: Duration(milliseconds: 50));
    SensorService().registerAcclDataStream(callback: (ImuSensorData data) => onDataChanged(data));

    SensorService().startGyroDataStream(samplingPeriod: Duration(milliseconds: 50));
    SensorService().registerGyroDataStream(callback: (ImuSensorData data) => onDataChanged(data));
  }

  Future<void> onInit() async {
    UOID = await LoggerService().openCsvLogChannel(access: ChannelAccess.private, fileName: 'eatingAccData', headerData: 'TimeStamp, AccX, AccY, AccZ, GyroX, GyroY, GyroZ');
  }


  void onClose() {
    // Here you can call ViewModel disposal code.
    SensorService().stopAcclDataStream();
    SensorService().stopGyroDataStream();
    LoggerService().closeLogChannelSafely(ownerId: UOID!, channel: LogChannel.csv);
    on = false;
    notifyListeners();
  }

  Future<void> startStream() async {
    //UOID = await LoggerService().openCsvLogChannel(access: ChannelAccess.protected, fileName: 'eatingAccData', headerData: 'HeaderData1, HeaderData2, HeaderData3');
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
    notifyListeners();
  }
}