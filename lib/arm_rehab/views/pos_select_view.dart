import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rehab_app/arm_rehab/models/arm_model.dart';
import 'package:rehab_app/arm_rehab/views/orient_select_view.dart';
import 'package:rehab_app/services/page_management/models/stateless_page_model.dart';

import 'package:rehab_app/arm_rehab/view_models/pos_select_view_model.dart';

class PosSelectView extends StatelessPage {
  const PosSelectView({
    super.key,
    required super.icon,
    required super.title,
    super.subPages, // Optional
    super.tutorialSteps // Optional
  });

  @override
  void initPage(BuildContext context) {
    // Here you can call page initialization code or reference ViewModel initialization like this:
    var posSelectViewModel = Provider.of<PosSelectViewModel>(context, listen: false); /// IMPORTANT listen must be false
    posSelectViewModel.onInit();
  }

  @override
  void closePage(BuildContext context) {
    // Here you can call page closing code or reference ViewModel disposal like this:
    var posSelectViewModel = Provider.of<PosSelectViewModel>(context, listen: false); /// IMPORTANT listen must be false
    posSelectViewModel.onClose();
  }

  @override
  Widget buildPage(BuildContext context) {
    var posSelectViewModel = context.watch<PosSelectViewModel>();

    return Scaffold(
      body: Center(
        child: (SelectedOptions.exercise != 3)
          ?
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Select position of your phone",
                  style: headerStyle(),
                  textAlign: TextAlign.center,
                ),
                space(40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: posSelectViewModel.imageHeight,
                      width: posSelectViewModel.imageWidth,
                      child: IconButton(
                        onPressed:() {
                          posSelectViewModel.selectPage(context, OrientSelectView(icon: Icons.accessibility_new, title: "Arm rehabilitation"));
                          SelectedOptions.pos = SelectedPos.shoulder;
                        },
                        icon: Image.asset("assets/arm_rehab/shoulder.png"),
                      ),
                    ),
                    space(20),
                    SizedBox(
                      height: posSelectViewModel.imageHeight,
                      width: posSelectViewModel.imageWidth,
                      child: IconButton(
                        onPressed: () {
                          posSelectViewModel.selectPage(context, OrientSelectView(icon: Icons.accessibility_new, title: "Arm rehabilitation"));
                          SelectedOptions.pos = SelectedPos.wrist;
                        },
                        icon: Image.asset("assets/arm_rehab/wrist.png"),
                      ),
                    ),
                  ],
                ),
                space(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Shoulder",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        letterSpacing: 1.0,
                      ),
                    ),
                    space(125),
                    Text(
                      "Wrist",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        letterSpacing: 1.0,
                      ),
                    ),
                    space(20),
                  ],
                )
              ],
            )
          :
            Text(
              "During this exercise, you can have your phone on your wrist only",
              style: headerStyle(),
              textAlign: TextAlign.center,
            ),
        ),
      floatingActionButton: posSelectViewModel.wristOnlyFloatingButton(
        SelectedOptions.exercise,
        () {
          posSelectViewModel.selectPage(context, OrientSelectView(icon: Icons.accessibility_new, title: "Arm rehabilitation"));
        }
      ),
    );
  }
}
