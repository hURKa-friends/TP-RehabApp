import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rehab_app/arm_rehab/models/arm_model.dart';
import 'package:rehab_app/arm_rehab/views/pos_select_view.dart';
import 'package:rehab_app/services/page_management/models/stateless_page_model.dart';

import 'package:rehab_app/arm_rehab/view_models/exercise_summary_view_model.dart';

class ExerciseSummaryView extends StatelessPage {
  const ExerciseSummaryView({
    super.key,
    required super.icon,
    required super.title,
    super.subPages, // Optional
    super.tutorialSteps // Optional
  });

  @override
  void initPage(BuildContext context) {
    // Here you can call page initialization code or reference ViewModel initialization like this:
    var exerciseSummaryViewModel = Provider.of<ExerciseSummaryViewModel>(context, listen: false); /// IMPORTANT listen must be false
    exerciseSummaryViewModel.onInit();
  }

  @override
  void closePage(BuildContext context) {
    // Here you can call page closing code or reference ViewModel disposal like this:
    var exerciseSummaryViewModel = Provider.of<ExerciseSummaryViewModel>(context, listen: false); /// IMPORTANT listen must be false
    exerciseSummaryViewModel.onClose();
  }

  @override
  Widget buildPage(BuildContext context) {
    var exerciseSummaryViewModel = context.watch<ExerciseSummaryViewModel>();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Exercise finished!",
              style: headerStyle(),
            ),
          ],
        ),
      ),
    );
  }
}
