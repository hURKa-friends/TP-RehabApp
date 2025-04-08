import 'package:flutter/material.dart';
import 'package:rehab_app/services/page_management/models/stateful_page_model.dart';

class ExampleView extends StatefulPage {
  const ExampleView({
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
  ExampleViewState createState() => ExampleViewState();
}

class ExampleViewState extends StatefulPageState {
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Text Field',
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) {}, // Just to be "active"
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: CheckboxListTile(
                title: const Text("Checkbox"),
                value: _checkboxValue,
                onChanged: (value) {
                  setState(() {
                    _checkboxValue = value!;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SwitchListTile(
                title: const Text("Switch"),
                value: _switchValue,
                onChanged: (value) {
                  setState(() {
                    _switchValue = value;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Slider"),
                  Slider(
                    value: _sliderValue,
                    onChanged: (value) {
                      setState(() {
                        _sliderValue = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: DropdownButton<String>(
                value: _dropdownValue,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 'Option 1', child: Text('Option 1')),
                  DropdownMenuItem(value: 'Option 2', child: Text('Option 2')),
                ],
                onChanged: (value) {
                  setState(() {
                    _dropdownValue = value!;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}