import 'package:flutter/material.dart';
import '../models/exercise_ball_model.dart';
import 'dart:math';


class ExerciseBallViewModel extends ChangeNotifier {
  ExerciseBallModel exerciseBallModel;
  Color _currentColor = Colors.blue; // Default color
  Offset startPosition = Offset.zero;
  Offset currentPosition = Offset.zero;
  Offset goalPosition = Offset.zero;
  int numberOfRepetitions = 0;
  int difficulty = -1;
  Size ?screenSizeData;
  static const double marginFromEdges = 100.0;
  bool exerciseDone = false;
  int distanceFromGoal = 5;

  double exerciseResultError = 0.0;
  List<double> exerciseResultErrorList = [];
  String exerciseResultMark = "/";

  ExerciseBallViewModel({
    required bool exerciseDone,
    required String typeOfObject,
    required List<double?> wightAndHeight,
    Offset? initialPosition,
    Offset? holeForTheBallPosition,
    required int hardness,
    required bool showObject,
    required Size screenSize,
    double marginFromEdges = marginFromEdges,
  }) : exerciseBallModel = ExerciseBallModel(objectType: typeOfObject) {
    exerciseBallModel.wightAndHeight = wightAndHeight;
    exerciseBallModel.currentPosition = initialPosition ?? Offset.zero;
    currentPosition = initialPosition ?? Offset.zero; // Set currentPosition
    goalPosition = holeForTheBallPosition ?? Offset.zero; // Set goalPosition
    difficulty = hardness;
    screenSizeData= screenSize;
    exerciseDone = exerciseDone;
    initializePositions(screenSize: screenSize, marginFromEdges: marginFromEdges);
  }

  Color get currentColor => _currentColor;
  bool get isVisible => exerciseBallModel.showObject;
  List<double?> get size => exerciseBallModel.wightAndHeight;

  void initializePositions({
    required Size screenSize,
    required double marginFromEdges,
  }) {
    final Random random = Random();

    double usableWidth = screenSize.width - 2 * marginFromEdges;
    double usableHeight = screenSize.height - 2 * marginFromEdges;

    // Left half for currentPosition
    double currentX = marginFromEdges + random.nextDouble() * (usableWidth / 2);
    double currentY = marginFromEdges + random.nextDouble() * usableHeight;

    // Right half for goalPosition
    double goalX = marginFromEdges + (usableWidth / 2) + random.nextDouble() * (usableWidth / 2);
    double goalY = marginFromEdges + random.nextDouble() * usableHeight;

    currentPosition = Offset(currentX, currentY);
    startPosition = Offset(currentX, currentY);
    goalPosition = Offset(goalX, goalY);

    ///Testing [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
    goalPosition = Offset(screenSize.width/2, screenSize.height/2);
    ///[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]

    exerciseBallModel.currentPosition = currentPosition;

    checkExerciseProgress();

    notifyListeners();
  }

  void checkExerciseProgress() {
    if (exerciseDone) return;
    //Hardness of the exercise 1 - soft 2 - medium 3 - hard
    if(difficulty == 1) {
      if(numberOfRepetitions >= 1) {
        exerciseDone = true;
      }
      distanceFromGoal = 20;
    } else if(difficulty == 2) {
      if(numberOfRepetitions >= 6) {
        exerciseDone = true;
      }
      distanceFromGoal = 10;
    } else if(difficulty == 3) {
      if(numberOfRepetitions >= 10) {
        exerciseDone = true;
      }
      distanceFromGoal = 5;
    }

    if(exerciseDone) {
      ///Logger implementation

      ///Processing data
      exerciseProcessData();
      ///
      print("Exercise done");
      exerciseBallModel.trajectoryOfObject.clear();
    }
    //Reset the ball positions
    if(!exerciseDone && numberOfRepetitions > 0)initializePositions(screenSize: screenSizeData ?? const Size(300, 600), marginFromEdges: marginFromEdges);

    notifyListeners();
  }

  void exerciseProcessData(){
    ///Optimal trajectory
    ///from start to finish
    ///startPosition - goalPosition
    ///exerciseBallModel.trajectoryOfObject compare

    calculateTrajectoryError();
    notifyListeners();
  }

  void calculateTrajectoryError() {
    if (exerciseBallModel.trajectoryOfObject.isEmpty) {
      exerciseResultError = 0.0;
      exerciseResultErrorList.clear(); // Clear the list if no trajectory exists
      return;
    }

    // Extract start and goal positions
    final Offset start = startPosition;
    final Offset goal = goalPosition;

    // Line equation coefficients: Ax + By + C = 0
    final double A = goal.dy - start.dy; // y2 - y1
    final double B = start.dx - goal.dx; // x1 - x2
    final double C = goal.dx * start.dy - start.dx * goal.dy; // x2*y1 - x1*y2

    // Clear the error list before recalculating
    exerciseResultErrorList.clear();

    // Calculate squared errors
    double totalSquaredError = 0.0;
    for (final point in exerciseBallModel.trajectoryOfObject) {
      // Perpendicular distance formula: |Ax + By + C| / sqrt(A^2 + B^2)
      final double distance = (A * point.dx + B * point.dy + C).abs() / sqrt(A * A + B * B);
      final double squaredError = distance * distance;

      // Save individual squared error to the list
      exerciseResultErrorList.add(squaredError);

      totalSquaredError += squaredError;
    }

    // Print all error points
    print("Error Points: $exerciseResultErrorList");

    // Mean Squared Error
    exerciseResultError = totalSquaredError / exerciseBallModel.trajectoryOfObject.length;

    // Optionally, assign a grade or mark based on the error
    if (exerciseResultError < 5.0) {
      exerciseResultMark = "Excellent";
    } else if (exerciseResultError < 10.0) {
      exerciseResultMark = "Good";
    } else {
      exerciseResultMark = "Needs Improvement";
    }

    notifyListeners();
  }

  void changeColor(Color newColor) {
    _currentColor = newColor;
    notifyListeners();
  }

  void setVisible(bool isVisible) {
    exerciseBallModel.showObject = isVisible;
    notifyListeners();
  }

  void setPosition(Offset finger1, Offset finger2) {

    double tootooCloseDistance = 80;
    double tooCloseDistance = 90;
    double midCloseDistance = 120;
    double tooFarDistance = 130;

    Offset hitBoxOfBall = Offset(30, 30); //Could be changed by the size of the object

    bool slightlyHoldingBall = false;
    bool holdingBall = false;
    bool squeezingBall = false;
    bool freeBall = false;

    bool finger1InRange = false;
    bool finger2InRange = false;

    Offset midPointOfFingers = Offset(
      (finger1.dx + finger2.dx) / 2,
      (finger1.dy + finger2.dy) / 2,
    );

    double finger1Distance = (finger1 - currentPosition).distance;
    double finger2Distance = (finger2 - currentPosition).distance;


    if(finger1Distance < tooFarDistance && finger1Distance > tootooCloseDistance) finger1InRange = true;
    if(finger2Distance < tooFarDistance && finger2Distance > tootooCloseDistance) finger2InRange = true;

    ///For testing [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
    finger1InRange= true;
    finger2InRange= true;
    ///[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]

    if(finger1InRange && finger2InRange) {
      if ((midPointOfFingers - currentPosition).distance < hitBoxOfBall.dx && (midPointOfFingers - currentPosition).distance < hitBoxOfBall.dy) {
        currentPosition = midPointOfFingers;
      }

      //Distance between the fingers
      if( (finger1Distance < tooFarDistance && finger1Distance > midCloseDistance) &&
          (finger2Distance < tooFarDistance && finger2Distance > midCloseDistance) ) {
        slightlyHoldingBall = true;
      }else if( (finger1Distance < midCloseDistance && finger1Distance > tooCloseDistance) &&
                (finger2Distance < midCloseDistance && finger2Distance > tooCloseDistance) ) {
        holdingBall = true;
      }else if( ( finger1Distance < tooCloseDistance && finger1Distance > tootooCloseDistance) &&
                (finger2Distance < tooCloseDistance && finger2Distance > tootooCloseDistance) ) {
        squeezingBall = true;
      }
    }else{
      freeBall = true;
    }



    //Change color based on pressure of holding
    if(slightlyHoldingBall) changeColor(Colors.indigoAccent);
    if(holdingBall) changeColor(Colors.green);
    if(squeezingBall) changeColor(Colors.red[400]!);
    if(freeBall) changeColor(Colors.blue[400]!);


    //Save the trajectory of the object
    exerciseBallModel.trajectoryOfObject.add(currentPosition);

    //Checking if the object is in the goal
    if((currentPosition - goalPosition).distance < distanceFromGoal) {
      numberOfRepetitions++;
      checkExerciseProgress();
    }

    notifyListeners();
  }
}
