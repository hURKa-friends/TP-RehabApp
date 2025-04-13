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
            appBar: AppBar(title: const Text("Phone Pickup Exercise")),
            body: Column(
              children: [
                if (viewModel.countdownActive)
                  Center(
                    child: Text(
                      "Starting in ${viewModel.countdown}...",
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
                          viewModel.sensorsRunning ? "Stop Sensors" : "Start Sensors"),
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
                        viewModel.analyzeData();
                        viewModel.stopSensors();
                      },
                      child: Container(
                        color: Colors.grey[200],
                        child: CustomPaint(
                          painter: TouchPainter(viewModel.touchPoints),
                          child: const Center(
                              child: Text("Perform the phone pickup exercise")),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: viewModel.resetTry,
                    child: const Text("Reset Try"),
                  ),
                  if (viewModel.isAnalyzing)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          "Analyzing and logging data...",
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