import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rehab_app/arm_rehab/models/arm_model.dart';
import 'package:rehab_app/arm_rehab/views/repetition_select_view.dart';
import 'package:rehab_app/services/page_management/models/stateless_page_model.dart';

import 'package:rehab_app/arm_rehab/view_models/orient_select_view_model.dart';

class OrientSelectView extends StatelessPage {
  const OrientSelectView({
    super.key,
    required super.icon,
    required super.title,
    super.subPages, // Optional
    super.tutorialSteps // Optional
  });

  @override
  void initPage(BuildContext context) {
    // Here you can call page initialization code or reference ViewModel initialization like this:
    var orientSelectViewModel = Provider.of<OrientSelectViewModel>(context, listen: false); /// IMPORTANT listen must be false
    orientSelectViewModel.onInit();
  }

  @override
  void closePage(BuildContext context) {
    // Here you can call page closing code or reference ViewModel disposal like this:
    var orientSelectViewModel = Provider.of<OrientSelectViewModel>(context, listen: false); /// IMPORTANT listen must be false
    orientSelectViewModel.onClose();
  }

  @override
  Widget buildPage(BuildContext context) {
    var orientSelectViewModel = context.watch<OrientSelectViewModel>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Please orient your phone so that camera and display aim away from you\n(See below)",
              style: headerStyle(),
              textAlign: TextAlign.center,
            ),
            Image.asset("assets/arm_rehab/images/settings/orient_select/armband_rotated.jpg"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          orientSelectViewModel.selectPage(context, RepetitionSelectView(icon: Icons.accessibility_new, title: "Arm rehabilitation"));
        },
        backgroundColor: Colors.lightGreen,
        child: Icon(Icons.check),
      ),
    );
  }
}
