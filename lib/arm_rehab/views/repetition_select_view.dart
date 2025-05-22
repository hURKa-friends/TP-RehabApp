import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rehab_app/arm_rehab/models/arm_model.dart';
import 'package:rehab_app/arm_rehab/views/exercise_setpoints_view.dart';
import 'package:rehab_app/services/page_management/models/stateless_page_model.dart';
import 'package:rehab_app/services/page_management/models/tutorial_step_model.dart';

import 'package:rehab_app/arm_rehab/view_models/repetition_select_view_model.dart';

class RepetitionSelectView extends StatelessPage {
  const RepetitionSelectView({
    super.key,
    required super.icon,
    required super.title,
    super.subPages, // Optional
    super.tutorialSteps // Optional
  });

  @override
  void initPage(BuildContext context) {
    // Here you can call page initialization code or reference ViewModel initialization like this:
    var repetitionSelectViewModel = Provider.of<RepetitionSelectViewModel>(
        context, listen: false);

    /// IMPORTANT listen must be false
    repetitionSelectViewModel.onInit();
  }

  @override
  void closePage(BuildContext context) {
    // Here you can call page closing code or reference ViewModel disposal like this:
    var repetitionSelectViewModel = Provider.of<RepetitionSelectViewModel>(
        context, listen: false);

    /// IMPORTANT listen must be false
    repetitionSelectViewModel.onClose();
  }

  @override
  Widget buildPage(BuildContext context) {
    var repetitionSelectViewModel = context.watch<RepetitionSelectViewModel>();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Select how many repetitions you want to do",
              style: headerStyle(),
              textAlign: TextAlign.center,
            ),
            space(40),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 5,
                    style: BorderStyle.solid,
                  ),
                ),
                label: const Text("Input range: 1 - 20"),
              ),
              textAlign: TextAlign.center,
              onSubmitted: (String input) {
                repetitionSelectViewModel.parseInput(input);
              },
            ),
            space(10),
            Text("Selected number of repetitions: ${repetitionSelectViewModel.repetitions}")
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: repetitionSelectViewModel.validValue ? Colors.lightGreen : Colors.grey,
        onPressed: () {
          if (repetitionSelectViewModel.validValue) {
            repetitionSelectViewModel.selectPage(context,
              ExerciseSetpointsView(
                icon: Icons.accessibility_new,
                title: "Arm rehabilitation",
                tutorialSteps: [
                  switch (SelectedOptions.exercise) {
                    1 =>
                    repetitionSelectViewModel.addTutorial(
                      TutorialStep(
                        assetURI: "assets/arm_rehab/images/exercises/front_raises/front_raises.gif",
                        heading: "Raising arms in front of you",
                        description: "In this exercise, you will raise your arms in front of you, and drop them back down. You can hold some sort of stick if you want. Hold your arms straight during the whole exercise.",
                        function: () { SelectedOptions.startTimer = true; }
                      )
                    ),
                    2 =>
                      repetitionSelectViewModel.addTutorial(
                        TutorialStep(assetURI: "assets/arm_rehab/images/exercises/chest_press/chest_press.gif",
                          heading: "Standing chest presses with stick",
                          description: "In this exercise, you will do chest presses while seated or standing. You will need some sort of stick for this exercise, for example a broom.",
                          function: () { SelectedOptions.startTimer = true; }
                        ),
                      ),
                    3 =>
                      repetitionSelectViewModel.addTutorial(
                        TutorialStep(assetURI: "assets/arm_rehab/images/exercises/bicep_curls/bicep_curls.gif",
                          heading: "Bicep curls with stick",
                          description: "In this exercise, you will do bicep curls while seated or standing. You will need some sort of stick for this exercise, for example a broom.",
                          function: () { SelectedOptions.startTimer = true; }
                        ),
                      ),
                    4 =>
                      repetitionSelectViewModel.addTutorial(
                        TutorialStep(assetURI: "assets/arm_rehab/images/exercises/drinking/drinking.gif",
                          heading: "Drinking from glass / bottle",
                          description: "In this exercise, you will drink (imaginary) water. You will need a glass or a bottle. Or you can drink whatever you want. WARNING! Do not drink chemicals or other dangerous liquids!",
                          function: () { SelectedOptions.startTimer = true; }
                        ),
                      ),
                    5 =>
                      repetitionSelectViewModel.addTutorial(
                        TutorialStep(assetURI: "assets/arm_rehab/images/exercises/turning_glass/turning_glass.gif",
                            heading: "Turning glass upside down",
                            description: "In this exercise, you will need a glass. You will be turning the glass upside down, starting with your thumb aiming down.",
                            function: () { SelectedOptions.startTimer = true; }
                        ),
                      ),
                    int() => // Out of range, this shouldn't happen
                      repetitionSelectViewModel.addTutorial(
                        TutorialStep(assetURI: "ErrorImage",
                          heading: "Error",
                          description: "Error",
                          function: () {  }
                        ),
                      ),
                  },
                  repetitionSelectViewModel.addTutorial(
                    TutorialStep(assetURI:
                        switch (SelectedOptions.exercise) {
                          1 => "assets/arm_rehab/images/exercises/front_raises/front_raises.gif",
                          2 => "assets/arm_rehab/images/exercises/chest_press/chest_press.gif",
                          3 => "assets/arm_rehab/images/exercises/bicep_curls/bicep_curls.gif",
                          4 =>"assets/arm_rehab/images/exercises/drinking/drinking.gif",
                          5 => "assets/arm_rehab/images/exercises/turning_glass/turning_glass.gif",
                          int() => "Error" // Out of range, this shouldn't happen
                        },
                        heading: "Setting setpoints",
                        description: "First, you will be setting setpoints. After 3 seconds, a first setpoint will be set for the first part of the exercise, and you will hear a beep. After another 3 seconds, a second setpoint will be set for the second part of the exercise, you will hear a long beep and you can continue to exercise.",
                        function: () { SelectedOptions.startTimer = true; }
                    ),
                  ),
                ]
              ),
            );
            SelectedOptions.repetitions = repetitionSelectViewModel.repetitions;
          }
        },

        child: Icon(Icons.check),
      ),
    );
  }
}
