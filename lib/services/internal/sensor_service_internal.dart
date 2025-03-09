import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:rehab_app/services/models/sensor_models.dart';

class SensorServiceInternal {
  late ImuSensorData acclData;
  late StreamSubscription<ImuSensorData> acclSubscription;
  late StreamSubscription<AccelerometerEvent> _acclEventSubscription;
  late StreamController<ImuSensorData> _acclStreamController;

  late ImuSensorData gyroData;
  late StreamSubscription<ImuSensorData> gyroSubscription;

  late ImuSensorData magData;
  late StreamSubscription<ImuSensorData> magSubscription;

  late LuxSensorData luxData;
  late StreamSubscription<LuxSensorData> luxSubscription;

  initialize() async {

  }

  bool initializeAcclStream (Duration samplingPeriod) {
    if(samplingPeriod.inMilliseconds < 2.5 || samplingPeriod.inMilliseconds > 200) {
      return false;
    }
    _acclEventSubscription = accelerometerEventStream(samplingPeriod: samplingPeriod).listen((event) {
      acclData = ImuSensorData(x:event.x, y:event.y, z:event.z, timeStamp: DateTime.now(), state: SensorState.on);
      _acclStreamController.add(acclData);
    });
    return true;
  }

  bool registerAcclStream (Duration samplingPeriod, Function() callback) {
    if(samplingPeriod.inMilliseconds < 2.5 || samplingPeriod.inMilliseconds > 200) {
      return false;
    }
    acclSubscription = _acclStreamController.stream.listen((data) {
      callback();
    });
    return true;
  }

  bool cancelAcclStream () {
    try {
      acclData = ImuSensorData(x: acclData.x, y: acclData.y, z:acclData.z, timeStamp: DateTime.now(), state: SensorState.off);
      acclSubscription.cancel();
      _acclEventSubscription.cancel();
      return true;
    } catch (e) {
      return false;
    }
  }

  bool isOnAccl() {
    return acclData.state == SensorState.on;
  }
  bool isOnGyro() {
    return gyroData.state == SensorState.on;
  }
  bool isOnMag() {
    return magData.state == SensorState.on;
  }
  bool isOnLux() {
    return luxData.state == SensorState.on;
  }

}