import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rehab_app/arm_rehab/models/arm_model.dart';
import 'package:rehab_app/arm_rehab/views/pos_select_view.dart';
import 'package:rehab_app/services/page_management/models/stateless_page_model.dart';

import 'package:rehab_app/arm_rehab/view_models/arm_select_view_model.dart';

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
    var armSelectViewModel = context.watch<ArmSelectViewModel>();

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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: armSelectViewModel.imageSize,
                    width: armSelectViewModel.imageSize,
                    child: IconButton(
                      onPressed: () {
                        armSelectViewModel.selectPage(context, PosSelectView(icon: Icons.accessibility_new, title: "Arm rehabilitation"));
                        SelectedOptions.arm = SelectedArm.left;
                      },
                      icon: Image.asset("assets/arm_rehab/images/settings/arm_select/left_hand.jpg"),
                    ),
                  ),
                  space(20),
                  SizedBox(
                    height: armSelectViewModel.imageSize,
                    width: armSelectViewModel.imageSize,
                    child: IconButton(
                      onPressed:() {
                        armSelectViewModel.selectPage(context, PosSelectView(icon: Icons.accessibility_new, title: "Arm rehabilitation"));
                        SelectedOptions.arm = SelectedArm.right;
                      },
                      icon: Image.asset("assets/arm_rehab/images/settings/arm_select/right_hand.jpg"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
    );
  }
}
