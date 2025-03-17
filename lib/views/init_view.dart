import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rehab_app/view_models/init_view_model.dart';
import 'package:rehab_app/services/models/init_models.dart';

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
                  _buildSensorInfo("Accelerometer", viewModel.accelerometer),
                  _buildSensorInfo("Gyroscope", viewModel.gyroscope),
                  _buildSensorInfo("Magnetometer", viewModel.magnetometer),
                  _buildSensorInfo("Light Sensor", viewModel.lightSensor),
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
}
