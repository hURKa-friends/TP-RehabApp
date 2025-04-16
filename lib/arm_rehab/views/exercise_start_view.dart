import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rehab_app/arm_rehab/models/arm_model.dart';
import 'package:rehab_app/arm_rehab/views/pos_select_view.dart';
import 'package:rehab_app/services/page_management/models/stateful_page_model.dart';

import 'package:rehab_app/arm_rehab/view_models/exercise_start_view_model.dart';

class ExerciseStartView extends StatefulPage {
  const ExerciseStartView({
    super.key,
    required super.icon,
    required super.title,
    super.subPages, // Optional
    super.tutorialSteps // Optional
  });

  @override
  void initPage(BuildContext context) {
    // Here you can call page initialization code or reference ViewModel initialization like this:
    var exerciseStartViewModel = Provider.of<ExerciseStartViewModel>(context, listen: false); /// IMPORTANT listen must be false
    exerciseStartViewModel.onInit();
  }

  @override
  void closePage(BuildContext context) {
    // Here you can call page closing code or reference ViewModel disposal like this:
    var exerciseStartViewModel = Provider.of<ExerciseStartViewModel>(context, listen: false); /// IMPORTANT listen must be false
    exerciseStartViewModel.onClose();
  }

  @override
  ExerciseStartState createState() => ExerciseStartState();
}

class ExerciseStartState extends StatefulPageState {
  @override
  Widget buildPage(BuildContext context) {
    var exerciseStartViewModel = context.watch<ExerciseStartViewModel>();

    return Scaffold(
      body: Center(
        child: exerciseStartViewModel.isTimerActive
        ?
          Text(
            "${exerciseStartViewModel.timerCount}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 48),
          )
        :
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              space(15),
              switch (SelectedOptions.exercise) {
                1 =>
                  Text(
                    "Retraction of shoulder blades",
                    style: headerStyle(),
                    textAlign: TextAlign.center,
                  ),
                2 =>
                  Text(
                    "Chest presses with stick",
                    style: headerStyle(),
                    textAlign: TextAlign.center,
                  ),
                3 =>
                  Text(
                    "Bicep curls with stick",
                    style: headerStyle(),
                    textAlign: TextAlign.center,
                  ),
                4 =>
                  Text(
                    "Drinking from glass / bottle",
                    style: headerStyle(),
                    textAlign: TextAlign.center,
                  ),
                int() => Text( // Out of range, this shouldn't happen
                  "Drinking from glass / bottle",
                  style: headerStyle(),
                  textAlign: TextAlign.center,
                ),
              }
            ],
          ),
      ),
    );
  }
}
