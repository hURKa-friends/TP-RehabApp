import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rehab_app/services/page_management/models/stateful_page_model.dart';

import '../models/displayTracking_model.dart';
import '../view_models/displayTracking_viewmodel.dart';
import '../view_models/exercise_ball_viewmodel.dart';
import '../views/exercise_ball_view.dart';

import 'package:rehab_app/views/fingerTrackingExerciseNo1_view.dart';

class FingersTrackingExercisesView extends StatefulPage {
  const FingersTrackingExercisesView({
    super.key,
    required super.icon,
    required super.title,
    super.tutorialSteps
  });

  @override
  void initPage(BuildContext context) {
    // Intentionally left empty as no setup is needed here
  }

  @override
  void closePage(BuildContext context) {
    // Intentionally left empty as no cleanup is needed here
  }

  @override
  FingersTrackingExercisesViewState createState() => FingersTrackingExercisesViewState();
}

class _DynamicTrajectoryPainter extends CustomPainter {
  final DisplayTrackingViewModel model;
  final List<Paint> paints = [
    Paint()..color = Colors.red..strokeWidth = 10..strokeCap = StrokeCap.round,
    Paint()..color = Colors.green..strokeWidth = 10..strokeCap = StrokeCap.round,
    Paint()..color = Colors.blueAccent..strokeWidth = 10..strokeCap = StrokeCap.round,
    Paint()..color = Colors.deepPurpleAccent..strokeWidth = 10..strokeCap = StrokeCap.round,
    Paint()..color = Colors.orange..strokeWidth = 10..strokeCap = StrokeCap.round,
  ];

  _DynamicTrajectoryPainter(this.model);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < model.fingers.length; i++) {
      final trajectory = model.fingers[i].pointerFingerTrajectory;
      final paint = paints[i % paints.length];

      final recentPoints = trajectory.length > 100
          ? trajectory.sublist(trajectory.length - 100)
          : trajectory;

      for (int j = 1; j < recentPoints.length; j++) {
        canvas.drawLine(
          recentPoints[j - 1] - model.displayTrackingModel.displayOffset - const Offset(0, 5),
          recentPoints[j] - model.displayTrackingModel.displayOffset - const Offset(0, 5),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class FingersTrackingExercisesViewState extends StatefulPageState {
  DisplayTrackingViewModel? viewModel;

  String data = "";
  double dataTextSize = 23;
  ///Stylized parameters
  double buttonSpacing = 30;
  double buttonTextSize = 20;
  Color? buttonTextColor = Colors.orange[300];
  Offset fingerMarkerSize= Offset(100,100); // The big bubble
  Offset fingerMarkerPointSize = Offset(10,10); // The dot
  double checkboxScale = 3.0;

  //Choosing the parameters of the exercise
  String hand = '';
  int hardness = -1;

  void initializeViewModel(int numberOfFingers, String hand, bool identification, bool fingersBackAssignment) {
    setState(() {
      viewModel = DisplayTrackingViewModel(
        exerciseDone: false,
        numberOfFingers: numberOfFingers,
        hand: hand,
        identification: identification,
        fingersBackAssignment: fingersBackAssignment,
        offsetOfFinger: const Offset(50, 50),
        displayOffset: const Offset(0, 50), //The app bar takes 50 pixels

        //Parameters for the exercise ball
        typeOfObject: '1', // Example: Ball type
        wightAndHeight: [150.0, 150.0], // Example: Ball size
        initialPosition: const Offset(500, 500), // Example: Initial position
        holeForTheBallPosition: const Offset(500, 500), // Example: Hole position
        hardness: hardness, // Example: Hardness
        showObject: true,
        screenSizeData: MediaQuery.of(context).size,
      );
    });
  }

  Widget _buildFingerMarkerNameTag(String label) {
    return Container(
      width: fingerMarkerSize.dx,
      height: fingerMarkerSize.dy,
      decoration: BoxDecoration(
        color: Colors.blueAccent[200]!.withOpacity(0.25),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(label, style: const TextStyle(fontSize: 24, color: Colors.black12)),
      ),
    );
  }

  Widget _buildFingerMarkerPoint() {
    return Container(
      width: fingerMarkerPointSize.dx,
      height: fingerMarkerPointSize.dy,
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildExerciseBallMarker(ExerciseBallViewModel exerciseBallViewModel,DisplayTrackingModel displayTrackingModel, {String? label}) {
    final width = exerciseBallViewModel.size[0] ?? 50.0;
    final height = exerciseBallViewModel.size[1] ?? 50.0;
    final position = exerciseBallViewModel.currentPosition - displayTrackingModel.displayOffset;

    return Positioned(
      left: position.dx - width / 2,
      top: position.dy - height / 2,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: exerciseBallViewModel.currentColor.withOpacity(0.8),
          shape: exerciseBallViewModel.exerciseBallModel.objectType == '1' ? BoxShape.circle : BoxShape.rectangle,
        ),
        child: label != null
            ? Center(
          child: Text(
            label,
            style: const TextStyle(fontSize: 24, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        )
            : null,
      ),
    );
  }
  Widget _buildExerciseBallGoalMarker(ExerciseBallViewModel exerciseBallViewModel){
    return Positioned(
      left: exerciseBallViewModel.goalPosition.dx - 25,
      top: exerciseBallViewModel.goalPosition.dy - 25 -50,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildHandButton(String side) {
    final isSelected = hand == side;

    return SizedBox(
      width: 150,
      height: 100,
      child: OutlinedButton(
        onPressed: () {
          setState(() {
            hand = side;
          });
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
              : Theme.of(context).scaffoldBackgroundColor,
          side: BorderSide(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey,
            width: 2.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          side,
          style: TextStyle(
            fontSize: buttonTextSize,
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyCheckbox(int value, String label, {double scale = 1.5}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Transform.scale(
          scale: scale, // Makes the checkbox bigger
          child: Checkbox(
            value: hardness == value,
            onChanged: (_) {
              setState(() {
                hardness = value;
              });
            },
          ),
        ),
        SizedBox(width: 8),
        Text(label, style: TextStyle(fontSize: buttonTextSize)),
      ],
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    if (viewModel == null) {
      return Scaffold(
        body: Stack(
          children: [
            //Background images
            Positioned.fill(
              child: Opacity(
                  opacity: 0.2,
                  child:Image.asset(
                    'assets/images/fingerTrackingWorkInProgress.png', //Tha image
                    fit: BoxFit.cover,
                  )
              ),
            ),

            //Foreground content - buttons
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ///Buttons ---------------------------------------------------
                  Text(
                    "Choose the parameters of the exercise",
                    style: TextStyle(fontSize: dataTextSize, color: Colors.green[500]),
                  ),
                  SizedBox(height: buttonSpacing * 2),

                  // Hand Selection Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildHandButton("Right"),
                      SizedBox(width: 16),
                      _buildHandButton("Left"),
                    ],
                  ),

                  SizedBox(height: buttonSpacing * 2),

                  // Hardness Checkboxes
                  _buildDifficultyCheckbox(1, "   Soft       ", scale: checkboxScale),
                  SizedBox(height: buttonSpacing),

                  _buildDifficultyCheckbox(2, "   Medium", scale: checkboxScale),
                  SizedBox(height: buttonSpacing),

                  _buildDifficultyCheckbox(3, "   Hard      ", scale: checkboxScale),
                  SizedBox(height: buttonSpacing*2),


                  //Starting the exercise
                  Visibility(
                    visible: hand.isNotEmpty && hardness != -1,
                    child: SizedBox(
                      width: 200,
                      height: 100,
                      child: ElevatedButton(
                        onPressed: () {
                          initializeViewModel(2, hand, false, false); //Starting the exercise -----------------------------------------------------------------------
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent, // your color
                          foregroundColor: buttonTextColor, // for ripple effect etc.
                          textStyle: TextStyle(fontSize: buttonTextSize),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12), // if you want rounded corners
                          ),
                        ),
                        child: Text(
                          "Start Exercise",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: dataTextSize, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  ///Buttons ---------------------------------------------------
                ],
              ),
            ),

          ],
        ),
      );
    }
    
    //Show when you have something to show - aka changes to the exercise
    return ChangeNotifierProvider.value(
      value: viewModel!,
      child: Consumer<DisplayTrackingViewModel>(
        builder: (context, viewmodel, child) {
          return Scaffold(
            body: Listener( //Listener for the fingers
              onPointerDown: viewmodel.onPointerDown,
              onPointerMove: viewmodel.onPointerMove,
              onPointerUp: viewmodel.onPointerUp,
              behavior: HitTestBehavior.translucent,
              child: Stack(
                children: [
                  //Background images
                  Positioned.fill(
                    child: Opacity(
                        opacity: 0.05,
                        child:Image.asset(
                          'assets/images/CopperBusines.png', //Tha image
                          fit: BoxFit.cover,
                        )
                    ),
                  ),

                  GestureDetector(//Very good note - THIS IS VERY IMPORTANT FOR EVEN DETECTING POINTER DOWN, MOVE OR UP - FVERY IMPORTANT DONT, OR I SMACK YOU
                    onTap: () => setState(() => data = "Tapped!"),
                    onDoubleTap: () => setState(() => data = "Double Tapped!"),
                    onHorizontalDragEnd: (details) {
                      setState(() => data =
                      details.primaryVelocity! < 0 ? "Swiped Left!" : "Swiped Right!");
                    },
                    child: Center(
                      child: Text(
                        data,
                        style: TextStyle(fontSize: dataTextSize, color: Colors.black12),
                      ),
                    ),
                  ),

                  //Fingers pointer - display where is the finger pointing on the screen
                  ...viewmodel.fingers.map((finger) {
                    if (finger.pointerFingerTrajectory.isEmpty) return const SizedBox.shrink();

                    final lastPoint = finger.pointerFingerTrajectory.last;
                    final displayOffset = viewmodel.displayTrackingModel.displayOffset;

                    return Stack(
                      children: [
                        Positioned(
                          left: lastPoint.dx - fingerMarkerSize.dx/2,
                          top: lastPoint.dy-displayOffset.dy - fingerMarkerSize.dy/2,
                          child: _buildFingerMarkerNameTag(finger.fingerName),
                        ),
                        /*
                        Positioned(
                          left: lastPoint.dx - displayOffset.dx/2,
                          top: lastPoint.dy - displayOffset.dy/2,
                          child: _buildFingerMarkerPoint(),
                        ),
                        */
                      ],
                    );
                  }),

                  //Exercise objects/ball
                  _buildExerciseBallMarker(viewmodel.exerciseBallViewModel, viewmodel.displayTrackingModel, label: "-"),
                  _buildExerciseBallGoalMarker(viewmodel.exerciseBallViewModel),
                  //Trajectory painter - displaying the trajectory of the finger
                  Opacity(
                    opacity: 0.3,
                    child: CustomPaint(
                      painter: _DynamicTrajectoryPainter(viewmodel),
                    ),
                  ),

                ],
              ),
            ),          );
        },
      ),
    );
  }
}