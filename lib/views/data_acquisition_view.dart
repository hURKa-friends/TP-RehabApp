import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:rehab_app/view_models/data_acquisition_view_model.dart';
import 'package:vibration/vibration.dart';

import '../services/page_management/models/stateful_page_model.dart';

class AcqView extends StatefulPage {
  const AcqView(
      {super.key,
      required super.icon,
      required super.title,
      super.tutorialSteps});

  @override
  _AcqViewState createState() => _AcqViewState();

  @override
  void closePage(BuildContext context) {
    var viewModel = Provider.of<AcqViewModel>(context, listen: false);

    /// IMPORTANT listen must be false
    viewModel.onClose();
  }

  @override
  void initPage(BuildContext context) {
    var viewModel = Provider.of<AcqViewModel>(context, listen: false);

    /// IMPORTANT listen must be false
    viewModel.onInit();
    //viewModel.registerSensorService();
  }
}

// Determine border color based on state
Color getBorderColor(AcqViewModel viewModel) {
  if (viewModel.wasImpactDetected()) return Colors.red;
  if (viewModel.isHandShaking()) return Colors.blue;
  return Colors.grey.shade300;
}

class _AcqViewState extends StatefulPageState {
  @override
  Widget buildPage(BuildContext context) {
    var viewModel = context.watch<AcqViewModel>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Instruction text
        Text(
          viewModel.on
              ? 'Pre zastavenie merania stlač Stop'
              : 'Na začatie merania stlač Štart',
          style: TextStyle(fontSize: 20, color: Colors.amberAccent),
        ),

        // Switches before measurement, alerts and repetition during measurement
        Container(
          height: 160,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: viewModel.on
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Opakovania: ${viewModel.getRepetitionCount()}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              if (viewModel.shouldShowImpactWarning())
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    '⚠️ Náraz detekovaný!',
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                ),
              if (viewModel.shouldShowShakingWarning())
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    '⚠️ Ruka sa trasie!',
                    style: TextStyle(fontSize: 18, color: Colors.orange),
                  ),
                ),
            ],
          )
              : Column(
            children: [
              Visibility(
                visible: !viewModel.on,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: SwitchListTile(
                    title: Text(viewModel.isFork ? 'Vydlička' : 'Lyžička'),
                    value: viewModel.isFork,
                    onChanged: (value) {
                      setState(() {
                        viewModel.isFork = value;
                      });
                    },
                  ),
                ),
              ),
              Visibility(
                visible: !viewModel.on,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: SwitchListTile(
                    title: Text(viewModel.isLeft ? 'Ľavá ruka' : 'Pravá ruka'),
                    value: viewModel.isLeft,
                    onChanged: (value) {
                      setState(() {
                        viewModel.isLeft = value;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),


        // Treshold sliders for testing
        // Container(
        //   padding: const EdgeInsets.all(12),
        //   decoration: BoxDecoration(
        //     color: Colors.grey.shade100,
        //     borderRadius: BorderRadius.circular(12),
        //   ),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Text("Impact Threshold: ${viewModel.impactThreshold.toStringAsFixed(1)}"),
        //       Slider(
        //         min: 5,
        //         max: 30,
        //         divisions: 25,
        //         value: viewModel.impactThreshold,
        //         onChanged: viewModel.on
        //             ? null // Disable while measuring
        //             : (value) {
        //           viewModel.setImpactThreshold(value);
        //         },
        //       ),
        //       SizedBox(height: 12),
        //       Text("Shaking Variance Threshold: ${viewModel.shakingVarianceThreshold.toStringAsFixed(2)}"),
        //       Slider(
        //         min: 0.5,
        //         max: 10.0,
        //         divisions: 95,
        //         value: viewModel.shakingVarianceThreshold,
        //         onChanged: viewModel.on
        //             ? null // Disable while measuring
        //             : (value) {
        //           viewModel.setShakingVarianceThreshold(value);
        //         },
        //       ),
        //     ],
        //   ),
        // ),


        //Image with colored border (based on state)
        Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: viewModel.shouldShowImpactWarning()
                    ? Colors.red
                    : viewModel.shouldShowShakingWarning()
                    ? Colors.blue
                    : Colors.transparent,
                width: 5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Image.asset(viewModel.on
                ? 'assets/eating_rehab/measure.gif'
                : 'assets/eating_rehab/click.png'),
          ),
        ),

        // Countdown display (3, 2, 1)
        StreamBuilder<String>(
          stream: viewModel.countdownController.stream,
          builder: (context, snapshot) {
            return Text(
              snapshot.hasData ? snapshot.data! : '',
              style: TextStyle(fontSize: 30, color: Colors.redAccent),
            );
          },
        ),

        // Start / Stop button with dialog on stop
        ElevatedButton(
          onPressed: () async {
            if (!viewModel.on) {
              // Countdown
              viewModel.countdownController.add('3');
              await Future.delayed(Duration(seconds: 1));
              viewModel.countdownController.add('2');
              await Future.delayed(Duration(seconds: 1));
              viewModel.countdownController.add('1');
              await Future.delayed(Duration(seconds: 1));
              viewModel.countdownController.add('');

              // Start measurement
              Vibration.vibrate();
              viewModel.startStream();
            } else {
              // Stop measurement
              viewModel.stopStream();

              // Show popup with stats
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Štatistika z merania'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Počet súst: ${viewModel.getRepetitionCount()}'),
                        Text('Celkový čas merania: ${viewModel.getTotalMeasurementDuration()}'),
                        Text("Čas jedného sústa: ${viewModel.getAverageRepetitionDuration()}"),
                        Text('Počet nárazov: ${viewModel.getImpactCount()}'),
                        Text('Čas trasenia ruky: ${viewModel.getShakingDuration()}'),

                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Zavrieť'),
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: Text(viewModel.on ? 'Stop' : 'Štart'),
        ),
      ],
    );
  }
}