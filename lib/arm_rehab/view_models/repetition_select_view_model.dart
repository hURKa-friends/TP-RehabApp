import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rehab_app/services/page_management/models/stateless_page_model.dart';
import 'package:rehab_app/services/page_management/models/tutorial_step_model.dart';
import 'package:rehab_app/services/page_management/view_models/page_navigator_view_model.dart';

class RepetitionSelectViewModel extends ChangeNotifier {
  late bool _validValue;
  late int _repetitions;

  RepetitionSelectViewModel() {
    // Default constructor
  }

  Future<void> onInit() async {
    // Here you can call ViewModel initialization code.
    _validValue = false;
    _repetitions = 0;
  }

  void onClose() {
    // Here you can call ViewModel disposal code.
    _validValue = false;
    _repetitions = 0;
  }

  void parseInput(String input) {
    int? reps = int.tryParse(input);

    if (reps == null || reps < 1 || reps > 50) {
      _repetitions = 0;
      _validValue = false;

      notifyListeners();

      return;
    }

    _repetitions = reps;
    _validValue = true;

    notifyListeners();
  }

  void selectPage(BuildContext context, StatelessPage page) {
    var navigatorViewModel = Provider.of<PageNavigatorViewModel>(context, listen: false);
    navigatorViewModel.selectPage(context, page);
  }

  List<TutorialStep> addTutorial(TutorialStep tutorial) {
    List<TutorialStep> tutorialList = [tutorial];

    return tutorialList;
  }

  bool get validValue => _validValue;
  int get repetitions => _repetitions;
}