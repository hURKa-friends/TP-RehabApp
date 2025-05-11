import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rehab_app/arm_rehab/models/arm_model.dart';
import 'package:rehab_app/arm_rehab/views/exercise_start_view.dart';
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
              ExerciseStartView(
                    icon: Icons.accessibility_new,
                    title: "Arm rehabilitation",
                    tutorialSteps:
                      switch (SelectedOptions.exercise) {
                        1 =>
                        repetitionSelectViewModel.addTutorial(
                          TutorialStep(
                            assetURI: "assets/images/exercises/arm_lift/arm_lift.gif",
                            heading: "Lifting arms in front of you",
                            description: "In this exercise, you will lift your arms in front of you, and drop them back down. Hold your arms straight during the whole exercise.",
                            function: () { SelectedOptions.startTimer = true; }
                          )
                        ),
                        2 =>
                          repetitionSelectViewModel.addTutorial(
                            TutorialStep(assetURI: "assets/images/exercises/chest_press/chest_press.gif",
                              heading: "Chest presses with stick",
                              description: "In this exercise, you will do chest presses while seated or standing. You will need some sort of stick for this exercise, for example a broom.",
                              function: () { SelectedOptions.startTimer = true; }
                            ),
                          ),
                        3 =>
                          repetitionSelectViewModel.addTutorial(
                            TutorialStep(assetURI: "assets/images/exercises/bicep_curls/bicep_curls.gif",
                              heading: "Bicep curls with stick",
                              description: "In this exercise, you will do bicep curls while seated or standing. You will need some sort of stick for this exercise, for example a broom.",
                              function: () { SelectedOptions.startTimer = true; }
                            ),
                          ),
                        4 =>
                          repetitionSelectViewModel.addTutorial(
                            TutorialStep(assetURI: "assets/images/exercises/drinking/drinking.gif",
                              heading: "Drinking from glass / bottle",
                              description: "In this exercise, you will drink (imaginary) water. You will need a glass or a bottle. Or you can drink whatever you want. WARNING! Do not drink chemicals or other dangerous liquids!",
                              function: () { SelectedOptions.startTimer = true; }
                            ),
                          ),
                        5 =>
                          repetitionSelectViewModel.addTutorial(
                            TutorialStep(assetURI: "assets/images/exercises/turning_glass/turning_glass.gif",
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
                      }
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
