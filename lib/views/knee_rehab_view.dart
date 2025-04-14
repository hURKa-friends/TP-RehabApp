import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rehab_app/services/page_management/models/stateful_page_model.dart';
import 'package:rehab_app/views/accl_view.dart';
import 'package:rehab_app/views/gyro_view.dart';
import '../view_models/accl_viewmodel.dart';
import '../view_models/gyro_viewmodel.dart';
import '../view_models/knee_rehab_view_model.dart';

class KneeRehabView extends StatefulPage {
  const KneeRehabView({
    super.key,
    required super.icon,
    required super.title,
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
  KneeRehabViewState createState() => KneeRehabViewState();
}

class KneeRehabViewState extends StatefulPageState {
  String _dropdownValue = "Pravá noha";

  @override
  Widget buildPage(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
          child: Column(
          children: [
            Padding(padding: const EdgeInsets.symmetric(vertical: 8),
              child: DropdownButton<String>(
                  value: _dropdownValue,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: "Pravá noha", child: Text("Ľavá noha")),
                    DropdownMenuItem(value: "Ľavá noha", child: Text("Pravá noha"))
                  ],
                  onChanged: (value) {
                    setState(() {
                      _dropdownValue = value!;
                    });
                  }
              ),
            ),
            Padding(padding: const EdgeInsets.symmetric(vertical: 8),
            child: GyroView()
            ),
            Padding(padding: const EdgeInsets.symmetric(vertical: 8),
            child: AcclView(),
            ),
          ],
      ),
      ),
    );
  }

}