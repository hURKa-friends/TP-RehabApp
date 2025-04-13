import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rehab_app/arm_rehab/models/arm_model.dart';
import 'package:rehab_app/arm_rehab/views/pos_select_view.dart';
import 'package:rehab_app/services/page_management/models/stateful_page_model.dart';

import 'package:rehab_app/arm_rehab/view_models/repetition_select_view_model.dart';

import 'package:rehab_app/services/page_management/view_models/page_navigator_view_model.dart';

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
    /*bool validValue = false;
    int? repetitions;*/
    //var repetitionSelectViewModel = Provider.of<RepetitionSelectViewModel>(context, listen: false);
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
      floatingActionButton: Visibility(
        visible: repetitionSelectViewModel.validValue,
        child: FloatingActionButton(
          backgroundColor: Colors.lightGreen,
          onPressed: () {
            //_selectPage(context, );
            SelectedOptions.repetitions = repetitionSelectViewModel.repetitions;
          },
          child: Icon(Icons.check),
        ),
      ),
    );
  }
}

void _selectPage(BuildContext context, StatefulPage page) {
  var navigatorViewModel = Provider.of<PageNavigatorViewModel>(context, listen: false);
  navigatorViewModel.selectPage(context, page);
}