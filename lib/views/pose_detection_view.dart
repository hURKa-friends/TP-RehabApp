import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:provider/provider.dart';
import 'package:rehab_app/view_models/pose_detection_view_model.dart';

class PoseDetectionView extends StatelessWidget {
  /// Default Constructor
  const PoseDetectionView({super.key});

  @override
  Widget build(BuildContext context) {
    var poseDetectionViewModel = context.watch<PoseDetectionViewModel>();
    if (!poseDetectionViewModel.cameraController.value.isInitialized) {
      return Container(); ///returns empty container
    }
    return CameraPreview(poseDetectionViewModel.cameraController);
  }
}