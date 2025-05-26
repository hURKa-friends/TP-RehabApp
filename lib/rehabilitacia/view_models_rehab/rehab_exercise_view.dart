import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rehab_app/view_models/gyro_viewmodel.dart';
import 'package:rehab_app/rehabilitacia/view_models_rehab/exercise_view_model.dart';
import 'package:rehab_app/views/exercise_feedback_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:rehab_app/util/sensor_chart_view.dart'; // Import grafu

class RehabExerciseView extends StatelessWidget {
  final String title;
  final String exerciseType;

  const RehabExerciseView({
    required this.title,
    required this.exerciseType,
    super.key,
  });

  Future<void> saveDataToCsv(List imuData, String fileName) async {
    final directory = await getExternalStorageDirectory(); // externý adresár
    final path = '${directory!.path}/$fileName.csv';

    List<List<dynamic>> csvData = [
      ["timestamp", "x", "y", "z"]
    ];

    csvData.addAll(imuData.map((e) => [
      e.timeStamp.toIso8601String(),
      e.x.toStringAsFixed(2),
      e.y.toStringAsFixed(2),
      e.z.toStringAsFixed(2),
    ]));

    final file = File(path);
    await file.writeAsString(const ListToCsvConverter().convert(csvData));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ExerciseViewModel>(
      create: (_) => ExerciseViewModel(
        exerciseType: exerciseType,
        gyroViewModel: Provider.of<GyroViewModel>(context, listen: false),
      ),
      child: Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Consumer<ExerciseViewModel>(
          builder: (context, model, _) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Záznam prebieha..."),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  model.evaluate();
                  await saveDataToCsv(
                    model.gyroViewModel.imuData,
                    "${exerciseType}_exercise_${DateTime.now().millisecondsSinceEpoch}",
                  );

                  // Otvorí graf, a po jeho zatvorení ide na spätnú väzbu
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SensorChartView(
                        data: model.gyroViewModel.imuData,
                        onClose: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ExerciseFeedbackView(
                                icon: Icons.feedback,
                                title: "Spätná väzba",
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
                child: const Text("Vyhodnoť, ulož a zobraz graf"),
              ),

              const SizedBox(height: 20),
              Text(model.result),
            ],
          ),
        ),
      ),
    );
  }
}
