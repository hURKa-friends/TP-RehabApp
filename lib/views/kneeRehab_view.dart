import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rehab_app/services/page_management/models/stateful_page_model.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../view_models/kneeRehab_view_model.dart';

class KneeRehabMainView extends StatefulPage {
  const KneeRehabMainView({super.key, required super.icon, required super.title, super.tutorialSteps, // Optional
      });


  @override
  void initPage(BuildContext context) {
    // Here you can call page initialization code or reference ViewModel initialization like this:
    var kneeRehabViewModel = Provider.of<KneeRehabMainViewModel>(context, listen: false);

    /// IMPORTANT listen must be false

    kneeRehabViewModel.onInit();
  }

  @override
  void closePage(BuildContext context) {
    // Here you can call page closing code or reference ViewModel disposal like this:
    var kneeRehabViewModel = Provider.of<KneeRehabMainViewModel>(context, listen: false);

    /// IMPORTANT listen must be false

    kneeRehabViewModel.onClose();
  }

  @override
  KneeRehabViewState createState() => KneeRehabViewState();
}

class KneeRehabViewState extends StatefulPageState {
  bool isDropdownEnabled = true;
  @override
  Widget buildPage(BuildContext context) {
    var viewModel = context.watch<KneeRehabMainViewModel>();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
        child: Column(
          children: [
            if (viewModel.name == null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Container(
                padding: EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Before beginning the exercise, choose which knee (left or right) you want to focus on.",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: "Roboto",
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: DropdownButton<String>(
                  value: viewModel.name,
                  hint: const Text("CHOOSE KNEE"),
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: "right", child: Text("Right knee")),
                    DropdownMenuItem(value: "left", child: Text("Left knee"))
                  ],
                  onChanged: isDropdownEnabled
                      ? (value) {
                    setState(() {
                      viewModel.name = value!;
                    });
                  }
                      : null,
              ),
            ),
            if (viewModel.name != null && viewModel.start == 0)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        viewModel.start = 1;
                        isDropdownEnabled = false; // Disable dropdown
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(200, 70),
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      backgroundColor: Color.fromRGBO(255, 187, 51, 0.7),
                      foregroundColor: Colors.black,
                    ),
                    child: const Text("Begin exercise.")),
              ),
            if (viewModel.start == 1)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        viewModel.start = 0;
                        viewModel.name = null;
                        isDropdownEnabled = true; // Re-enable dropdown
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(200, 70),
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      backgroundColor: Color.fromRGBO(255, 187, 51, 0.7),
                      foregroundColor: Colors.black,
                    ),
                    child: const Text("End exercise.")),
              ),
          ],
        ),
      ),
    );
  }
}
