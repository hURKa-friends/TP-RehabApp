import 'dart:async';

import 'package:flutter/material.dart';

import '../services/internal/logger_service_internal.dart';
import '../services/logger_service.dart';
import '../services/sensor_service.dart';

class AccelerometerViewModel extends ChangeNotifier {
  // Private Fields & Parameters
  late double _x;
  late double _y;
  late double _z;
  late DateTime _timestamp;
  //late String _id;

  final SensorService _sensorService = SensorService();
  //final LoggerService _loggerService = LoggerService();
  //late Timer _timer;

  // Constructors
  AccelerometerViewModel() {
    //_getId();
    LoggerService().openCsvLogChannel(access: ChannelAccess.public, fileName: "Test 1 csv", headerData: "Timestamp,  x,  y,  z\n");

    SensorService().registerAcclDataStream(samplingPeriod: const Duration(milliseconds: 20), callback: () {
      _updateValues();
    },);

    SensorService().startAcclDataStream(samplingPeriod: const Duration(milliseconds: 20));

    /*_x = SensorService().getAcclData().x;
    _y = SensorService().getAcclData().y;
    _z = SensorService().getAcclData().z;
    _timestamp = SensorService().getAcclData().timeStamp;*/

    // TODO startAcclDataStream az vo viewModel cez funkciu
    /*_x = _sensorService.getAcclData().x;
    _y = _sensorService.getAcclData().y;
    _z = _sensorService.getAcclData().z;
    _timestamp = _sensorService.getAcclData().timeStamp;
    LoggerService().log(channel: LogChannel.plain, ownerId: "abc", data: "$_timestamp  $_x  $_y  $_z\n");
    */
    /*_sensorService.registerAcclDataStream(samplingPeriod: SensorInterval.normalInterval, callback: () {
      _loggerService.log(channel: LogChannel.plain, ownerId: "abc", data: "${_sensorService.getAcclData().timeStamp}  ${_sensorService.getAcclData().x}  ${_sensorService.getAcclData().y}  ${_sensorService.getAcclData().z}");
      _x = _sensorService.getAcclData().x;
      _y = _sensorService.getAcclData().y;
      _z = _sensorService.getAcclData().z;
      _timestamp = _sensorService.getAcclData().timeStamp;
    });*/

    /*_timer = Timer.periodic(const Duration(milliseconds: 20), _updateValues);*/
  }

  // Getters
  double get getX => _x;
  double get getY => _y;
  double get getZ => _z;
  DateTime get getTimestamp => _timestamp;

  // Methods
  void _updateValues(/*Timer timer*/) {
    _x = SensorService().getAcclData().x;
    _y = SensorService().getAcclData().y;
    _z = SensorService().getAcclData().z;
    _timestamp = SensorService().getAcclData().timeStamp;
    notifyListeners();
    print("X: $_x\n");
    print("Y: $_y\n");
    print("Z: $_z\n");
    print("Timestamp: $_timestamp\n");
    //_getId();
    //await LoggerService().openPlainLogChannel(access: ChannelAccess.protected, fileName: "Test 1");
    LoggerService().log(channel: LogChannel.csv, ownerId: "abc", data: "$_timestamp,  $_x,  $_y,  $_z\n");
    //LoggerService().
  }

  void _getId() async {
    //_id = (await LoggerService().openPlainLogChannel(access: ChannelAccess.private, fileName: "Test 1"))!;
  }

  void cancelTimer() {
    //_timer.cancel();
  }
}