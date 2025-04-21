import 'package:flutter/material.dart';
import 'package:rehab_app/services/page_management/models/stateful_page_model.dart';

class FingersTrackingExercisesView extends StatefulPage {
  const FingersTrackingExercisesView({
    super.key,
    required super.icon,
    required super.title,
    super.tutorialSteps
  });

  @override
  void initPage(BuildContext context) {
    // Intentionally left empty as no setup is needed here
  }

  @override
  void closePage(BuildContext context) {
    // Intentionally left empty as no cleanup is needed here
  }

  @override
  FingersTrackingExercisesViewState createState() => FingersTrackingExercisesViewState();
}

class FingersTrackingExercisesViewState extends StatefulPageState {
  bool _checkboxValue = false;
  bool _switchValue = false;
  double _sliderValue = 0.5;
  String _dropdownValue = 'Option 1';

  @override
  Widget buildPage(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Elevated Button'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: OutlinedButton(
                onPressed: () {},
                child: const Text('Outlined Button'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextButton(
                onPressed: () {},
                child: const Text('Text Button'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}