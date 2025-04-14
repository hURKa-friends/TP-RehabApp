import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rehab_app/views/accl_view.dart';
import 'package:rehab_app/views/gyro_view.dart';
import '../services/page_management/models/stateless_page_model.dart';
import '../view_models/accl_viewmodel.dart';
import '../view_models/gyro_viewmodel.dart';
import '../view_models/knee_rehab_view_model.dart';

class KneeRehabView extends StatelessPage {
  const KneeRehabView({
    super.key,
    required super.icon,
    required super.title,
    super.subPages, // Optional
    super.tutorialSteps // Optional
  });

  @override
  void initPage(BuildContext context) {
    // Here you can call page initialization code or reference ViewModel initialization like this:
    var kneeRehabViewModel = Provider.of<KneeRehabViewModel>(context, listen: false); /// IMPORTANT listen must be false
    var gyroViewModel = Provider.of<GyroViewModel>(context, listen: false);
    var acclViewModel = Provider.of<AcclViewModel>(context, listen: false);
    gyroViewModel.registerSensorService();
    acclViewModel.registerSensorService();
    kneeRehabViewModel.onInit();
  }

  @override
  void closePage(BuildContext context) {
    // Here you can call page closing code or reference ViewModel disposal like this:
    var kneeRehabViewModel = Provider.of<KneeRehabViewModel>(context, listen: false); /// IMPORTANT listen must be false
    var gyroViewModel = Provider.of<GyroViewModel>(context, listen: false);
    var acclViewModel = Provider.of<AcclViewModel>(context, listen: false);
    gyroViewModel.onClose();
    acclViewModel.onClose();
    kneeRehabViewModel.onClose();
  }

  @override
  Widget buildPage(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GyroView(),
          AcclView()
        ],
      ),
    );
  }
}