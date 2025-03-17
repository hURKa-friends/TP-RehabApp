import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rehab_app/view_models/gyro_viewmodel.dart';
import 'package:rehab_app/services/sensor_models.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GyroView extends StatefulWidget {
  const GyroView({super.key});

  @override
  _GyroViewState createState() => _GyroViewState();
}

class _GyroViewState extends State<GyroView> {
  // GUI Fields & Parameters
  late GyroViewModel _viewModel;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _viewModel = GyroViewModel();
    _timer = Timer.periodic(const Duration(milliseconds: 50), updateUI);
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel timer to prevent memory leaks
    super.dispose();
  }

  void updateUI(Timer timer) {
    setState(() {});
  }

  // GUI widget tree
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(bottom: 100),
        child: SfCartesianChart(
          key: ValueKey(_viewModel.index),
          legend: Legend(isVisible: true),
          primaryXAxis: DateTimeAxis(
            minimum: _viewModel.imuData.isNotEmpty
                ? _viewModel.imuData.first.timeStamp
                : null,
            maximum: _viewModel.imuData.isNotEmpty
                ? _viewModel.imuData.last.timeStamp
                : null,
          ), // ✅ Ensures DateTime is handled correctly
          primaryYAxis: NumericAxis(
            title: AxisTitle(text: 'Gyroscope'),
            minimum: -20,
            maximum: 20,
            interval: 1,
          ),
          series: <LineSeries<ImuSensorData, DateTime>>[
            LineSeries<ImuSensorData, DateTime>(
                name:
                    "X-Axis (${_viewModel.imuData.isNotEmpty ? _viewModel.imuData.last.x.toStringAsFixed(2) : '0'})",
                dataSource: _viewModel.imuData,
                xValueMapper: (ImuSensorData data, _) => data.timeStamp,
                yValueMapper: (ImuSensorData data, _) => data.x,
                animationDuration: 0),
            LineSeries<ImuSensorData, DateTime>(
                name:
                    "Y-Axis (${_viewModel.imuData.isNotEmpty ? _viewModel.imuData.last.y.toStringAsFixed(2) : '0'})",
                dataSource: _viewModel.imuData,
                xValueMapper: (ImuSensorData data, _) => data.timeStamp,
                yValueMapper: (ImuSensorData data, _) => data.y,
                animationDuration: 0),
            LineSeries<ImuSensorData, DateTime>(
                name:
                    "Z-Axis (${_viewModel.imuData.isNotEmpty ? _viewModel.imuData.last.z.toStringAsFixed(2) : '0'})",
                dataSource: _viewModel.imuData,
                xValueMapper: (ImuSensorData data, _) => data.timeStamp,
                yValueMapper: (ImuSensorData data, _) => data.z,
                animationDuration: 0),
          ],
        ));
  }
}
