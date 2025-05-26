import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:rehab_app/models/sensor_models.dart';

class SensorChartView extends StatelessWidget {
  final List<ImuSensorData> data;
  final VoidCallback? onClose; // 👈 sem pridaj tento parameter

  const SensorChartView({
    super.key,
    required this.data,
    this.onClose, // 👈 a tu nezabudni doplniť
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Priebeh pohybu")),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SfCartesianChart(
                title: ChartTitle(text: 'Zložka akcelerácie (Z)'),
                primaryXAxis: NumericAxis(title: AxisTitle(text: 'Vzorka')),
                primaryYAxis: NumericAxis(title: AxisTitle(text: 'Z [m/s²]')),
                series: <LineSeries<ImuSensorData, int>>[
                  LineSeries<ImuSensorData, int>(
                    dataSource: data,
                    xValueMapper: (ImuSensorData imu, int index) => index,
                    yValueMapper: (ImuSensorData imu, _) => imu.z,
                    name: 'Z',
                    markerSettings: const MarkerSettings(isVisible: false),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                if (onClose != null) {
                  onClose!(); // 👈 zavolá spätnú väzbu po zatvorení grafu
                }
              },
              child: const Text("Zatvoriť graf"),
            ),
          ),
        ],
      ),
    );
  }
}
