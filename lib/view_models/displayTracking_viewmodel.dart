import 'package:rehab_app/models/finger_model.dart';
import 'package:rehab_app/models/displayTracking_model.dart';
import 'package:flutter/material.dart';

class DisplayTrackingViewModel extends ChangeNotifier {
  String msgDisplayTrackingViewModel = "";
  List<FingerModel> fingers = [];

  var displayTrackingModel;

  ///Constructor
  DisplayTrackingViewModel({
    required numberOfFingers,
    required hand,
    required identification,
    required fingersBackAssignment,
    required offsetOfFinger,
    required displayOffset,
  }) {
    displayTrackingModel = DisplayTrackingModel(
      numberOfFingers: numberOfFingers,
      hand: hand,
      identification: identification,
      fingersBackAssignment: fingersBackAssignment,
      offsetOfFinger: offsetOfFinger,
      displayOffset: displayOffset,
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

  List<Offset> getTrajectory(String name) {
    return fingers.firstWhere((f) => f.fingerName == name).pointerFingerTrajectory;
  }

  void onPointerDown(PointerEvent event) {
    ///Back assignment of the fingers
    if(displayTrackingModel.fingersBackAssignment){
      if(displayTrackingModel.fingersDetected){
        print("-----------------------------------------------");
        print("Back assignment of the fingers - start");
        for(int i=0; i<displayTrackingModel.numberOfFingers; i++){
          print("Finger ${fingers[i].fingerName} - ${fingers[i].pointerFingerActive}");
          if(fingers[i].pointerFingerActive == false && (event.position < fingers[i].pointerFingerTrajectory.last + displayTrackingModel.offsetOfFinger && event.position > fingers[i].pointerFingerTrajectory.last - displayTrackingModel.offsetOfFinger)){
            fingers[i].pointerFingerActive = true;
            fingers[i].pointerFinger[event.pointer] = event.position;
            fingers[i].pointerFingerTrajectory.add(event.position);
            print("Back assigned finger ${fingers[i].fingerName} to pointer ${event.pointer}");
            break;
          }
        }
      }
    }else{
      if(displayTrackingModel.fingersDetected){
        print("-----------------------------------------------");
        print("No back assignment of the fingers - start");
        for(int i=0; i<displayTrackingModel.numberOfFingers; i++){
          print("Finger ${fingers[i].fingerName} - ${fingers[i].pointerFingerActive}");
          if(fingers[i].pointerFingerActive == false){
            fingers[i].pointerFingerActive = true;
            fingers[i].pointerFinger[event.pointer] = event.position;
            fingers[i].pointerFingerTrajectory.add(event.position);
            print("Back assigned finger ${fingers[i].fingerName} to pointer ${event.pointer}");
            break;
          }
        }
      }
    }

    displayTrackingModel.activeFingers[event.pointer] = event.position;
    print(displayTrackingModel.activeFingers);

    ///Initial assignment of the fingers
    if(displayTrackingModel.identification){
      print("Identification of the fingers - start");
      ///Identification of the fingers with recognition
      if (displayTrackingModel.activeFingers.length == displayTrackingModel.numberOfFingers && !displayTrackingModel.fingersDetected) {
        print("All fingers are active");
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
          print("Right hand detected");
        } else if (displayTrackingModel.hand == "Left") {
          for (int i = 0; i < displayTrackingModel.numberOfFingers; i++) {
            fingers[i].pointerFingerActive = true;
            fingers[i].pointerFinger[sortedEntries[i].key] =
                sortedEntries[i].value;
            fingers[i].pointerFingerTrajectory.add(sortedEntries[i].value);
          }
          print("Left hand detected");
        } else {
          print("ERROR in hand detection");
        }
        displayTrackingModel.fingersDetected = true;
        print("Fingers detected with identification");
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
        print("Fingers detected without identification");
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

    notifyListeners();
  }//onPointerMove END

  void onPointerUp(PointerEvent event) {
    ///Unassignment of the fingers
    for(int i=0; i<displayTrackingModel.numberOfFingers; i++){
      if(fingers[i].pointerFinger.containsKey(event.pointer)){
        fingers[i].pointerFingerActive = false;
        fingers[i].pointerFingerTrajectory.add(event.position);
        print("Unassigned finger ${fingers[i].fingerName} of pointer ${event.pointer}");
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

    notifyListeners();
  }//onPointerUp END

}
