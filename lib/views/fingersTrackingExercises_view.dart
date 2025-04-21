import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rehab_app/services/page_management/models/stateful_page_model.dart';

import '../view_models/displayTracking_viewmodel.dart';

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
  //DisplayTrackingViewModel? viewModelExerciseNo1;
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

  Widget _buildHandButton(String side) {
    final isSelected = hand == side;

    return SizedBox(
      width: 240,
      height: 75,
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

  Widget _buildHardnessCheckbox(int value, String label, {double scale = 1.5}) {
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
            //Background
            Positioned.fill(
              child: Opacity(
                  opacity: 0.2,
                  child:Image.asset(
                    'assets/images/fingerTrackingWorkInProgress.png', //Tha image
                    fit: BoxFit.cover,
                  )
              ),
            ),

            //Foreground content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Choose parameters of the exercise",
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
                  _buildHardnessCheckbox(1, "   Soft       ", scale: checkboxScale),
                  SizedBox(height: buttonSpacing * 2),

                  _buildHardnessCheckbox(2, "   Medium", scale: checkboxScale),
                  SizedBox(height: buttonSpacing * 2),

                  _buildHardnessCheckbox(3, "   Hard      ", scale: checkboxScale),
                  SizedBox(height: buttonSpacing * 2),


                  // Example button using the selected hand/hardness
                  ElevatedButton(
                    onPressed: () {
                      //print("Exercise selected with: Hand = $hand, Hardness = $hardness");
                      initializeViewModel(1, hand, false, false);
                    },
                    child: Text(
                      "Start Exercise\nHand: $hand | Hardness: $hardness",
                      style: TextStyle(fontSize: buttonTextSize, color: buttonTextColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

            /*
            //Foreground content (exercise selection)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Chose parameters of the exercise",
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

                  SizedBox(
                    width: 240,
                    height: 70,
                    child: OutlinedButton(
                      onPressed: () {
                        print('OutlinedButton pressed!');
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.primary, // Still themed border
                          width: 3.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Button',
                        style: TextStyle(
                          fontSize: buttonTextSize,
                          color: Theme.of(context).textTheme.bodyMedium?.color, // Text color adapts too
                        ),
                      ),
                    ),
                  )
                  ///Buttons ---------------------------------------------------
                ],
              ),
            ),
            */
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