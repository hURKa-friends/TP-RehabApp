import 'package:flutter/material.dart';
import '../../models/exercise_ball_model.dart';
import 'dart:math';


class ExerciseBallViewModel extends ChangeNotifier {

  bool debuggingMode = false;

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

  ///Optimal trajectory [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
  int numberOfPointsInTrajectory = 5;
  List<Offset> optimalTrajectory = [];

  ///Trajectory memory
  List<List<Offset>> allTrajectoriesMeasurements = [];

  ///Results [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
  double exerciseResultError = 0.0;
  List<double> exerciseResultErrorList = []; //Error for each point in trajectory
  List<List<double>> allMeasurements = []; //Each tries
  String exerciseResultMark = "/";

  ///Flags [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
  bool initializeFlagDone = false;
  bool goalReachedFlag = false;

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

  /*
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
    if(debuggingMode)goalPosition = Offset(screenSize.width/2, screenSize.height/2);
    ///[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]

    exerciseBallModel.currentPosition = currentPosition;

    initializeFlagDone= true;
    goalReachedFlag= false;

    notifyListeners();
  }

   */

  void initializePositions({required Size screenSize, required double marginFromEdges,  }) {
    final double usableWidth = screenSize.width - 2 * marginFromEdges;
    final double usableHeight = screenSize.height - 2 * marginFromEdges;
    final Random random = Random();

    // Clear the optimalTrajectory list
    optimalTrajectory.clear();

    // Generate points with random x positions and evenly spaced y positions
    for (int i = 0; i < numberOfPointsInTrajectory; i++) {
      double xPosition = marginFromEdges + random.nextDouble() * usableWidth;
      double yPosition = marginFromEdges + (i * (usableHeight / (numberOfPointsInTrajectory - 1)));
      optimalTrajectory.add(Offset(xPosition, yPosition));
    }

    print("Optimal Trajectory: $optimalTrajectory");

    // Set the first point as the start and current position
    currentPosition = optimalTrajectory.first;
    startPosition = optimalTrajectory.first;

    // Set the last point as the goal position
    goalPosition = optimalTrajectory.last;


    print("Optimal Trajectory: $optimalTrajectory");

    // Update the exercise ball's current position
    exerciseBallModel.currentPosition = currentPosition;

    initializeFlagDone = true;
    goalReachedFlag = false;

    notifyListeners();
  }

  void checkExerciseProgress() {
    if (exerciseDone) return;
    
    if(debuggingMode)print("Exercise progress check");

    //Reset the ball positions
    if (!exerciseDone && numberOfRepetitions > 0 && initializeFlagDone && goalReachedFlag) {
      //Save the trajectory error
      allTrajectoriesMeasurements.add(exerciseBallModel.trajectoryOfObject.toList());
      exerciseBallModel.trajectoryOfObject.clear();
      //

      initializeFlagDone= false;
      initializePositions(screenSize: screenSizeData ?? const Size(300, 600), marginFromEdges: marginFromEdges);
    }

    //Hardness of the exercise 1 - soft 2 - medium 3 - hard
    if (difficulty == 1) {
      if (numberOfRepetitions >= 1)exerciseDone = true;
      distanceFromGoal = 20;

    } else if (difficulty == 2) {
      if (numberOfRepetitions >= 3)exerciseDone = true;
      distanceFromGoal = 10;

    } else if (difficulty == 3) {
      if (numberOfRepetitions >= 6)exerciseDone = true;
      distanceFromGoal = 5;
    }

    if(exerciseDone)endingExercise();

    notifyListeners();
  }

  void endingExercise() {
    initializeFlagDone = false;

    //calculateTrajectoryError();

    computeAndStorePerpendicularErrors();

    exerciseResultMark=grading();

    print("Exercise ending turn on");
    
    notifyListeners();
  }

  /*
  double _squaredDistanceToSegment(Offset p, Offset a, Offset b) {
    final dx = b.dx - a.dx;
    final dy = b.dy - a.dy;

    if (dx == 0 && dy == 0) {
      // a == b, segment is a point
      return (p - a).distanceSquared;
    }

    // Project point p onto the line segment ab, and clamp to [0,1]
    final t = ((p.dx - a.dx) * dx + (p.dy - a.dy) * dy) / (dx * dx + dy * dy);
    final clampedT = t.clamp(0.0, 1.0);
    final projection = Offset(
      a.dx + clampedT * dx,
      a.dy + clampedT * dy,
    );

    return (p - projection).distanceSquared;
  }
  void calculateTrajectoryError() {
    print("Calculation");

    if (optimalTrajectory.length < 2) {
      print("Optimal trajectory must have at least two points.");
      return;
    }

    allMeasurements.clear(); // Clear previous results

    for (final measurement in allTrajectoriesMeasurements) {
      List<double> squaredErrors = [];
      double totalSquaredError = 0.0;

      for (final point in measurement) {
        double minSquaredDistance = double.infinity;

        // Compare against each segment in optimalTrajectory
        for (int i = 0; i < optimalTrajectory.length - 1; i++) {
          Offset a = optimalTrajectory[i];
          Offset b = optimalTrajectory[i + 1];

          double distSq = _squaredDistanceToSegment(point, a, b);
          if (distSq < minSquaredDistance) {
            minSquaredDistance = distSq;
          }
        }

        squaredErrors.add(minSquaredDistance);
        totalSquaredError += minSquaredDistance;
      }

      allMeasurements.add(squaredErrors);

      double meanSquaredError = totalSquaredError / measurement.length;
      print("Mean Squared Error: $meanSquaredError");
    }

    print("All Measurements: $allMeasurements");
    print("Calculation Done");
    notifyListeners();
  }
  double _squaredXErrorAtY(Offset p, Offset a, Offset b) {
    if ((b.dy - a.dy).abs() < 1e-6) {
      // Avoid division by zero if segment is flat in time
      return (p.dx - a.dx) * (p.dx - a.dx);
    }

    // Linear interpolation: x = x0 + (y - y0) * (x1 - x0) / (y1 - y0)
    double t = ((p.dy - a.dy) / (b.dy - a.dy)).clamp(0.0, 1.0);
    double idealX = a.dx + t * (b.dx - a.dx);

    double error = p.dx - idealX;
    return error * error;
  }
  void calculateTrajectoryXError(){
    print("Calculation");

    if (optimalTrajectory.length < 2) {
      print("Optimal trajectory must have at least two points.");
      return;
    }

    allMeasurements.clear(); // Clear previous results

    for (final measurement in allTrajectoriesMeasurements) {
      List<double> squaredErrors = [];
      double totalSquaredError = 0.0;

      for (final point in measurement) {
        double minSquaredError = double.infinity;

        for (int i = 0; i < optimalTrajectory.length - 1; i++) {
          final Offset a = optimalTrajectory[i];
          final Offset b = optimalTrajectory[i + 1];

          // Check if point.y is in the y-range of the segment
          if ((point.dy >= a.dy && point.dy <= b.dy) ||
              (point.dy <= a.dy && point.dy >= b.dy)) {
            double errSq = _squaredXErrorAtY(point, a, b);
            if (errSq < minSquaredError) {
              minSquaredError = errSq;
            }
          }
        }

        // Fallback in case no segment matches — you can also skip or interpolate
        if (minSquaredError == double.infinity) {
          minSquaredError = 0.0;
        }

        squaredErrors.add(minSquaredError);
        totalSquaredError += minSquaredError;
      }


      allMeasurements.add(squaredErrors);

      double meanSquaredError = totalSquaredError / measurement.length;
      print("Mean Squared Error: $meanSquaredError");
    }

    print("All Measurements: $allMeasurements");
    print("Calculation Done");
    notifyListeners();
  }
  */

  /*
  void computeAndStorePerpendicularErrors() {
    //Adding up somehow
    if (allTrajectoriesMeasurements.isEmpty || optimalTrajectory.isEmpty) return;

    allMeasurements.clear();

    for (final measuredPoints in allTrajectoriesMeasurements) {
      final List<double> errors = [];

      for (final point in measuredPoints) {
        double minDistance = double.infinity;

        for (int i = 0; i < optimalTrajectory.length - 1; i++) {
          final p1 = optimalTrajectory[i];
          final p2 = optimalTrajectory[i + 1];
          //final distance = _perpendicularDistance(point, p1, p2);
          final distance = _perpendicularDistanceUsingAngle(point, p1, p2);
          if (distance < minDistance) {
            minDistance = distance;
          }
        }

        errors.add(minDistance);
      }

      allMeasurements.add(errors);
    }

  }
   */

  void computeAndStorePerpendicularErrors() {
    if (allTrajectoriesMeasurements.isEmpty || optimalTrajectory.isEmpty) return;

    allMeasurements.clear();

    for (final measuredPoints in allTrajectoriesMeasurements) {
      final List<double> errors = [];

      for (final point in measuredPoints) {
        double minDistance = double.infinity;
        double minDistanceCenterOfLine = double.infinity;

        for (int i = 0; i < optimalTrajectory.length - 1; i++) {
          final p1 = optimalTrajectory[i];
          final p2 = optimalTrajectory[i + 1];
          final distance = _perpendicularDistance(point, p1, p2);
          final pointToLineDistance =(point - Offset(
            (p1.dx + p2.dx) / 2,
            (p1.dy + p2.dy) / 2,
          )).distance;
          /*
          if (distance < minDistance) {
            minDistance = distance;
          }
          */
          if(pointToLineDistance < minDistanceCenterOfLine){
            minDistanceCenterOfLine = pointToLineDistance;
            minDistance = distance;
          }
        }

        // Store the minimum distance for this point
        errors.add(minDistance);
      }

      // Store the errors for this trajectory
      allMeasurements.add(errors);
    }

    exerciseResultError= calculateMeanError();

  }

  double calculateMeanError() {
    if (allMeasurements.isEmpty) return 0.0;

    double totalError = 0.0;
    int totalPoints = 0;

    for (final measurement in allMeasurements) {
      totalError += measurement.reduce((a, b) => a + b); // Sum of errors in the current measurement
      totalPoints += measurement.length; // Count of points in the current measurement
    }

    return totalPoints > 0 ? totalError / totalPoints : 0.0; // Overall mean error
  }

  double _perpendicularDistanceUsingAngle(Offset p, Offset a, Offset b) {

    final ab = b - a; // Vector from a to b
    final ap = p - a; // Vector from a to p

    final abLength = ab.distance; // Magnitude of ab
    final apLength = ap.distance; // Magnitude of ap

    if (abLength == 0.0) return apLength; // If a == b, return distance from p to a

    // Dot product of ab and ap
    final dotProduct = ab.dx * ap.dx + ab.dy * ap.dy;

    // Cosine of the angle between ab and ap
    final cosTheta = dotProduct / (abLength * apLength);

    // Sine of the angle using sin^2(theta) + cos^2(theta) = 1
    final sinTheta = sqrt(1 - cosTheta * cosTheta);

    final angleDif = acos(cosTheta);

    // Perpendicular distance
    //return apLength * sinTheta;
    return apLength * angleDif.abs();
  }

  double _perpendicularDistance(Offset p, Offset a, Offset b) {
    /*
    final ab = b - a;
    final ap = p - a;
    final abLengthSquared = ab.dx * ab.dx + ab.dy * ab.dy;

    if (abLengthSquared == 0.0) return (p - a).distance;

    double t = (ap.dx * ab.dx + ap.dy * ab.dy) / abLengthSquared;
    t = t.clamp(0.0, 1.0);
    final projection = Offset(a.dx + ab.dx * t, a.dy + ab.dy * t);

    return (p - projection).distance;
    */
    final ab = b - a;
    final ap = p - a;
    final abSquared = ab.dx * ab.dx + ab.dy * ab.dy;

    if (abSquared == 0.0) return (p - a).distance;

    final dotProduct = ap.dx * ab.dx + ap.dy * ab.dy;
    final t = dotProduct / abSquared;
    final clampedT = t.clamp(0.0, 1.0);

    final projection = Offset(
      a.dx + ab.dx * clampedT,
      a.dy + ab.dy * clampedT,
    );

    return (p - projection).distance;
  }

  String grading() {
    if (exerciseResultError < 45) {
      exerciseResultMark = "A";
    } else if (exerciseResultError < 60) {
      exerciseResultMark = "B";
    } else if (exerciseResultError < 70) {
      exerciseResultMark = "C";
    } else if (exerciseResultError < 85) {
      exerciseResultMark = "D";
    } else if (exerciseResultError < 110) {
      exerciseResultMark = "E";
    } else {
      exerciseResultMark = "F";
    }
    return exerciseResultMark;
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
    if(!initializeFlagDone) return;

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
    if(debuggingMode)finger1InRange= true;
    if(debuggingMode)finger2InRange= true;
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

    if(debuggingMode && ((finger1 - currentPosition).distance)<20)currentPosition=finger1;

    //Save the trajectory of the object
    exerciseBallModel.trajectoryOfObject.add(currentPosition);

    //Checking if the object is in the goal
    if((currentPosition - goalPosition).distance < distanceFromGoal && !goalReachedFlag) {
      goalReachedFlag = true;
      if(debuggingMode)print("Goal Reached");
      numberOfRepetitions++;
      checkExerciseProgress();
    }

    //

    notifyListeners();
  }
}
