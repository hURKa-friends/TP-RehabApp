import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:light_sensor/light_sensor.dart';
import 'package:rehab_app/models/sensor_models.dart';

class SensorServiceInternal {
  late ImuSensorData acclData;
  late StreamSubscription<ImuSensorData> acclSubscription;
  late StreamSubscription<AccelerometerEvent> _acclEventSubscription;
  late StreamController<ImuSensorData> _acclStreamController;

  late ImuSensorData gyroData;
  late StreamSubscription<ImuSensorData> gyroSubscription;
  late StreamSubscription<GyroscopeEvent> _gyroEventSubscription;
  late StreamController<ImuSensorData> _gyroStreamController;

  late ImuSensorData magData;
  late StreamSubscription<ImuSensorData> magSubscription;
  late StreamSubscription<MagnetometerEvent> _magEventSubscription;
  late StreamController<ImuSensorData> _magStreamController;

  late LuxSensorData luxData;
  late StreamSubscription<LuxSensorData> luxSubscription;
  bool hasLightSensor = false;
  late StreamSubscription<int> _luxEventSubscription;
  late StreamController<LuxSensorData> _luxStreamController;

  initialize() async {

  }

  bool initializeAcclStream (Duration samplingPeriod) {
    if(samplingPeriod.inMilliseconds < 2 || samplingPeriod.inMilliseconds > 200) {
      return false;
    }
    _acclStreamController = StreamController();
    _acclEventSubscription = accelerometerEventStream(samplingPeriod: samplingPeriod).listen((event) {
      acclData = ImuSensorData(x:event.x, y:event.y, z:event.z, timeStamp: DateTime.now(), state: SensorState.on);
      _acclStreamController.add(acclData);
    });
    return true;
  }

  bool initializeGyroStream (Duration samplingPeriod) {
    if(samplingPeriod.inMilliseconds < 2 || samplingPeriod.inMilliseconds > 200) {
      return false;
    }
    _gyroStreamController = StreamController();
    _gyroEventSubscription = gyroscopeEventStream(samplingPeriod: samplingPeriod).listen((event) {
      gyroData = ImuSensorData(x:event.x, y:event.y, z:event.z, timeStamp: DateTime.now(), state: SensorState.on);
      _gyroStreamController.add(gyroData);
    });
    return true;
  }

  bool initializeMagStream (Duration samplingPeriod) {
    if(samplingPeriod.inMilliseconds < 2 || samplingPeriod.inMilliseconds > 200) {
      return false;
    }
    _magStreamController = StreamController();
    _magEventSubscription = magnetometerEventStream(samplingPeriod: samplingPeriod).listen((event) {
      magData = ImuSensorData(x:event.x, y:event.y, z:event.z, timeStamp: DateTime.now(), state: SensorState.on);
      _magStreamController.add(magData);
    });
    return true;
  }

  bool initializeLuxStream () {
    try {
      _luxStreamController = StreamController();
      _luxEventSubscription = LightSensor.luxStream().listen((lux) {
        luxData = LuxSensorData(lux: lux, timeStamp: DateTime.now(), state: SensorState.on);
        _luxStreamController.add(luxData);
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  bool registerAcclStream (Function() callback) {
    acclSubscription = _acclStreamController.stream.listen((data) {
      callback();
    });
    return true;
  }

  bool registerGyroStream (Function() callback) {
    gyroSubscription = _gyroStreamController.stream.listen((data) {
      callback();
    });
    return true;
  }

  bool registerMagStream (Function() callback) {
    acclSubscription = _magStreamController.stream.listen((data) {
      callback();
    });
    return true;
  }

  bool registerLuxStream (Function() callback) {
    try {
      luxSubscription = _luxStreamController.stream.listen((data) {
        callback();
      });
    return true;
    } catch (e) {
      return false;
    }
  }

  bool cancelAcclStream () {
    try {
      acclSubscription.cancel();
      _acclEventSubscription.cancel();
      acclData = ImuSensorData(x:0, y:0, z:0, timeStamp: DateTime.now(), state: SensorState.off);
      return true;
    } catch (e) {
      return false;
    }
  }

  bool cancelGyroStream () {
    try {
      gyroSubscription.cancel();
      _gyroEventSubscription.cancel();
      gyroData = ImuSensorData(x:0, y:0, z:0, timeStamp: DateTime.now(), state: SensorState.off);
      return true;
    } catch (e) {
      return false;
    }
  }

  bool cancelMagStream () {
    try {
      magSubscription.cancel();
      _magEventSubscription.cancel();
      magData = ImuSensorData(x:0, y:0, z:0, timeStamp: DateTime.now(), state: SensorState.off);
      return true;
    } catch (e) {
      return false;
    }
  }

  bool cancelLuxStream () {
    try {
      luxSubscription.cancel();
      _luxEventSubscription.cancel();
      luxData = LuxSensorData(lux: 0, timeStamp: DateTime.now(), state: SensorState.off);
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