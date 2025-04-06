import 'package:rehab_app/models/finger_model.dart';
import 'package:flutter/material.dart';

class DisplayTrackingViewModel extends ChangeNotifier {
  late FingerModel fingerModel;
  late Offset offsetOfFinger;
  late Offset displayOffset;

  var fingerModel1 = FingerModel(
    fingerName: "Index",
    pointerFingerActive: false,
    pointerFinger: {},
    pointerFingerTrajectory: [],
  );


  /*
  DisplayTrackingViewModel({
    required this.fingerModel,
    required this.offsetOfFinger,
    required this.displayOffset,
  }) {
    fingerModel.initializeTrajectories();
  }
  */

  /*
  void _onPointerDown(PointerEvent event) {
    ///For pointer down sorts the pointer to which finger - for now they go by the order from index finger to pinky finger
    // Index finger
    if (fingerModel.fingerDetected && (!fingerModel.pointerIndexActive && (event.position < fingerModel.pointerIndexTrajectory.last + offsetOfFinger && event.position > fingerModel.pointerIndexTrajectory.last - offsetOfFinger))) {
      fingerModel.pointerIndexActive = true;
      fingerModel.pointerIndex[event.pointer] = event.position;
      fingerModel.pointerIndexTrajectory.add(event.position);
      print("Index Down/Activated");
    }
    // Middle finger
    else if (fingerModel.fingerDetected && (!fingerModel.pointerMiddleActive && (event.position < fingerModel.pointerMiddleTrajectory.last + offsetOfFinger && event.position > fingerModel.pointerMiddleTrajectory.last - offsetOfFinger))) {
      fingerModel.pointerMiddleActive = true;
      fingerModel.pointerMiddle[event.pointer] = event.position;
      fingerModel.pointerMiddleTrajectory.add(event.position);
      print("Middle Down/Activated");
    }
    // Ring finger
    else if (fingerModel.fingerDetected && (!fingerModel.pointerRingActive && (event.position < fingerModel.pointerRingTrajectory.last + offsetOfFinger && event.position > fingerModel.pointerRingTrajectory.last - offsetOfFinger))) {
      fingerModel.pointerRingActive = true;
      fingerModel.pointerRing[event.pointer] = event.position;
      fingerModel.pointerRingTrajectory.add(event.position);
      print("Ring Down/Activated");
    }
    // Pinky finger
    else if (fingerModel.fingerDetected && (!fingerModel.pointerPinkyActive && (event.position < fingerModel.pointerPinkyTrajectory.last + offsetOfFinger && event.position > fingerModel.pointerPinkyTrajectory.last - offsetOfFinger))) {
      fingerModel.pointerPinkyActive = true;
      fingerModel.pointerPinky[event.pointer] = event.position;
      fingerModel.pointerPinkyTrajectory.add(event.position);
      print("Pinky Down/Activated");
    } else {
      print("No finger detected");
    }

    fingerModel.activeFingers[event.pointer] = event.position;

    // Detection
    if (fingerModel.activeFingers.length == fingerModel.numberOfFingers &&
        !fingerModel.fingerDetected) {
      print("All fingers are active");
      var sortedEntries = fingerModel.activeFingers.entries.toList()
        ..sort((a, b) => a.value.dy.compareTo(b.value.dy));

      if (fingerModel.hand == "Right") {
        // Index finger
        fingerModel.pointerIndexActive = true;
        fingerModel.pointerIndex[sortedEntries[3].key] = sortedEntries[3].value;
        fingerModel.pointerIndexTrajectory.add(sortedEntries[3].value);
        // Middle finger
        fingerModel.pointerMiddleActive = true;
        fingerModel.pointerMiddle[sortedEntries[2].key] = sortedEntries[2].value;
        fingerModel.pointerMiddleTrajectory.add(sortedEntries[2].value);
        // Ring finger
        fingerModel.pointerRingActive = true;
        fingerModel.pointerRing[sortedEntries[1].key] = sortedEntries[1].value;
        fingerModel.pointerRingTrajectory.add(sortedEntries[1].value);
        // Pinky finger
        fingerModel.pointerPinkyActive = true;
        fingerModel.pointerPinky[sortedEntries[0].key] = sortedEntries[0].value;
        fingerModel.pointerPinkyTrajectory.add(sortedEntries[0].value);
      } else if (fingerModel.hand == "Left") {
        // Index finger
        fingerModel.pointerIndexActive = true;
        fingerModel.pointerIndex[sortedEntries[0].key] = sortedEntries[0].value;
        fingerModel.pointerIndexTrajectory.add(sortedEntries[0].value);
        // Middle finger
        fingerModel.pointerMiddleActive = true;
        fingerModel.pointerMiddle[sortedEntries[1].key] = sortedEntries[1].value;
        fingerModel.pointerMiddleTrajectory.add(sortedEntries[1].value);
        // Ring finger
        fingerModel.pointerRingActive = true;
        fingerModel.pointerRing[sortedEntries[2].key] = sortedEntries[2].value;
        fingerModel.pointerRingTrajectory.add(sortedEntries[2].value);
        // Pinky finger
        fingerModel.pointerPinkyActive = true;
        fingerModel.pointerPinky[sortedEntries[3].key] = sortedEntries[3].value;
        fingerModel.pointerPinkyTrajectory.add(sortedEntries[3].value);
      } else {
        print("ERROR in hand detection");
      }

      fingerModel.fingerDetected = true;
    }

    notifyListeners();

  }

  void _onPointerMove(PointerEvent event) {
    //1
    if(fingerModel.pointerIndex.containsKey(event.pointer)){
      fingerModel.pointerIndexTrajectory.add(event.position);
    }
    //2
    else if(fingerModel.pointerMiddle.containsKey(event.pointer)){
      fingerModel.pointerMiddleTrajectory.add(event.position);
    }
    //3
    else if(fingerModel.pointerRing.containsKey(event.pointer)){
      fingerModel.pointerRingTrajectory.add(event.position);
    }
    //4
    else if(fingerModel.pointerPinky.containsKey(event.pointer)){
      fingerModel.pointerPinkyTrajectory.add(event.position);
    }

    fingerModel.activeFingers[event.pointer] = event.position;
    //pointerPaths[event.pointer]?.add(event.position);
    notifyListeners();
  }

  void _onPointerUp(PointerEvent event) {
    //1
    if(fingerModel.pointerIndex.containsKey(event.pointer)){
      fingerModel.pointerIndexActive = false;
      fingerModel.pointerIndexTrajectory.add(event.position);
      print("Index Up/Deactivated");
    }
    //2
    else if(fingerModel.pointerMiddle.containsKey(event.pointer)){
      fingerModel.pointerMiddleActive = false;
      fingerModel.pointerMiddleTrajectory.add(event.position);
      print("Middle Up/Deactivated");
    }
    //3
    else if(fingerModel.pointerRing.containsKey(event.pointer)){
      fingerModel.pointerRingActive = false;
      fingerModel.pointerRingTrajectory.add(event.position);
      print("Ring Up/Deactivated");
    }
    //4
    else if(fingerModel.pointerPinky.containsKey(event.pointer)){
      fingerModel.pointerPinkyActive = false;
      fingerModel.pointerPinkyTrajectory.add(event.position);
      print("Pinky Up/Deactivated");
    }

    //Delete - for testing purposes on Chrome
    if(fingerModel.activeFingers.length == 4){
      //Reset detection and other stuff
      fingerModel.activeFingers.clear();
      fingerModel.pointerIndexActive=false;
      fingerModel.pointerMiddleActive=false;
      fingerModel.pointerRingActive=false;
      fingerModel.pointerPinkyActive=false;
      //fingerDetected=false;
    }
    //activeFingers.remove(event.pointer);
    if(fingerModel.fingerDetected){
      fingerModel.activeFingers.remove(event.pointer);
    }

    if(fingerModel.activeFingers.length == 0){
      //Reset detection and other stuff
      //fingerDetected=false;
    }
    notifyListeners();
  }
   */

}
