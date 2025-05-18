import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rehab_app/arm_rehab/models/arm_model.dart';
import 'package:rehab_app/services/page_management/models/stateless_page_model.dart';

import 'package:rehab_app/arm_rehab/view_models/exercise_summary_view_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../models/sensor_models.dart';
import '../../services/page_management/view_models/page_navigator_view_model.dart';
import '../../views/menu_view.dart';

class ExerciseSummaryView extends StatelessPage {
  const ExerciseSummaryView({
    super.key,
    required super.icon,
    required super.title,
    super.subPages, // Optional
    super.tutorialSteps // Optional
  });

  @override
  void initPage(BuildContext context) {
    // Here you can call page initialization code or reference ViewModel initialization like this:
    var exerciseSummaryViewModel = Provider.of<ExerciseSummaryViewModel>(context, listen: false); /// IMPORTANT listen must be false
    exerciseSummaryViewModel.onInit();
  }

  @override
  void closePage(BuildContext context) {
    // Here you can call page closing code or reference ViewModel disposal like this:
    var exerciseSummaryViewModel = Provider.of<ExerciseSummaryViewModel>(context, listen: false); /// IMPORTANT listen must be false
    exerciseSummaryViewModel.onClose();
  }

  @override
  Widget buildPage(BuildContext context) {
    var exerciseSummaryViewModel = context.watch<ExerciseSummaryViewModel>();

    return Scaffold(
      body: Center(
        child: Expanded(
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: AlwaysScrollableScrollPhysics(),
            children: <Widget>[
              Text(
                "Exercise finished!",
                textAlign: TextAlign.center,
                style: headerStyle(),
              ),
              SizedBox(
                width: exerciseSummaryViewModel.imageSize,
                height: exerciseSummaryViewModel.imageSize,
                child: Image.asset("assets/images/flex.webp"),
              ),
              Text("Accelerometer graph"),
              SfCartesianChart(
                key: ValueKey(0),
                legend: Legend(isVisible: true),
                primaryXAxis: DateTimeAxis(
                  minimum: ArmImuData.acclData.isNotEmpty
                      ? ArmImuData.acclData.first.timeStamp
                      : null,
                  maximum: ArmImuData.acclData.isNotEmpty
                      ? ArmImuData.acclData.last.timeStamp
                      : null,
                ), // ✅ Ensures DateTime is handled correctly
                primaryYAxis: NumericAxis(
                  title: AxisTitle(text: 'Accelerometer'),
                  minimum: -20,
                  maximum: 20,
                  interval: 1,
                ),
                series: <LineSeries<ImuSensorData, DateTime>>[
                  LineSeries<ImuSensorData, DateTime>(
                      name:
                      "X-Axis (${ArmImuData.acclData.isNotEmpty ? ArmImuData.acclData.last.x.toStringAsFixed(2) : '0'})",
                      dataSource: ArmImuData.acclData,
                      xValueMapper: (ImuSensorData data, _) => data.timeStamp,
                      yValueMapper: (ImuSensorData data, _) => data.x,
                      animationDuration: 0),
                  LineSeries<ImuSensorData, DateTime>(
                      name:
                      "Y-Axis (${ArmImuData.acclData.isNotEmpty ? ArmImuData.acclData.last.y.toStringAsFixed(2) : '0'})",
                      dataSource: ArmImuData.acclData,
                      xValueMapper: (ImuSensorData data, _) => data.timeStamp,
                      yValueMapper: (ImuSensorData data, _) => data.y,
                      animationDuration: 0),
                  LineSeries<ImuSensorData, DateTime>(
                      name:
                      "Z-Axis (${ArmImuData.acclData.isNotEmpty ? ArmImuData.acclData.last.z.toStringAsFixed(2) : '0'})",
                      dataSource: ArmImuData.acclData,
                      xValueMapper: (ImuSensorData data, _) => data.timeStamp,
                      yValueMapper: (ImuSensorData data, _) => data.z,
                      animationDuration: 0),
                ],
              ),
              Text("Gyroscope graph"),
              SfCartesianChart(
                key: ValueKey(1),
                legend: Legend(isVisible: true),
                primaryXAxis: DateTimeAxis(
                  minimum: ArmImuData.gyroData.isNotEmpty
                      ? ArmImuData.gyroData.first.timeStamp
                      : null,
                  maximum: ArmImuData.gyroData.isNotEmpty
                      ? ArmImuData.gyroData.last.timeStamp
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
                      "X-Axis (${ArmImuData.gyroData.isNotEmpty ? ArmImuData.gyroData.last.x.toStringAsFixed(2) : '0'})",
                      dataSource: ArmImuData.gyroData,
                      xValueMapper: (ImuSensorData data, _) => data.timeStamp,
                      yValueMapper: (ImuSensorData data, _) => data.x,
                      animationDuration: 0),
                  LineSeries<ImuSensorData, DateTime>(
                      name:
                      "Y-Axis (${ArmImuData.gyroData.isNotEmpty ? ArmImuData.gyroData.last.y.toStringAsFixed(2) : '0'})",
                      dataSource: ArmImuData.gyroData,
                      xValueMapper: (ImuSensorData data, _) => data.timeStamp,
                      yValueMapper: (ImuSensorData data, _) => data.y,
                      animationDuration: 0),
                  LineSeries<ImuSensorData, DateTime>(
                      name:
                      "Z-Axis (${ArmImuData.gyroData.isNotEmpty ? ArmImuData.gyroData.last.z.toStringAsFixed(2) : '0'})",
                      dataSource: ArmImuData.gyroData,
                      xValueMapper: (ImuSensorData data, _) => data.timeStamp,
                      yValueMapper: (ImuSensorData data, _) => data.z,
                      animationDuration: 0),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightGreen,
        onPressed: () {
          var navigatorViewModel = Provider.of<PageNavigatorViewModel>(context, listen: false);
          navigatorViewModel.backToRoot(context);
        },

        child: Icon(Icons.exit_to_app),
      ),
    );
  }
}
