import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rehab_app/arm_rehab/models/arm_model.dart';

import 'package:rehab_app/services/page_management/models/stateless_page_model.dart';
import 'package:rehab_app/services/page_management/view_models/page_navigator_view_model.dart';

class ExerciseSummaryViewModel extends ChangeNotifier {
  final double imageSize = 150;

  ExerciseSummaryViewModel() {
    // Default constructor
  }

  Future<void> onInit() async {
    // Here you can call ViewModel initialization code.
  }

  void onClose() {
    // Here you can call ViewModel disposal code.
    ArmImuData.acclData = List.empty(growable: true);
    ArmImuData.gyroData = List.empty(growable: true);
  }

  void selectPage(BuildContext context, StatelessPage page) {
    var navigatorViewModel = Provider.of<PageNavigatorViewModel>(context, listen: false);
    navigatorViewModel.selectPage(context, page);
  }
}