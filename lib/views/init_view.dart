import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rehab_app/view_models/init_view_model.dart';
import 'package:rehab_app/services/models/init_models.dart';
import 'package:camera/camera.dart';

class InitView extends StatelessWidget {
  const InitView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InitViewModel(),
      child: Consumer<InitViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(title: Text("Sensor Status")),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // _buildSensorInfo("Accelerometer", viewModel.accelerometer),
                  // _buildSensorInfo("Gyroscope", viewModel.gyroscope),
                  // _buildSensorInfo("Magnetometer", viewModel.magnetometer),
                  // _buildSensorInfo("Light Sensor", viewModel.lightSensor),
                  // SizedBox(height: 16), // Add spacing
                  _buildMultiTouchInfo(viewModel.isMultiTouchSupported),
                  SizedBox(height: 16), // Add spacing for Camera info
                  _buildCameraInfo(viewModel),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSensorInfo(String title, SensorInfo? sensor) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: sensor != null
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Availability: ${sensor.availability}"),
            Text("Sampling Rate: ${sensor.samplingRate?.toStringAsFixed(2) ?? 'N/A'} Hz"),
            Text("Resolution: ${sensor.resolution?.toStringAsFixed(2) ?? 'N/A'}"),
          ],
        )
            : Text("Data not available"),
      ),
    );
  }
  Widget _buildMultiTouchInfo(bool? isMultiTouchSupported) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text("Multi-Touch Support", style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(isMultiTouchSupported == null
            ? "Checking..."
            : (isMultiTouchSupported ? "Supported ✅" : "Not Supported ❌")),
      ),
    );
  }

  Widget _buildCameraInfo(InitViewModel viewModel) {
    // Find the front camera in the map
    CameraDescription? frontCamera = viewModel.camDetails?.keys.firstWhere(
            (camera) => camera?.lensDirection == CameraLensDirection.front,
        orElse: () => null
    );

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text("Front Camera", style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: frontCamera == null
            ? Text("No front camera available")
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(viewModel.camDetails?[frontCamera] == true
                ? "Camera Permission Granted ✅"
                : "Camera Permission Denied ❌"),
            Text("Front Camera Available ✅"),
          ],
        ),
      ),
    );
  }
}
