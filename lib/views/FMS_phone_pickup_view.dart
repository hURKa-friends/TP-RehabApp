import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/FMS_phone_pickup_viewmodel.dart';
import 'package:rehab_app/services/page_management/models/stateful_page_model.dart';

class MotionDetectionView extends StatefulPage {
  const MotionDetectionView({
    super.key,
    required super.icon,
    required super.title,
    super.tutorialSteps,
  });

  @override
  void initPage(BuildContext context) {}

  @override
  void closePage(BuildContext context) {}

  @override
  MotionDetectionViewState createState() => MotionDetectionViewState();
}

class MotionDetectionViewState extends StatefulPageState {
  @override
  Widget buildPage(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MotionDetectionViewModel(),
      child: Consumer<MotionDetectionViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(title: const Text("Cvičenie uchopovaním mobilu")),
            body: Column(
              children: [
                if (viewModel.countdownActive)
                  Center(
                    child: Text(
                      "Štart za ${viewModel.countdown}...",
                      style: const TextStyle(fontSize: 24),
                    ),
                  )
                else ...[
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: viewModel.sensorsRunning
                          ? viewModel.stopSensors
                          : viewModel.startSensors,
                      child: Text(
                          viewModel.sensorsRunning ? "Zastaviť sensory" : "Zapnúť senzory"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Zvoľte ruku'),
                      value: viewModel.selectedHand,
                      onChanged: (value) {
                        if (value != null) viewModel.setSelectedHand(value);
                      },
                      items: ['Lava', 'Prava']
                          .map((hand) => DropdownMenuItem(value: hand, child: Text(hand)))
                          .toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Zvoľte prsty'),
                      value: viewModel.selectedFingerOption,
                      onChanged: (value) {
                        if (value != null) viewModel.setSelectedFingerOption(value);
                      },
                      items: [
                        'Palec a Ukazovak',
                        'Palec a Prostredik',
                        'Palec a Prstennik',
                        'Palec a malicek'
                      ]
                          .map((fingers) => DropdownMenuItem(value: fingers, child: Text(fingers)))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSensorDisplay(viewModel),
                  const Divider(),
                  Expanded(
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        viewModel.sensorsRunning
                            ? viewModel.addTouchPoint(details.localPosition)
                            : null;
                      },
                      onPanEnd: (_) {
                        viewModel.stopSensors();
                      },
                      child: Container(
                        color: Colors.grey[200],
                        child: CustomPaint(
                          painter: TouchPainter(viewModel.touchPoints),
                          child: const Center(
                              child: Text("Vykonajte úchyt a presun zariadenia")),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: viewModel.resetTry,
                    child: const Text("Reset"),
                  ),
                  if (viewModel.isAnalyzing)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          "Analyzovanie and logovanie dát...",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSensorDisplay(MotionDetectionViewModel viewModel) {
    return Column(
      children: [
        const Text("Accelerometer", style: TextStyle(fontWeight: FontWeight.bold)),
        Text("X: ${viewModel.acclData.x.toStringAsFixed(2)}"),
        Text("Y: ${viewModel.acclData.y.toStringAsFixed(2)}"),
        Text("Z: ${viewModel.acclData.z.toStringAsFixed(2)}"),
        const SizedBox(height: 8),
        const Text("Gyroscope", style: TextStyle(fontWeight: FontWeight.bold)),
        Text("X: ${viewModel.gyroData.x.toStringAsFixed(2)}"),
        Text("Y: ${viewModel.gyroData.y.toStringAsFixed(2)}"),
        Text("Z: ${viewModel.gyroData.z.toStringAsFixed(2)}"),
      ],
    );
  }
}

class TouchPainter extends CustomPainter {
  final List<Offset> points;
  TouchPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueAccent
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    for (var point in points) {
      canvas.drawCircle(point, 6.0, paint);
    }
  }

  @override
  bool shouldRepaint(TouchPainter oldDelegate) => true;
}