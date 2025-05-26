import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:rehab_app/models/sensor_models.dart';

Future<void> saveDataToCsv(List<ImuSensorData> data, String fileName) async {
  final directory = Platform.isAndroid
      ? await getExternalStorageDirectory()
      : await getApplicationDocumentsDirectory();

  final path = '${directory!.path}/$fileName.csv';

  final rows = <List<dynamic>>[
    ["timestamp", "x", "y", "z"]
  ];

  rows.addAll(data.map((e) => [
    e.timeStamp.toIso8601String(),
    e.x.toStringAsFixed(2),
    e.y.toStringAsFixed(2),
    e.z.toStringAsFixed(2)
  ]));

  final csvString = const ListToCsvConverter().convert(rows);
  final file = File(path);
  await file.writeAsString(csvString);
}
