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
          children: [
            Text(
              "Select orientation of your phone (camera aims towards your head)",
              style: headerStyle(),
              textAlign: TextAlign.center,
            ),
            space(30),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: AlwaysScrollableScrollPhysics(),
                children: <Widget>[
                  SizedBox(
                    width: orientSelectViewModel.imageSize,
                    height: orientSelectViewModel.imageSize,
                    child: IconButton(
                      onPressed:() {
                        orientSelectViewModel.selectPage(context, RepetitionSelectView(icon: Icons.accessibility_new, title: "Arm rehabilitation"));
                        SelectedOptions.orient = SelectedOrient.frontUp;
                      },
                      icon: Image.asset("assets/arm_rehab/orient_front_up.jpg"),
                    ),
                  ),
                  space(10),
                  SizedBox(
                    width: orientSelectViewModel.imageSize,
                    height: orientSelectViewModel.imageSize,
                    child: IconButton(
                      onPressed:() {
                        orientSelectViewModel.selectPage(context, RepetitionSelectView(icon: Icons.accessibility_new, title: "Arm rehabilitation"));
                        SelectedOptions.orient = SelectedOrient.frontDown;
                      },
                      icon: Image.asset("assets/arm_rehab/orient_front_down.jpg"),
                    ),
                  ),
                  space(10),
                  SizedBox(
                    width: orientSelectViewModel.imageSize,
                    height: orientSelectViewModel.imageSize,
                    child: IconButton(
                      onPressed:() {
                        orientSelectViewModel.selectPage(context, RepetitionSelectView(icon: Icons.accessibility_new, title: "Arm rehabilitation"));
                        SelectedOptions.orient = SelectedOrient.backUp;
                      },
                      icon: Image.asset("assets/arm_rehab/orient_back_up.jpg"),
                    ),
                  ),
                  space(10),
                  SizedBox(
                    width: orientSelectViewModel.imageSize,
                    height: orientSelectViewModel.imageSize,
                    child: IconButton(
                      onPressed:() {
                        orientSelectViewModel.selectPage(context, RepetitionSelectView(icon: Icons.accessibility_new, title: "Arm rehabilitation"));
                        SelectedOptions.orient = SelectedOrient.backDown;
                      },
                      icon: Image.asset("assets/arm_rehab/orient_back_down.jpg"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
