import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rehab_app/arm_rehab/models/arm_model.dart';
import 'package:rehab_app/arm_rehab/views/exercise_start_view.dart';
import 'package:rehab_app/services/page_management/models/stateless_page_model.dart';

import 'package:rehab_app/arm_rehab/view_models/exercise_setpoints_view_model.dart';

class ExerciseSetpointsView extends StatelessPage {
  const ExerciseSetpointsView({
    super.key,
    required super.icon,
    required super.title,
    super.subPages, // Optional
    super.tutorialSteps // Optional
  });

  @override
  void initPage(BuildContext context) {
    // Here you can call page initialization code or reference ViewModel initialization like this:
    var exerciseSetpointsViewModel = Provider.of<ExerciseSetpointsViewModel>(context, listen: false); /// IMPORTANT listen must be false
    exerciseSetpointsViewModel.onInit();
  }

  @override
  void closePage(BuildContext context) {
    // Here you can call page closing code or reference ViewModel disposal like this:
    var exerciseSetpointsViewModel = Provider.of<ExerciseSetpointsViewModel>(context, listen: false); /// IMPORTANT listen must be false
    exerciseSetpointsViewModel.onClose();
  }

  @override
  Widget buildPage(BuildContext context) {
    var exerciseSetpointsViewModel = context.watch<ExerciseSetpointsViewModel>();

    return Scaffold(
      body: Center(
        child: exerciseSetpointsViewModel.isTimerActive
        ?
          Text(
            "${exerciseSetpointsViewModel.timerCount}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 48),
          )
        :
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              space(15),
              Text("Setting setpoints for:", style: headerStyle(), textAlign: TextAlign.center,),
              space(15),
              Text(
              switch (SelectedOptions.exercise) {
                1 => "Lifting arms in front of you",
                2 => "Standing chest presses with stick",
                3 => "Bicep curls with stick",
                4 => "Drinking from glass / bottle",
                5 => "Turning glass upside down",
                int() => "Error", // Out of range, this shouldn't happen
              },
                style: headerStyle(),
                textAlign: TextAlign.center,
              ),
              space(50),
              Text("Go to this position", style: headerStyle(),),
              space(20),
              SizedBox(
                height: exerciseSetpointsViewModel.imageSize,
                width: exerciseSetpointsViewModel.imageSize,
                child: Image.asset(
                  switch (SelectedOptions.exercise) {
                  1 =>
                    switch (exerciseSetpointsViewModel.nextSetpoint) {
                    0 => "assets/arm_rehab/images/exercises/front_raises/front_raises0.png",
                    1 => "assets/arm_rehab/images/exercises/front_raises/front_raises1.png",
                    int() => "assets/arm_rehab/images/exercises/front_raises/front_raises1.png",
                    },
                  2 =>
                    switch (exerciseSetpointsViewModel.nextSetpoint) {
                      0 => "assets/arm_rehab/images/exercises/chest_press/chest_press0.png",
                      1 => "assets/arm_rehab/images/exercises/chest_press/chest_press1.png",
                      int() => "assets/arm_rehab/images/exercises/chest_press/chest_press1.png",
                    },
                  3 =>
                    switch (exerciseSetpointsViewModel.nextSetpoint) {
                      0 => "assets/arm_rehab/images/exercises/bicep_curls/bicep_curls0.png",
                      1 => "assets/arm_rehab/images/exercises/bicep_curls/bicep_curls1.png",
                      int() => "assets/arm_rehab/images/exercises/bicep_curls/bicep_curls1.png",
                    },
                  4 =>
                    switch (exerciseSetpointsViewModel.nextSetpoint) {
                      0 => "assets/arm_rehab/images/exercises/drinking/drinking0.png",
                      1 => "assets/arm_rehab/images/exercises/drinking/drinking1.png",
                      int() => "assets/arm_rehab/images/exercises/drinking/drinking1.png",
                    },
                  5 =>
                    switch (exerciseSetpointsViewModel.nextSetpoint) {
                      0 => "assets/arm_rehab/images/exercises/turning_glass/turning_glass0.jpg",
                      1 => "assets/arm_rehab/images/exercises/turning_glass/turning_glass1.jpg",
                      int() => "assets/arm_rehab/images/exercises/turning_glass/turning_glass1.jpg",
                    },
                  int() => "ErrorImage", // Out of range, this shouldn't happen
                  },
                ),
              ),
              space(50),
              /*Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //Text(exerciseSetpointsViewModel.currentX.toStringAsFixed(3), style: headerStyle(),),
                  //Text(exerciseSetpointsViewModel.currentY.toStringAsFixed(3), style: headerStyle(),),
                  //Text(exerciseSetpointsViewModel.currentZ.toStringAsFixed(3), style: headerStyle(),),
                  Text("Roll: ${Angles.currentAngleX.toStringAsFixed(3)}"),
                  Text("Pitch: ${Angles.currentAngleY.toStringAsFixed(3)}"),
                  Text("Yaw: ${Angles.currentAngleZ.toStringAsFixed(3)}"),
                ],
              ),*/
            ],
          ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: exerciseSetpointsViewModel.setpointsSet ? Colors.lightGreen : Colors.grey,
        onPressed: () {
          if (exerciseSetpointsViewModel.setpointsSet) {
            SelectedOptions.startTimer = true;
            exerciseSetpointsViewModel.selectPage(context,
              ExerciseStartView(
                  icon: Icons.accessibility_new,
                  title: "Arm rehabilitation",
              ),
            );
          }
        },

        child: Icon(Icons.check),
      ),
    );
  }
}
