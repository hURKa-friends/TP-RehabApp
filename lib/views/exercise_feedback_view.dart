import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rehab_app/services/internal/logger_service_internal.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:rehab_app/services/page_management/models/stateful_page_model.dart';

import '../services/external/logger_service.dart';
import '../services/page_management/view_models/page_navigator_view_model.dart';

late String? UOID;

class ExerciseFeedbackView extends StatefulPage {
  ExerciseFeedbackView({
    super.key,
    required super.icon,
    required super.title,
    super.tutorialSteps,
  });

  //...
  Future<void> onInit() async {
    UOID = await LoggerService().openCsvLogChannel(
        access: ChannelAccess.protected,
        fileName: 'fooFile',
        headerData: 'HeaderData1, HeaderData2, HeaderData3');
  }


  @override
  void initPage(BuildContext context) async {
    // Ak potrebuješ niečo pripraviť, sem to daj
    await onInit();
  }

  @override
  void closePage(BuildContext context) {
    // Cleanup ak treba
  }

  @override
  ExerciseFeedbackViewState createState() => ExerciseFeedbackViewState();
}

class ExerciseFeedbackViewState extends StatefulPageState<ExerciseFeedbackView> {
  bool repeatExercise = false;
  double difficulty = 3.0;
  final TextEditingController noteController = TextEditingController();


  @override
  Widget buildPage(BuildContext context) {
    var navigatorViewModel = context.watch<PageNavigatorViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: Icon(widget.icon),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("How hard was the exercise?"),
            Slider(
              value: difficulty,
              min: 1,
              max: 5,
              divisions: 4,
              label: "$difficulty",
              onChanged: (value) => setState(() => difficulty = value),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(
                labelText: "Your note",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Do you want to repeat it?"),
                Switch(
                  value: repeatExercise,
                  onChanged: (v) => setState(() => repeatExercise = v),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                final feedback = {
                  'timestamp': DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
                  'difficulty': difficulty.toStringAsFixed(1),
                  'note': noteController.text.trim(),
                  'repeat': repeatExercise ? 'yes' : 'no',
                };

                if (!kIsWeb) {
                    String line = "${feedback['timestamp']},${feedback['difficulty']},\"${feedback['note']}\",${feedback['repeat']}\n";
                    LoggerService().log(channel: LogChannel.csv, ownerId: UOID!, data: line);
                    LoggerService().closeLogChannelSafely(ownerId: UOID!, channel: LogChannel.csv);
                }

                navigatorViewModel.backToRoot(context);
              },
              child: Row(
                children: [
                  const Icon(Icons.check),
                  const Text("Send and return"),
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}
