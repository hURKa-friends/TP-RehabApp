import 'package:rehab_app/models/finger_model.dart';
import 'package:rehab_app/models/displayTracking_model.dart';
import 'package:flutter/material.dart';
import 'package:rehab_app/view_models/exercise_ball_viewmodel.dart';

class DisplayTrackingViewModel extends ChangeNotifier {
  String msgDisplayTrackingViewModel = "";
  List<FingerModel> fingers = [];
  bool printMsgs = false;
  List<dynamic> fingersLog = [];
  List<dynamic> fingersLogRow = [];
  
  var displayTrackingModel;

  late ExerciseBallViewModel exerciseBallViewModel;

  ///Constructor
  DisplayTrackingViewModel({
    required numberOfFingers,
    required hand,
    required identification,
    required fingersBackAssignment,
    required offsetOfFinger,
    required displayOffset,
    //Parameters for the exercise ball
    required exerciseDone,
    required typeOfObject,
    required wightAndHeight,
    required initialPosition,
    required holeForTheBallPosition,
    required hardness,
    required showObject,
    required screenSizeData,
  }) {
    displayTrackingModel = DisplayTrackingModel(
      numberOfFingers: numberOfFingers,
      hand: hand,
      identification: identification,
      fingersBackAssignment: fingersBackAssignment,
      offsetOfFinger: offsetOfFinger,
      displayOffset: displayOffset,
    );
    exerciseBallViewModel = ExerciseBallViewModel(
      exerciseDone: exerciseDone,
      typeOfObject: typeOfObject, // Example: Ball type
      wightAndHeight: wightAndHeight, // Example: Ball size
      initialPosition: initialPosition,
      holeForTheBallPosition :holeForTheBallPosition,
      hardness :hardness,// Example: Initial position
      showObject: showObject,
      screenSize: screenSizeData, // Example: Screen size
    );

    // Initialize fingers
    fingers = List.generate(numberOfFingers, (index) {
      return FingerModel(
        fingerName: 'Finger${index + 1}',
        pointerFingerActive: false,
        pointerFinger: {},
        pointerFingerTrajectory: [],
      );
    });
  }


  /*
  List<Offset> getTrajectory(String name) {
    return fingers.firstWhere((f) => f.fingerName == name).pointerFingerTrajectory;
  }
  */

  void processDataStep(){
    //fingers[i].pointerFinger - key is and id of the pointer - value is starting position of the finger on new id
    //fingers[i].pointerFingerTrajectory - trajectory of the finger

    //Storing data
    //Row - name of finger - id - trajectory x,y,
    for(int i=0; i<displayTrackingModel.numberOfFingers; i++){
      //print("Finger ${fingers[i].fingerName}");
      for(int n=0; n<fingers[i].pointerFinger.keys.length; n++){
        fingersLogRow.add(fingers[i].fingerName);
        fingersLogRow.add(fingers[i].pointerFinger.keys.elementAt(n).toString());

        //Adding trajectory to row data
        //print("Logged data pointerFingerTrajectoryList: ${fingers[i].pointerFingerTrajectoryList.last}");
        for(int j=0; j<fingers[i].pointerFingerTrajectoryList.length; j++){
          for(int k=0; k<fingers[i].pointerFingerTrajectoryList[j].length; k++){
            if(fingers[i].pointerFingerTrajectoryList[j][k] != null){
              fingersLogRow.add(fingers[i].pointerFingerTrajectoryList[j][k].dx.toStringAsFixed(2));
              fingersLogRow.add(fingers[i].pointerFingerTrajectoryList[j][k].dy.toStringAsFixed(2));
              fingersLogRow.add(';');
            }
          }
        }

        fingersLog.add(fingersLogRow.toString());

        //print("\n\nLogged data Row: ${fingersLogRow}\n\n");
        fingersLogRow.clear();
      }
    }

    print("\n---Log---------------------------------------------------------------------------");
    for(int i=0; i<fingersLog.length; i++){
      print("Logged data: ${i} : ${fingersLog.elementAt(i)}");
    }

    //Deleting processed data
    for(int i=0; i<displayTrackingModel.numberOfFingers; i++){
      fingers[i].pointerFinger.clear();
      fingers[i].pointerFingerTrajectory.clear();
      fingers[i].pointerFingerTrajectoryList.clear();
    }
  }

  void processDataOfExercise(){
    //Fingers and they trajectories


    //Exercise ball


  }

  void onPointerDown(PointerEvent event) {
    ///Back assignment of the fingers
    if(displayTrackingModel.fingersBackAssignment){
      if(displayTrackingModel.fingersDetected){
        if(printMsgs)print("-----------------------------------------------");
        if(printMsgs)print("Back assignment of the fingers - start");
        for(int i=0; i<displayTrackingModel.numberOfFingers; i++){
          if(printMsgs)print("Finger ${fingers[i].fingerName} - ${fingers[i].pointerFingerActive}");
          if(fingers[i].pointerFingerActive == false && (event.position < fingers[i].pointerFingerTrajectory.last + displayTrackingModel.offsetOfFinger && event.position > fingers[i].pointerFingerTrajectory.last - displayTrackingModel.offsetOfFinger)){
            fingers[i].pointerFingerActive = true;
            fingers[i].pointerFinger[event.pointer] = event.position;
            fingers[i].pointerFingerTrajectory.add(event.position);
            if(printMsgs)print("Back assigned finger ${fingers[i].fingerName} to pointer ${event.pointer}");
            break;
          }
        }
      }
    }else{
      if(displayTrackingModel.fingersDetected){
        if(printMsgs)print("-----------------------------------------------");
        if(printMsgs)print("No back assignment of the fingers - start");
        for(int i=0; i<displayTrackingModel.numberOfFingers; i++){
          if(printMsgs)print("Finger ${fingers[i].fingerName} - ${fingers[i].pointerFingerActive}");
          if(fingers[i].pointerFingerActive == false){
            fingers[i].pointerFingerActive = true;
            fingers[i].pointerFinger[event.pointer] = event.position;
            fingers[i].pointerFingerTrajectory.add(event.position);
            if(printMsgs)print("Back assigned finger ${fingers[i].fingerName} to pointer ${event.pointer}");
            break;
          }
        }
      }
    }

    displayTrackingModel.activeFingers[event.pointer] = event.position;
    if(printMsgs)print(displayTrackingModel.activeFingers);

    ///Initial assignment of the fingers
    if(displayTrackingModel.identification){
      if(printMsgs)print("Identification of the fingers - start");
      ///Identification of the fingers with recognition
      if (displayTrackingModel.activeFingers.length == displayTrackingModel.numberOfFingers && !displayTrackingModel.fingersDetected) {
        if(printMsgs)print("All fingers are active");
        var sortedEntries = displayTrackingModel.activeFingers.entries.toList()..sort((MapEntry<int, Offset> a, MapEntry<int, Offset> b) => a.value.dy.compareTo(b.value.dy));

        if (displayTrackingModel.hand == "Right") {
          for (int i = 0; i < displayTrackingModel.numberOfFingers; i++) {
            fingers[i].pointerFingerActive = true;
            fingers[i].pointerFinger[sortedEntries[displayTrackingModel
                .numberOfFingers - i - 1].key] =
                sortedEntries[displayTrackingModel.numberOfFingers - i - 1]
                    .value;
            fingers[i].pointerFingerTrajectory.add(
                sortedEntries[displayTrackingModel.numberOfFingers - i - 1]
                    .value);
          }
          if(printMsgs)print("Right hand detected");
        } else if (displayTrackingModel.hand == "Left") {
          for (int i = 0; i < displayTrackingModel.numberOfFingers; i++) {
            fingers[i].pointerFingerActive = true;
            fingers[i].pointerFinger[sortedEntries[i].key] =
                sortedEntries[i].value;
            fingers[i].pointerFingerTrajectory.add(sortedEntries[i].value);
          }
          if(printMsgs)print("Left hand detected");
        } else {
          if(printMsgs)print("ERROR in hand detection");
        }
        displayTrackingModel.fingersDetected = true;
        if(printMsgs)print("Fingers detected with identification");
      }//Detection of the fingers
    }else{
      ///Without identification of the fingers
      if(displayTrackingModel.activeFingers.length == displayTrackingModel.numberOfFingers  && !displayTrackingModel.fingersDetected){
        //Assignment of the fingers
        var entries = displayTrackingModel.activeFingers.entries.toList();//convert to list

        for(int i=0; i<displayTrackingModel.numberOfFingers; i++){
          if(displayTrackingModel.activeFingers.length == displayTrackingModel.numberOfFingers){
            fingers[i].pointerFingerActive = true;
            fingers[i].pointerFinger[entries[i].key] = entries[i].value;
            fingers[i].pointerFingerTrajectory.add(entries[i].value);
          }
        }
        displayTrackingModel.fingersDetected = true;
        if(printMsgs)print("Fingers detected without identification");
      }
    }


    notifyListeners();
  }//onPointerDown END

  void onPointerMove(PointerEvent event) {
    for(int i=0; i<displayTrackingModel.numberOfFingers; i++){
      if(fingers[i].pointerFinger.containsKey(event.pointer)){
        fingers[i].pointerFingerTrajectory.add(event.position);
      }
    }

    //Update the position of the exercise ball
    if(displayTrackingModel.activeFingers.length == displayTrackingModel.numberOfFingers){
      exerciseBallViewModel.setPosition(fingers[0].pointerFingerTrajectory.last, fingers[1].pointerFingerTrajectory.last);
    }

    notifyListeners();
  }//onPointerMove END

  void onPointerUp(PointerEvent event) {
    ///Unassignment of the fingers
    for(int i=0; i<displayTrackingModel.numberOfFingers; i++){
      if(fingers[i].pointerFinger.containsKey(event.pointer)){
        fingers[i].pointerFingerActive = false;

        ///Delete a trajectory and save it
        fingers[i].pointerFingerTrajectory.removeAt(0); //Delete a fist point
        fingers[i].pointerFingerTrajectoryList.add(fingers[i].pointerFingerTrajectory.toList());
        fingers[i].pointerFingerTrajectory.clear();
        //print("When unassigned Added trajectory ${fingers[i].pointerFingerTrajectoryList.last}");
        ///

        fingers[i].pointerFingerTrajectory.add(event.position); //Last position of the finger

        if(printMsgs)print("Unassigned finger ${fingers[i].fingerName} of pointer ${event.pointer}");
      }
    }

    //[/][/][/][/][/][/][/][/][/][/][/][/][/][/][/][/][/][/][/][/][/][/][/][/][/] Delete - for testing purposes on Chrome
    //Deletes the finger that were used and assigned in detection - because for testing purposes they wont be on the screen
    if(displayTrackingModel.activeFingers.length == displayTrackingModel.numberOfFingers){
      //Reset detection and other stuff
      displayTrackingModel.activeFingers.clear();
      for (int i=0; i<displayTrackingModel.numberOfFingers; i++) {
        fingers[i].pointerFingerActive = false;
      }
      //displayTrackingModel.fingersDetected=false;
    }
    //[/][/][/][/][/][/][/][/][/][/][/][/][/][/][/][/][/][/][/][/][/][/][/][/][/] For testing purposes on Chrome

    //Remove the finger from the active fingers
    if(displayTrackingModel.fingersDetected){
      displayTrackingModel.activeFingers.remove(event.pointer);
    }

    ///Testing
    processDataStep();

    notifyListeners();
  }//onPointerUp END

}
