import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rehab_app/arm_rehab/models/arm_model.dart';
import 'package:rehab_app/arm_rehab/views/arm_select_view.dart';
import 'package:rehab_app/services/page_management/models/stateless_page_model.dart';

import 'package:rehab_app/arm_rehab/view_models/exercise_select_view_model.dart';

class ExerciseSelectView extends StatelessPage {
  const ExerciseSelectView({
    super.key,
    required super.icon,
    required super.title,
    super.subPages, // Optional
    super.tutorialSteps // Optional
  });

  @override
  void initPage(BuildContext context) {
    // Here you can call page initialization code or reference ViewModel initialization like this:
    var exerciseSelectViewModel = Provider.of<ExerciseSelectViewModel>(context, listen: false); /// IMPORTANT listen must be false
    exerciseSelectViewModel.onInit();
  }

  @override
  void closePage(BuildContext context) {
    // Here you can call page closing code or reference ViewModel disposal like this:
    var exerciseSelectViewModel = Provider.of<ExerciseSelectViewModel>(context, listen: false); /// IMPORTANT listen must be false
    exerciseSelectViewModel.onClose();
  }

  @override
  Widget buildPage(BuildContext context) {
    var exerciseSelectViewModel = context.watch<ExerciseSelectViewModel>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Select your exercise",
              style: headerStyle(),
            ),
            space(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Name",
                  style: headerStyle(),
                ),
                space(40),
                Text(
                  "Description",
                  style: headerStyle(),
                ),
              ],
            ),
            space(10),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: AlwaysScrollableScrollPhysics(),
                children: <Widget>[
                  exercise(
                    "Retraction of shoulder blades",
                    1,
                    () {
                      exerciseSelectViewModel.selectPage(context, ArmSelectView(icon: Icons.accessibility_new, title: "Arm rehabilitation"));
                    }
                  ),
                  space(25),
                  exercise(
                      "Chest presses with stick",
                      2,
                      () {
                        exerciseSelectViewModel.selectPage(context, ArmSelectView(icon: Icons.accessibility_new, title: "Arm rehabilitation"));
                      }
                  ),
                  space(25),
                  exercise(
                      "Bicep curls with stick",
                      3,
                      () {
                        exerciseSelectViewModel.selectPage(context, ArmSelectView(icon: Icons.accessibility_new, title: "Arm rehabilitation"));
                      }
                  ),
                  space(25),
                  exercise(
                      "Drinking from glass / bottle",
                      4,
                      () {
                        exerciseSelectViewModel.selectPage(context, ArmSelectView(icon: Icons.accessibility_new, title: "Arm rehabilitation"));
                      }
                  ),
                  space(25),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
