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
        child: Column(
          children: [
            Expanded(
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
                    child: Image.asset("assets/arm_rehab/images/flex.webp"),
                  ),
                  space(15),
                  Text(
                    "Angle graph",
                    textAlign: TextAlign.center,
                    style: buttonTextStyle(),
                  ),
                  SfCartesianChart(
                    key: ValueKey(0),
                    legend: Legend(isVisible: true),
                    primaryXAxis: DateTimeAxis(
                      minimum: Angles.angles.isNotEmpty
                          ? Angles.angles.first.timestamp
                          : null,
                      maximum: Angles.angles.isNotEmpty
                          ? Angles.angles.last.timestamp
                          : null,
                    ), // ✅ Ensures DateTime is handled correctly
                    primaryYAxis: NumericAxis(
                      title: AxisTitle(text: 'Accelerometer'),
                      minimum: exerciseSummaryViewModel.getMin(Angles.angles, ArmImuData.userAcclData, 1),
                      maximum: exerciseSummaryViewModel.getMax(Angles.angles, ArmImuData.userAcclData, 1),
                      interval: 1,
                    ),
                    series: <LineSeries<AngleGraph, DateTime>>[
                      LineSeries<AngleGraph, DateTime>(
                          name:
                          "X-Axis (${Angles.angles.isNotEmpty ? Angles.angles.last.angleX.toStringAsFixed(2) : '0'})",
                          dataSource: Angles.angles,
                          xValueMapper: (AngleGraph data, _) => data.timestamp,//(double data, _) => data.timeStamp,
                          yValueMapper: (AngleGraph data, _) => data.angleX,//(double data, _) => data.x,
                          animationDuration: 0),
                      LineSeries<AngleGraph, DateTime>(
                          name:
                          "Y-Axis (${Angles.angles.isNotEmpty ? Angles.angles.last.angleY.toStringAsFixed(2) : '0'})",
                          dataSource: Angles.angles,
                          xValueMapper: (AngleGraph data, _) => data.timestamp,
                          yValueMapper: (AngleGraph data, _) => data.angleY,
                          animationDuration: 0),
                      LineSeries<AngleGraph, DateTime>(
                          name:
                          "Z-Axis (${Angles.angles.isNotEmpty ? Angles.angles.last.angleZ.toStringAsFixed(2) : '0'})",
                          dataSource: Angles.angles,
                          xValueMapper: (AngleGraph data, _) => data.timestamp,
                          yValueMapper: (AngleGraph data, _) => data.angleZ,
                          animationDuration: 0),
                    ],
                  ),
                  space(10),
                  Text(
                    "Accelerometer graph",
                    textAlign: TextAlign.center,
                    style: buttonTextStyle(),
                  ),
                  SfCartesianChart(
                    key: ValueKey(1),
                    legend: Legend(isVisible: true),
                    primaryXAxis: DateTimeAxis(
                      minimum: ArmImuData.userAcclData.isNotEmpty
                          ? ArmImuData.userAcclData.first.timeStamp
                          : null,
                      maximum: ArmImuData.userAcclData.isNotEmpty
                          ? ArmImuData.userAcclData.last.timeStamp
                          : null,
                    ), // ✅ Ensures DateTime is handled correctly
                    primaryYAxis: NumericAxis(
                      title: AxisTitle(text: 'Accelerometer'),
                      minimum: exerciseSummaryViewModel.getMin(Angles.angles, ArmImuData.userAcclData, 2),
                      maximum: exerciseSummaryViewModel.getMax(Angles.angles, ArmImuData.userAcclData, 2),
                      interval: 1,
                    ),
                    series: <LineSeries<ImuSensorData, DateTime>>[
                      LineSeries<ImuSensorData, DateTime>(
                          name:
                          "X-Axis (${ArmImuData.userAcclData.isNotEmpty ? ArmImuData.userAcclData.last.x.toStringAsFixed(2) : '0'})",
                          dataSource: ArmImuData.userAcclData,
                          xValueMapper: (ImuSensorData data, _) => data.timeStamp,
                          yValueMapper: (ImuSensorData data, _) => data.x,
                          animationDuration: 0),
                      LineSeries<ImuSensorData, DateTime>(
                          name:
                          "Y-Axis (${ArmImuData.userAcclData.isNotEmpty ? ArmImuData.userAcclData.last.y.toStringAsFixed(2) : '0'})",
                          dataSource: ArmImuData.userAcclData,
                          xValueMapper: (ImuSensorData data, _) => data.timeStamp,
                          yValueMapper: (ImuSensorData data, _) => data.y,
                          animationDuration: 0),
                      LineSeries<ImuSensorData, DateTime>(
                          name:
                          "Z-Axis (${ArmImuData.userAcclData.isNotEmpty ? ArmImuData.userAcclData.last.z.toStringAsFixed(2) : '0'})",
                          dataSource: ArmImuData.userAcclData,
                          xValueMapper: (ImuSensorData data, _) => data.timeStamp,
                          yValueMapper: (ImuSensorData data, _) => data.z,
                          animationDuration: 0),
                    ],
                  ),
                  space(10),
                  Text(
                    "Gyroscope graph",
                    textAlign: TextAlign.center,
                    style: buttonTextStyle(),
                  ),
                  SfCartesianChart(
                    key: ValueKey(2),
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
                      minimum: exerciseSummaryViewModel.getMin(Angles.angles, ArmImuData.gyroData, 2),
                      maximum: exerciseSummaryViewModel.getMax(Angles.angles, ArmImuData.gyroData, 2),
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
                  space(15),
                  Text(
                    "DAV (Difference Acceleration Vector): ${exerciseSummaryViewModel.calculateDAV(ArmImuData.userAcclData).toStringAsFixed(4)}",
                    textAlign: TextAlign.center,
                    style: buttonTextStyle(),
                  ),
                  space(15),
                  Text(
                    "LDLJ (Log Dimensionless Jerk): ${exerciseSummaryViewModel.calculateLDLJ(ArmImuData.acclData).toStringAsFixed(4)}",
                    textAlign: TextAlign.center,
                    style: buttonTextStyle(),
                  ),
                  space(15),
                  Text(
                    "MI (Movement Intensity): ${exerciseSummaryViewModel.calculateMI(ArmImuData.acclData).toStringAsFixed(4)}",
                    textAlign: TextAlign.center,
                    style: buttonTextStyle(),
                  ),
                  space(80),
                ],
              ),
            ),
          ],
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
