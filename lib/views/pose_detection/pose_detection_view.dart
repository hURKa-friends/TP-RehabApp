import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'package:rehab_app/models/pose_detection/pose_detection_model.dart';

import 'package:rehab_app/view_models/pose_detection/pose_detection_view_model.dart';

import 'package:rehab_app/services/page_management/models/stateful_page_model.dart';

class PoseDetectionView extends StatefulPage {
  final ExerciseType exerciseType;

  const PoseDetectionView({
    super.key,
    required super.icon,
    required super.title,
    required this.exerciseType,
    super.tutorialSteps
  });

  @override
  void initPage(BuildContext context) {
    var poseDetectionViewModel = Provider.of<PoseDetectionViewModel>(context, listen: false);
    poseDetectionViewModel.setExercise(exerciseType);
    // poseDetectionViewModel.onInit();
  }

  @override
  void closePage(BuildContext context) {
    // var poseDetectionViewModel = Provider.of<PoseDetectionViewModel>(context, listen: false);
    // poseDetectionViewModel.onClose();
  }

  @override
  PoseDetectionViewState createState() => PoseDetectionViewState();
}

class PoseDetectionViewState extends StatefulPageState {
  PoseDetectionViewModel? _poseDetectionViewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _poseDetectionViewModel ??= Provider.of<PoseDetectionViewModel>(context);
  }

  @override
  void dispose() {
    _poseDetectionViewModel?.dispose();
    super.dispose();
  }

  @override
  Widget buildPage(BuildContext context) {
    var poseDetectionViewModel = context.watch<PoseDetectionViewModel>();
    return Stack(
      children: [
        if (poseDetectionViewModel.cameraController.value.isInitialized)
          CameraPreview(poseDetectionViewModel.cameraController)
        else
          const Center(child: CircularProgressIndicator()),

        if (poseDetectionViewModel.customPaint != null)
          Positioned.fill(child: poseDetectionViewModel.customPaint!),

        Positioned(
          top: 16,
          left: 16,
          right: 16, // ADD THIS to give width constraints
          child: Container(
            padding: const EdgeInsets.all(8),
            color: Colors.black54,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
              children: [
                Text(
                  'Reps: ${poseDetectionViewModel.repetitions}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8), // Space between text widgets
                Text(
                  'Shoulder Angle: ${poseDetectionViewModel.currentAngleShoulder}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8), // Space between text widgets
                Text(
                  'OOL: ${poseDetectionViewModel.outOfLimits}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}