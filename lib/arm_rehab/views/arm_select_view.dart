import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rehab_app/arm_rehab/models/arm_model.dart';
import 'package:rehab_app/arm_rehab/views/pos_select_view.dart';
import 'package:rehab_app/services/page_management/models/stateless_page_model.dart';

import 'package:rehab_app/arm_rehab/view_models/arm_select_view_model.dart';

import 'package:rehab_app/services/page_management/view_models/page_navigator_view_model.dart';

class ArmSelectView extends StatelessPage {
  const ArmSelectView({
    super.key,
    required super.icon,
    required super.title,
    super.subPages, // Optional
    super.tutorialSteps // Optional
  });

  @override
  void initPage(BuildContext context) {
    // Here you can call page initialization code or reference ViewModel initialization like this:
    var armSelectViewModel = Provider.of<ArmSelectViewModel>(context, listen: false); /// IMPORTANT listen must be false
    armSelectViewModel.onInit();
  }

  @override
  void closePage(BuildContext context) {
    // Here you can call page closing code or reference ViewModel disposal like this:
    var armSelectViewModel = Provider.of<ArmSelectViewModel>(context, listen: false); /// IMPORTANT listen must be false
    armSelectViewModel.onClose();
  }

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Select which arm you want to rehabilitate",
                style: headerStyle(),
                textAlign: TextAlign.center,
              ),
              space(40),
              ElevatedButton(
                onPressed:() {
                  _selectPage(context, PosSelectView(icon: Icons.accessibility_new, title: "Arm rehabilitation"));
                  SelectedOptions.arm = SelectedArm.right;
                },
                child: Text(
                  "Right",
                  style: buttonTextStyle(),
                ),
              ),
              space(20),
              ElevatedButton(
                onPressed: () {
                  _selectPage(context, PosSelectView(icon: Icons.accessibility_new, title: "Arm rehabilitation"));
                  SelectedOptions.arm = SelectedArm.left;
                },
                child: Text(
                  "Left",
                  style: buttonTextStyle(),
                ),
              ),
            ],
          ),
        ),
    );
  }
}

void _selectPage(BuildContext context, StatelessPage page) {
  var navigatorViewModel = Provider.of<PageNavigatorViewModel>(context, listen: false);
  navigatorViewModel.selectPage(context, page);
}