import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../view_models/displayTracking_viewmodel.dart';

import 'package:rehab_app/views/fingerTrackingExerciseNo1_view.dart';


class DisplayTrackingView extends StatefulWidget{
  const DisplayTrackingView({super.key});

  @override
  State<DisplayTrackingView> createState() => _DisplayTrackingViewState();
}

/*
class trajectoryPainter extends CustomPainter{
  final List<Offset> pointsIndex;
  final List<Offset> pointsMiddle;
  final List<Offset> pointsRing;
  final List<Offset> pointsPinky;
  trajectoryPainter(this.pointsIndex,this.pointsMiddle,this.pointsRing,this.pointsPinky);

  @override
  void paint(Canvas canvas, Size size) {
    final paintRed = Paint()
      ..color = Colors.red
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final paintGreen = Paint()
      ..color = Colors.green
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final paintPurple = Paint()
      ..color = Colors.deepPurpleAccent
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final paintBlue = Paint()
      ..color = Colors.blueAccent
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    for (int i = 1; i < pointsIndex.length - 1; i++) {
      if (pointsIndex[i] != null && pointsIndex[i + 1] != null) {
        canvas.drawLine(pointsIndex[i], pointsIndex[i + 1], paintRed);
      }
    }
    for (int i = 1; i < pointsMiddle.length - 1; i++) {
      if (pointsMiddle[i] != null && pointsMiddle[i + 1] != null) {
        canvas.drawLine(pointsMiddle[i], pointsMiddle[i + 1], paintGreen);
      }
    }
    for (int i = 1; i < pointsRing.length - 1; i++) {
      if (pointsRing[i] != null && pointsRing[i + 1] != null) {
        canvas.drawLine(pointsRing[i], pointsRing[i + 1], paintBlue);
      }
    }
    for (int i = 1; i < pointsPinky.length - 1; i++) {
      if (pointsPinky[i] != null && pointsPinky[i + 1] != null) {
        canvas.drawLine(pointsPinky[i], pointsPinky[i + 1], paintPurple);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
*/ //Old code

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

class _DisplayTrackingViewState extends State<DisplayTrackingView> {
  DisplayTrackingViewModel? viewModel;
  //DisplayTrackingViewModel? viewModelExerciseNo1;
  String data = "";
  double dataTextSize = 23;
  ///Stylized parameters
  double buttonSpacing = 30;
  double buttonTextSize = 20;
  Color? buttonTextColor = Colors.orange[300];
  Offset fingerMarkerSize= Offset(100,100); // The big bubble
  Offset fingerMarkerPointSize = Offset(10,10); // The dot

  void initializeViewModel(int numberOfFingers, String hand, bool identification, bool fingersBackAssignment) {
    setState(() {
      viewModel = DisplayTrackingViewModel(
        numberOfFingers: numberOfFingers,
        hand: hand,
        identification: identification,
        fingersBackAssignment: fingersBackAssignment,
        offsetOfFinger: const Offset(50, 50),
        displayOffset: const Offset(0, 50), //The app bar takes 50 pixels
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

  @override
  Widget build(BuildContext context) {
    if (viewModel == null) {
      return Scaffold(
        body: Stack(
          children: [
            //Background
            Positioned.fill(
              child: Opacity(
                opacity: 0.2,
                child:Image.asset(
                  'lib/images/fingerTrackingWorkInProgress.png', //Tha image
                  fit: BoxFit.cover,
                )
              ),
            ),

            //Foreground content (exercise selection)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Select an exercise",
                    style: TextStyle(fontSize: dataTextSize, color: Colors.green[500]),
                  ),
                  SizedBox(height: buttonSpacing*3),

                  ///Buttons ---------------------------------------------------
                  ElevatedButton(
                    onPressed: () => initializeViewModel(1, "Right", false, false),
                    child: Text(
                        "Exercise 1\n1, Right, Identification: false",
                        style: TextStyle(fontSize: buttonTextSize, color: buttonTextColor),
                        textAlign: TextAlign.center
                    ),
                  ),
                  SizedBox(height: buttonSpacing),

                  ElevatedButton(
                    onPressed: () => initializeViewModel(2, "Right", false, false),
                    child: Text(
                        "Exercise 2\n2, Right, Identification: false",
                        style: TextStyle(fontSize: buttonTextSize, color: buttonTextColor),
                        textAlign: TextAlign.center
                    ),
                  ),
                  SizedBox(height: buttonSpacing),

                  ElevatedButton(
                    onPressed: () => initializeViewModel(3, "Right", false, false),
                    child: Text(
                        "Exercise 3\n3, Right, Identification: false",
                        style: TextStyle(fontSize: buttonTextSize, color: buttonTextColor),
                        textAlign: TextAlign.center
                    ),
                  ),
                  SizedBox(height: buttonSpacing),

                  ElevatedButton(
                    onPressed: () => initializeViewModel(4, "Right", false, false),
                    child: Text(
                        "Exercise 4\n4, Right, Identification: false",
                        style: TextStyle(fontSize: buttonTextSize, color: buttonTextColor),
                        textAlign: TextAlign.center
                    ),
                  ),
                  SizedBox(height: buttonSpacing),

                  ElevatedButton(
                    onPressed: () => initializeViewModel(5, "Right", true, true),
                    child: Text(
                        "Exercise 5\n5, Right, Identification: true",
                        style: TextStyle(fontSize: buttonTextSize, color: buttonTextColor),
                        textAlign: TextAlign.center
                    ),
                  ),
                  SizedBox(height: buttonSpacing),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => Scaffold(
                            appBar: AppBar(title: const Text("Exercise No1")),
                            body: const FingerTrackingExerciseNo1View(),
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "Real Exercise No1\n5, Right, Identification: true",
                      style: TextStyle(fontSize: buttonTextSize, color: buttonTextColor),
                      textAlign: TextAlign.center,
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

    //Show when you have something to show
    return ChangeNotifierProvider.value(
      value: viewModel!,
      child: Consumer<DisplayTrackingViewModel>(
        builder: (context, viewmodel, child) {
          return Scaffold(
            body: Listener(
              onPointerDown: viewmodel.onPointerDown,
              onPointerMove: viewmodel.onPointerMove,
              onPointerUp: viewmodel.onPointerUp,
              behavior: HitTestBehavior.translucent,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Opacity(
                        opacity: 0.05,
                        child:Image.asset(
                          'lib/images/CopperBusines.png', //Tha image
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

                  //Fingers pointies
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

                  // trajectory painter
                  Opacity(
                    opacity: 0.3,
                    child: CustomPaint(
                      painter: _DynamicTrajectoryPainter(viewmodel),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

}

