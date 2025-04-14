import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:rehab_app/view_models/data_acquisition_view_model.dart';

import '../services/page_management/models/stateful_page_model.dart';

class AcqView extends StatefulPage {
  const AcqView({super.key, required super.icon, required super.title, super.tutorialSteps});

  @override
  _AcqViewState createState() => _AcqViewState();

  @override
  void closePage(BuildContext context) {
    var viewModel = Provider.of<AcqViewModel>(context, listen: false); /// IMPORTANT listen must be false
    viewModel.onClose();
  }

  @override
  void initPage(BuildContext context) {
    var viewModel = Provider.of<AcqViewModel>(context, listen: false); /// IMPORTANT listen must be false
    viewModel.onInit();
    //viewModel.registerSensorService();
  }
}

class _AcqViewState extends StatefulPageState {

  @override
  Widget buildPage(BuildContext context) {
    var viewModel = context.watch<AcqViewModel>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(viewModel.on ? 'Pre zastavenie merania stlac Stop' : 'Na zacanie merania stlac Start',
            style: TextStyle(
                fontSize: 20,
                color: Colors.amberAccent),),
        Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Image.asset(viewModel.on ? 'assets/eating_rehab/measure.gif' : 'assets/eating_rehab/click.png')

            ),
          ),

            ElevatedButton(
              onPressed: () {
                viewModel.on ? viewModel.stopStream() : viewModel.startStream();
              },
              child: Text(viewModel.on ? 'Stop Measurement' : 'Start Measurement'),
            ),

      ],
    );
  }
}
