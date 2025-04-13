import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rehab_app/arm_rehab/models/arm_model.dart';
import 'package:rehab_app/arm_rehab/views/exercise_start_view.dart';
import 'package:rehab_app/services/page_management/models/stateful_page_model.dart';

import 'package:rehab_app/arm_rehab/view_models/repetition_select_view_model.dart';

class RepetitionSelectView extends StatefulPage {
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
  RepetitionSelectState createState() => RepetitionSelectState();
}

class RepetitionSelectState extends StatefulPageState {
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
                label: const Text("Input range: 1 - 100"),
              ),
              textAlign: TextAlign.center,
              onSubmitted: (String input) {
                repetitionSelectViewModel.parseInput(input);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightGreen,
        onPressed: () {
          if (repetitionSelectViewModel.validValue) {
            // ROZHODNUT SA CI STLESS ALEBO STFUL
            //repetitionSelectViewModel.selectPage(context, ExerciseStartView(icon: Icons.accessibility_new, title: "Arm rehabilitation"));
            SelectedOptions.repetitions = repetitionSelectViewModel.repetitions;
          }
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
