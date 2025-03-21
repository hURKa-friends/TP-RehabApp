import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:rehab_app/view_models/mag_viewmodel.dart';
import 'package:rehab_app/services/models/sensor_models.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MagView extends StatefulWidget {
  const MagView({super.key});

  @override
  _MagViewState createState() => _MagViewState();
}

class _MagViewState extends State<MagView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // GUI widget tree
  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<MagViewModel>();
    return Container(
        padding: EdgeInsets.only(bottom: 100),
        child: SfCartesianChart(
          key: ValueKey(viewModel.index),
          legend: Legend(isVisible: true),
          primaryXAxis: DateTimeAxis(
            minimum: viewModel.imuData.isNotEmpty
                ? viewModel.imuData.first.timeStamp
                : null,
            maximum: viewModel.imuData.isNotEmpty
                ? viewModel.imuData.last.timeStamp
                : null,
          ), // ✅ Ensures DateTime is handled correctly
          primaryYAxis: NumericAxis(
            title: AxisTitle(text: 'Magnetometer'),
            minimum: -20,
            maximum: 20,
            interval: 1,
          ),
          series: <LineSeries<ImuSensorData, DateTime>>[
            LineSeries<ImuSensorData, DateTime>(
                name:
                    "X-Axis (${viewModel.imuData.isNotEmpty ? viewModel.imuData.last.x.toStringAsFixed(2) : '0'})",
                dataSource: viewModel.imuData,
                xValueMapper: (ImuSensorData data, _) => data.timeStamp,
                yValueMapper: (ImuSensorData data, _) => data.x,
                animationDuration: 0),
            LineSeries<ImuSensorData, DateTime>(
                name:
                    "Y-Axis (${viewModel.imuData.isNotEmpty ? viewModel.imuData.last.y.toStringAsFixed(2) : '0'})",
                dataSource: viewModel.imuData,
                xValueMapper: (ImuSensorData data, _) => data.timeStamp,
                yValueMapper: (ImuSensorData data, _) => data.y,
                animationDuration: 0),
            LineSeries<ImuSensorData, DateTime>(
                name:
                    "Z-Axis (${viewModel.imuData.isNotEmpty ? viewModel.imuData.last.z.toStringAsFixed(2) : '0'})",
                dataSource: viewModel.imuData,
                xValueMapper: (ImuSensorData data, _) => data.timeStamp,
                yValueMapper: (ImuSensorData data, _) => data.z,
                animationDuration: 0),
          ],
        ));
  }
}
