import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'package:numberpicker/numberpicker.dart';

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

  Widget _buildArmSelectionUI(BuildContext context, PoseDetectionViewModel viewModel) {
    final ThemeData theme = Theme.of(context); // Get the current theme

    // Define text styles based on the theme for consistency
    final TextStyle headlineStyle = theme.textTheme.headlineSmall ?? TextStyle(fontSize: 20, color: theme.colorScheme.onBackground);
    final TextStyle bodyTextStyle = theme.textTheme.bodyLarge ?? TextStyle(fontSize: 18, color: theme.colorScheme.onBackground);
    final TextStyle buttonTextStyle = theme.textTheme.labelLarge ?? TextStyle(fontSize: 18, color: theme.colorScheme.onPrimary);
    final TextStyle pickerSelectedTextStyle = TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: theme.colorScheme.primary);
    final TextStyle pickerTextStyle = TextStyle(fontSize: 18, color: theme.colorScheme.onSurface.withOpacity(0.7)); // Slightly muted for non-selected

    return Scaffold(
      // AppBar uses theme colors by default, but you can customize if needed
      appBar: AppBar(
        title: Text('Configure Exercise:', style: TextStyle(color: theme.colorScheme.onPrimary)), // Assuming AppBar background is primary
        backgroundColor: theme.colorScheme.primary,
        iconTheme: IconThemeData(color: theme.colorScheme.onPrimary), // For back button, etc.
        automaticallyImplyLeading: false,
      ),
      backgroundColor: theme.colorScheme.background, // Page background
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Which arm will you be exercising?',
                style: headlineStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      viewModel.selectArm(ArmSelection.left);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: viewModel.selectedArm == ArmSelection.left
                          ? theme.colorScheme.primary // Selected button color
                          : theme.colorScheme.surfaceVariant, // Unselected button color
                      foregroundColor: viewModel.selectedArm == ArmSelection.left
                          ? theme.colorScheme.onPrimary // Text color for selected
                          : theme.colorScheme.onSurfaceVariant, // Text color for unselected
                    ),
                    child: Text('Left Arm', style: buttonTextStyle.copyWith(
                      color: viewModel.selectedArm == ArmSelection.left
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurfaceVariant,
                    )),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      viewModel.selectArm(ArmSelection.right);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: viewModel.selectedArm == ArmSelection.right
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surfaceVariant,
                      foregroundColor: viewModel.selectedArm == ArmSelection.right
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                    child: Text('Right Arm', style: buttonTextStyle.copyWith(
                      color: viewModel.selectedArm == ArmSelection.right
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurfaceVariant,
                    )),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Text(
                'Select number of repetitions (1-20):',
                style: headlineStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              if (viewModel.isArmSelected)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface, // Background for the picker area
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: theme.colorScheme.outline.withOpacity(0.5)),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.shadow.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: NumberPicker(
                    minValue: 1,
                    maxValue: 20,
                    value: viewModel.targetRepetitions,
                    onChanged: (value) {
                      viewModel.setTargetRepetitions(value);
                    },
                    axis: Axis.horizontal,
                    itemHeight: 50,
                    itemWidth: 60,
                    textStyle: pickerTextStyle,
                    selectedTextStyle: pickerSelectedTextStyle,
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 60.0),
                  child: Text(
                    "Please select an arm first.",
                    style: bodyTextStyle.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                  ),
                ),
              if (!viewModel.isArmSelected)
                const SizedBox(height: 50 + 16),

              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: viewModel.isArmSelected && viewModel.targetRepetitions >= 1 && viewModel.targetRepetitions <= 20
                    ? () {
                  viewModel.initializeCameraAndDetection();
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text('Start Exercise', style: buttonTextStyle.copyWith(color: theme.colorScheme.onPrimary)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCameraPreviewUI(BuildContext context, PoseDetectionViewModel viewModel) {
    return Stack(
      children: [
        if (viewModel.cameraController.value.isInitialized)
          CameraPreview(viewModel.cameraController)
        else
          const Center(child: CircularProgressIndicator()),
        if (viewModel.customPaint != null)
          Positioned.fill(child: viewModel.customPaint!),
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.all(8),
            color: Colors.black54,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reps: ${viewModel.repetitions}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Shoulder Angle: ${viewModel.currentAngleShoulder}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'OOL: ${viewModel.outOfLimits}',
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



  @override
  Widget buildPage(BuildContext context) {
    var poseDetectionViewModel = context.watch<PoseDetectionViewModel>();

    // If setup is NOT complete, show the arm and repetition selection UI.
    if (!poseDetectionViewModel.isSetupComplete) {
      return _buildArmSelectionUI(context, poseDetectionViewModel);
    } else {
      // If setup IS complete (meaning "Start Exercise" was pressed and successful), show the camera.
      return _buildCameraPreviewUI(context, poseDetectionViewModel);
    }
  }
}