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
              Text(
              switch (SelectedOptions.exercise) {
                1 => "Retraction of shoulder blades",
                2 => "Chest presses with stick",
                3 => "Bicep curls with stick",
                4 => "Drinking from glass / bottle",
                int() => "Error", // Out of range, this shouldn't happen
              },
              style: headerStyle(),
                textAlign: TextAlign.center,
              ),
              space(100),
              Image.asset(
                switch (SelectedOptions.exercise) {
                1 =>
                  switch (exerciseStartViewModel.nextSetpoint) {
                  0 => "assets/arm_rehab/images/exercises/shoulder_blades/shoulder_blades0",
                  1 => "assets/arm_rehab/images/exercises/shoulder_blades/shoulder_blades1",
                  int() => "ErrorImage", // Out of range, this shouldn't happen
                  },
                2 =>
                  switch (exerciseStartViewModel.nextSetpoint) {
                    0 => "assets/arm_rehab/images/exercises/chest_press/chest_press0",
                    1 => "assets/arm_rehab/images/exercises/chest_press/chest_press1",
                    int() => "ErrorImage", // Out of range, this shouldn't happen
                  },
                3 =>
                  switch (exerciseStartViewModel.nextSetpoint) {
                    0 => "assets/arm_rehab/images/exercises/bicep_curls/bicep_curls0",
                    1 => "assets/arm_rehab/images/exercises/bicep_curls/bicep_curls1",
                    int() => "ErrorImage", // Out of range, this shouldn't happen
                  },
                4 =>
                  switch (exerciseStartViewModel.nextSetpoint) {
                    0 => "assets/arm_rehab/images/exercises/drinking/drinking0",
                    1 => "assets/arm_rehab/images/exercises/drinking/drinking1",
                    int() => "ErrorImage", // Out of range, this shouldn't happen
                  },
                int() => "ErrorImage", // Out of range, this shouldn't happen
                },
              ),
              space(15),
              Text("Number of repetitions"),
              Text(
                "${exerciseStartViewModel.repetitionCount} / ${SelectedOptions.repetitions}",
                style: headerStyle(),
              ),
            ],
          ),
      ),
    );
  }
}
