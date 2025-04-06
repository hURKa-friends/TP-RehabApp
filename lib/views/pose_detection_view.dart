import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'package:rehab_app/view_models/pose_detection_view_model.dart';

class PoseDetectionView extends StatelessWidget {
  /// Default Constructor
  const PoseDetectionView({super.key});

  @override
  Widget build(BuildContext context) {
    var poseDetectionViewModel = context.watch<PoseDetectionViewModel>();

    if (!poseDetectionViewModel.cameraController.value.isInitialized) {
      return Center(child: CircularProgressIndicator()); // Show a loader
    }

    return Stack(
      children: [
        CameraPreview(poseDetectionViewModel.cameraController),

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
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8), // Space between text widgets
                Text(
                  'Shoulder Angle: ${poseDetectionViewModel.currentAngleShoulder}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
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