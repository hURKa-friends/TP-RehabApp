import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rehab_app/arm_rehab/models/arm_model.dart';
import 'package:rehab_app/arm_rehab/views/repetition_select_view.dart';
import 'package:rehab_app/services/page_management/models/stateless_page_model.dart';
import 'package:rehab_app/services/page_management/models/stateful_page_model.dart';

import 'package:rehab_app/services/page_management/view_models/page_navigator_view_model.dart';

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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Row( // Exercise
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          "Retract shoulder blades",
                        ),
                      ),
                      space(40),
                      Flexible(
                        child: Text(
                          "In this exercise, you hold your hands together,"
                          "arms straight, and retract your shoulder blades.",
                        ),
                      ),
                      space(40),
                      ElevatedButton(
                        onPressed: () {
                          _selectPage(context, RepetitionSelectView(icon: Icons.accessibility_new, title: "Arm rehabilitation"));
                          SelectedOptions.exercise = 1;
                        },
                        child: Text(
                          "Select",
                          style: buttonTextStyle(),
                        ),
                      ),
                    ],
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

void _selectPage(BuildContext context, StatefulPage page) {
  var navigatorViewModel = Provider.of<PageNavigatorViewModel>(context, listen: false);
  navigatorViewModel.selectPage(context, page);
}