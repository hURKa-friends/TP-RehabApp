import 'package:flutter/material.dart';
import '../services/external/logger_service.dart';
import '../services/internal/logger_service_internal.dart';


class KneeRehabViewModel extends ChangeNotifier {
  //late String? UOID;
  KneeRehabViewModel() {
    // Default constructor
  }

  Future<void> onInit() async {
    // Here you can call ViewModel initialization code.
    //UOID = await LoggerService().openCsvLogChannel(access: ChannelAccess.private, fileName: 'knee_rehab', headerData: 'HeaderData1, HeaderData2, HeaderData3');
  }

  void onClose() {
    // Here you can call ViewModel disposal code.
    //LoggerService().closeLogChannelSafely(ownerId: UOID!, channel: LogChannel.csv);
  }

  //void onDataChanged() {
    //bool wasSuccessful = LoggerService().log(channel: LogChannel.csv, ownerId: UOID!, data: 'Some Data');
  //}
}