import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:rehab_app/services/page_management/models/stateful_page_model.dart';

import '../../models/displayTracking_model.dart';
import '../../view_models/brano/displayTracking_viewmodel.dart';
import '../../view_models/brano/exercise_ball_viewmodel.dart';

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

class _OptimalTrajectoryPainter extends CustomPainter {
  final List<Offset> optimalTrajectory;
  static const double displayShiftY = 50;

  _OptimalTrajectoryPainter(this.optimalTrajectory);

  @override
  void paint(Canvas canvas, Size size) {
    if (optimalTrajectory.isEmpty) return;

    final linePaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    final startPointPaint = Paint()
      ..color = Colors.deepPurple
      ..style = PaintingStyle.fill;

    final endPointPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    // Draw trajectory lines with shifted points
    for (int i = 1; i < optimalTrajectory.length; i++) {
      final Offset start = optimalTrajectory[i - 1] - Offset(0, displayShiftY);
      final Offset end = optimalTrajectory[i] - Offset(0, displayShiftY);
      canvas.drawLine(start, end, linePaint);
    }

    // Draw start point (green dot) with shift
    canvas.drawCircle(optimalTrajectory.first - Offset(0, displayShiftY), 10.0, startPointPaint);

    // Draw end point (red dot) with shift
    canvas.drawCircle(optimalTrajectory.last - Offset(0, displayShiftY), 10.0, endPointPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class FingersTrackingExercisesViewState extends StatefulPageState {
  DisplayTrackingViewModel? viewModel;

  bool noFunny = true;

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
          //color: exerciseBallViewModel.currentColor.withOpacity(0.8),
          color: Colors.transparent,
          shape: exerciseBallViewModel.exerciseBallModel.objectType == '1' ? BoxShape.circle : BoxShape.rectangle,
          border: Border.all(
            color: exerciseBallViewModel.currentColor.withOpacity(0.8), // Edge color
            width: 25.0, // Thickness of the edge
          )
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
          color: Colors.cyanAccent,
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
            noFunny
                ? SizedBox.shrink() // When `noFunny` is true, show nothing
                : Positioned.fill(
              child: Opacity(
                opacity: 0.2,
                child: Image.asset(
                  'assets/images/fingerTrackingWorkInProgress.png', // The image
                  fit: BoxFit.cover,
                ),
              ),
            ),
            //Foreground content - buttons
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ///Buttons ---------------------------------------------------
                  Center(
                    child: Text(
                      "Choose the parameters of the exercise",
                      style: TextStyle(fontSize: dataTextSize, color: Colors.green[500]),
                    ),
                  ),
                  SizedBox(height: buttonSpacing * 2),

                  // Hand Selection Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildHandButton("Left"),
                      SizedBox(width: 16),
                      _buildHandButton("Right"),
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
          if (viewmodel.exerciseDone) {
            // Show something else if the exercise is done
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Exercise Completed!",
                      style: TextStyle(fontSize: 32, color: Colors.green[700]),
                    ),
                    SizedBox(height: 30),
                    Text(
                      "Mean Squared Error: ${viewmodel.exerciseBallViewModel.exerciseResultError.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 20),
                    Text(
                      viewmodel.exerciseBallViewModel.exerciseResultMark,
                      style: TextStyle(
                        fontSize: 40,
                        color: _getColorByMark(viewmodel.exerciseBallViewModel.exerciseResultMark),
                      ),
                    ),
                    SizedBox(height: 20),

                    ///Experimental graph [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
                    Expanded(
                      child: SfCartesianChart(
                        legend: Legend(isVisible: true),
                        primaryXAxis: NumericAxis(
                          title: AxisTitle(text: 'Point'),
                          interval: 100, // Ensures all indices are displayed
                          edgeLabelPlacement: EdgeLabelPlacement.shift, // Prevents label overlap
                        ),
                        primaryYAxis: NumericAxis(
                          title: AxisTitle(text: 'Error Value'),
                          minimum: viewmodel.exerciseBallViewModel.allMeasurements.isNotEmpty
                              ? viewmodel.exerciseBallViewModel.allMeasurements
                              .expand((list) => list)
                              .reduce((a, b) => a < b ? a : b) - 1
                              : 0,
                          maximum: viewmodel.exerciseBallViewModel.allMeasurements.isNotEmpty
                              ? viewmodel.exerciseBallViewModel.allMeasurements
                              .expand((list) => list)
                              .reduce((a, b) => a > b ? a : b) + 1
                              : 1,
                        ),
                        series: viewmodel.exerciseBallViewModel.allMeasurements
                            .asMap()
                            .entries
                            .map((entry) {
                          final measurementIndex = entry.key;
                          final measurement = entry.value;
                          return LineSeries<_ErrorData, int>(
                            name: 'Exercise ${measurementIndex + 1}',
                            dataSource: measurement
                                .asMap()
                                .entries
                                .map((e) => _ErrorData(index: e.key, error: e.value))
                                .toList(),
                            xValueMapper: (_ErrorData data, _) => data.index, // X-axis: Point (Index)
                            yValueMapper: (_ErrorData data, _) => data.error, // Y-axis: Error Value
                            animationDuration: 0,
                            markerSettings: MarkerSettings(
                              isVisible: true, // Show markers for all points
                              shape: DataMarkerType.circle,
                              width: 1,
                              height: 1,
                            ),
                          );
                        })
                            .toList(),
                      ),
                    ),
                    ///Experimental graph [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          viewModel = null; // Return to parameter selection
                          hand = '';
                          hardness = -1;
                        });
                      },
                      child: Text("Back to Setup", style: TextStyle(fontSize: 20)),
                    ),
                  ],
                ),
              ),
            );
          }

          // Otherwise, show the finger tracking exercise UI

          return Scaffold(
            body: Listener(
              onPointerDown: viewmodel.onPointerDown,
              onPointerMove: viewmodel.onPointerMove,
              onPointerUp: viewmodel.onPointerUp,
              behavior: HitTestBehavior.translucent,
              child: Stack(
                children: [
                  // Background
                  noFunny
                      ? SizedBox.shrink() // When `noFunny` is true, show nothing
                      : Positioned.fill(
                    child: Opacity(
                      opacity: 0.2,
                      child: Image.asset(
                        'assets/images/fingerTrackingWorkInProgress.png', // The image
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  GestureDetector(
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

                  // Finger positions
                  ...viewmodel.fingers.map((finger) {
                    if (finger.pointerFingerTrajectory.isEmpty) return const SizedBox.shrink();
                    final lastPoint = finger.pointerFingerTrajectory.last;
                    final displayOffset = viewmodel.displayTrackingModel.displayOffset;

                    return Positioned(
                      left: lastPoint.dx - fingerMarkerSize.dx / 2,
                      top: lastPoint.dy - displayOffset.dy - fingerMarkerSize.dy / 2,
                      child: _buildFingerMarkerNameTag(finger.fingerName),
                    );
                  }),

                  // Exercise Ball and Goal
                  _buildExerciseBallMarker(viewmodel.exerciseBallViewModel, viewmodel.displayTrackingModel, label: "-"),
                  _buildExerciseBallGoalMarker(viewmodel.exerciseBallViewModel),

                  //Finger Trajectory Paint
                  Opacity(
                    opacity: 0.3,
                    child: CustomPaint(
                      painter: _DynamicTrajectoryPainter(viewmodel),
                    ),
                  ),

                  // Optimal Trajectory Paint
                  Opacity(
                    opacity: 0.8,
                    child: CustomPaint(
                      painter: _OptimalTrajectoryPainter(viewmodel.exerciseBallViewModel.optimalTrajectory),
                      child: Container(), // Acts as a canvas
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
    /*
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
    */
  }
}

class _ErrorData {
  final int index;
  final double error;

  _ErrorData({required this.index, required this.error});
}
Color _getColorByMark(String mark) {
  switch (mark) {
    case "A":
      return Colors.green;
    case "B":
      return Colors.lightGreen;
    case "C":
      return Colors.yellow;
    case "D":
      return Colors.orange;
    case "E":
    case "F":
      return Colors.red;
    default:
      return Colors.black; // Default color for invalid marks
  }
}

/*
*return Scaffold(
            body: Listener(
              onPointerDown: viewmodel.onPointerDown,
              onPointerMove: viewmodel.onPointerMove,
              onPointerUp: viewmodel.onPointerUp,
              behavior: HitTestBehavior.translucent,
              child: Stack(
                children: [
                  // Background
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.05,
                      child: Image.asset(
                        'assets/images/CopperBusines.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  GestureDetector(
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

                  // Finger positions
                  ...viewmodel.fingers.map((finger) {
                    if (finger.pointerFingerTrajectory.isEmpty) return const SizedBox.shrink();
                    final lastPoint = finger.pointerFingerTrajectory.last;
                    final displayOffset = viewmodel.displayTrackingModel.displayOffset;

                    return Positioned(
                      left: lastPoint.dx - fingerMarkerSize.dx / 2,
                      top: lastPoint.dy - displayOffset.dy - fingerMarkerSize.dy / 2,
                      child: _buildFingerMarkerNameTag(finger.fingerName),
                    );
                  }),

                  // Exercise Ball and Goal
                  _buildExerciseBallMarker(viewmodel.exerciseBallViewModel, viewmodel.displayTrackingModel, label: "-"),
                  _buildExerciseBallGoalMarker(viewmodel.exerciseBallViewModel),

                  //Finger Trajectory Paint
                  Opacity(
                    opacity: 0.3,
                    child: CustomPaint(
                      painter: _DynamicTrajectoryPainter(viewmodel),
                    ),
                  ),

                  // Optimal Trajectory Paint
                  Opacity(
                    opacity: 0.8,
                    child: CustomPaint(
                      painter: _OptimalTrajectoryPainter(viewmodel.exerciseBallViewModel.optimalTrajectory),
                      child: Container(), // Acts as a canvas
                    ),
                  ),
                ],
              ),
            ),
          );
* */