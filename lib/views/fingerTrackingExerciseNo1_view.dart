import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class FingerTrackingExerciseNo1View extends StatefulWidget {
  const FingerTrackingExerciseNo1View({super.key});

  @override
  State<FingerTrackingExerciseNo1View> createState() => _FingerTrackingExerciseNo1ViewState();
}

class _FingerTrackingExerciseNo1ViewState extends State<FingerTrackingExerciseNo1View> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Finger Tracking Exercise No 1',
            ),
            ElevatedButton(
              onPressed: () {
                // Add your button action here
              },
              child: const Text('Start Exercise'),
            ),
          ],
        ),
      ),
    );
  }
}
