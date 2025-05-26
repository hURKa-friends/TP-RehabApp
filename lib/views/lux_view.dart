import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:rehab_app/models/sensor_models.dart';
import 'package:rehab_app/view_models/lux_viewmodel.dart';

class LuxView extends StatelessWidget {
  // GUI widget tree
  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<LuxViewModel>();
    return Container(
      padding: EdgeInsets.only(bottom: 100),
      child: SfCartesianChart(
        key: ValueKey(viewModel.index),
        legend: Legend(isVisible: true),
        primaryXAxis: DateTimeAxis(
          minimum: viewModel.luxData.isNotEmpty
              ? viewModel.luxData.first.timeStamp
              : null,
          maximum: viewModel.luxData.isNotEmpty
              ? viewModel.luxData.last.timeStamp
              : null,
        ), // ✅ Ensures DateTime is handled correctly
        primaryYAxis: NumericAxis(
          title: AxisTitle(text: 'Luxmeter'),
          minimum: 0,
          interval: 10,
        ),
        series: <LineSeries<LuxSensorData, DateTime>>[
          LineSeries<LuxSensorData, DateTime>(
              name:
                  "Lux (${viewModel.luxData.isNotEmpty ? viewModel.luxData.last.lux.toStringAsFixed(2) : '0'})",
              dataSource: viewModel.luxData,
              xValueMapper: (LuxSensorData data, _) => data.timeStamp,
              yValueMapper: (LuxSensorData data, _) => data.lux,
              animationDuration: 0),
        ],
      )
    );
  }
}
