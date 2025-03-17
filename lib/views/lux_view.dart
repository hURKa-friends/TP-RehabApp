import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rehab_app/view_models/lux_viewmodel.dart';
import 'package:rehab_app/services/sensor_models.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LuxView extends StatefulWidget {
  const LuxView({super.key});

  @override
  _LuxViewState createState() => _LuxViewState();
}

class _LuxViewState extends State<LuxView> {
  // GUI Fields & Parameters
  late LuxViewModel _viewModel;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _viewModel = LuxViewModel();
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
            minimum: _viewModel.luxData.isNotEmpty
                ? _viewModel.luxData.first.timeStamp
                : null,
            maximum: _viewModel.luxData.isNotEmpty
                ? _viewModel.luxData.last.timeStamp
                : null,
          ), // ✅ Ensures DateTime is handled correctly
          primaryYAxis: NumericAxis(
            title: AxisTitle(text: 'Luxmeter'),
            minimum: -20,
            maximum: 40000,
            interval: 1,
          ),
          series: <LineSeries<LuxSensorData, DateTime>>[
            LineSeries<LuxSensorData, DateTime>(
                name:
                    "Lux (${_viewModel.luxData.isNotEmpty ? _viewModel.luxData.last.lux.toStringAsFixed(2) : '0'})",
                dataSource: _viewModel.luxData,
                xValueMapper: (LuxSensorData data, _) => data.timeStamp,
                yValueMapper: (LuxSensorData data, _) => data.lux,
                animationDuration: 0),
          ],
        ));
  }
}
