import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/FMS_phone_pickup_viewmodel.dart';


class MotionDetectionPage extends StatelessWidget {
  const MotionDetectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MotionDetectionViewModel(),
      child: Consumer<MotionDetectionViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(title: const Text("Motion + Gesture Detection")),
            body: Column(
              children: [
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: viewModel.sensorsRunning
                        ? viewModel.stopSensors
                        : viewModel.startSensors,
                    child: Text(viewModel.sensorsRunning ? "Stop Sensors" : "Start Sensors"),
                  ),
                ),
                const SizedBox(height: 16),
                _buildSensorDisplay(viewModel),
                const Divider(),
                Expanded(
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      viewModel.addTouchPoint(details.localPosition);
                    },
                    onPanEnd: (_) {
                      viewModel.clearTouchPoints();
                    },
                    child: Container(
                      color: Colors.grey[200],
                      child: CustomPaint(
                        painter: TouchPainter(viewModel.touchPoints),
                        child: const Center(child: Text("Touch and move your finger")),
                      ),
                    ),
                  ),
                ),
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
