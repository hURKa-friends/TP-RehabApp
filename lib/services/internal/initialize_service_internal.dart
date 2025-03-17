import 'package:rehab_app/services/models/init_models.dart';
import 'package:sensor_manager_android/sensor_manager_android.dart';
import 'package:sensor_manager_android/sensor.dart';
import 'package:rehab_app/services/models/sensor_models.dart';

class InitResourcesServiceInternal {
  bool? isDynamicSensorDiscoverySupported;
  late SensorAvailability sensors;

  initialize() async {
    isDynamicSensorDiscoverySupported = await SensorManagerAndroid.instance.isDynamicSensorDiscoverySupported();

    print("Dynamic Sensor Discovery Supported: $isDynamicSensorDiscoverySupported");

    sensors = SensorAvailability();

    _isAccelerometerAvailable();
    _isGyroscopeAvailable();
    _isMagnetometerAvailable();
    _isLightSensorAvailable();
  }

  void _isAccelerometerAvailable() async {
    Sensor accel = _dummySensor(Sensor.typeAccelerometer, "Accelerometer");

    if (isDynamicSensorDiscoverySupported == true) {
      final sensor = await SensorManagerAndroid.instance.getDefaultSensor(Sensor.typeAccelerometer);

      if (sensor != null) {
        double? samplingRate = _getSensorSamplingRate(sensor);
        double resolution = sensor.resolution;

        sensors.sensorMap[sensor] = SensorInfo(
          availability: SensorAvailEnum.present,
          samplingRate: samplingRate,
          resolution: resolution,
        );
        return;
      } else {
        sensors.sensorMap[accel] = SensorInfo(
          availability: SensorAvailEnum.notAvail,
          samplingRate: null,
          resolution: null,
        );
      }
    } else {
      sensors.sensorMap[accel] = SensorInfo(
        availability: SensorAvailEnum.unknown,
        samplingRate: null,
        resolution: null,
      );
    }
  }

  void _isGyroscopeAvailable() async {
    Sensor accel = _dummySensor(Sensor.typeGyroscope, "Gyroscope");

    if (isDynamicSensorDiscoverySupported == true) {
      final sensor = await SensorManagerAndroid.instance.getDefaultSensor(Sensor.typeGyroscope);

      if (sensor != null) {
        double? samplingRate = _getSensorSamplingRate(sensor);
        double resolution = sensor.resolution;

        sensors.sensorMap[sensor] = SensorInfo(
          availability: SensorAvailEnum.present,
          samplingRate: samplingRate,
          resolution: resolution,
        );
        return;
      } else {
          sensors.sensorMap[accel] = SensorInfo(
            availability: SensorAvailEnum.notAvail,
            samplingRate: null,
            resolution: null,
          );
      }
    } else {
        sensors.sensorMap[accel] = SensorInfo(
          availability: SensorAvailEnum.unknown,
          samplingRate: null,
          resolution: null,
        );
    }
  }

  void _isMagnetometerAvailable() async {
    Sensor accel = _dummySensor(Sensor.typeMagneticField, "Magnetometer");

    if (isDynamicSensorDiscoverySupported == true) {
      final sensor = await SensorManagerAndroid.instance.getDefaultSensor(Sensor.typeMagneticField);

      if (sensor != null) {
        double? samplingRate = _getSensorSamplingRate(sensor);
        double resolution = sensor.resolution;

        sensors.sensorMap[sensor] = SensorInfo(
          availability: SensorAvailEnum.present,
          samplingRate: samplingRate,
          resolution: resolution,
        );
        return;
      } else {
          sensors.sensorMap[accel] = SensorInfo(
            availability: SensorAvailEnum.notAvail,
            samplingRate: null,
            resolution: null,
          );
      }
    } else {
        sensors.sensorMap[accel] = SensorInfo(
          availability: SensorAvailEnum.unknown,
          samplingRate: null,
          resolution: null,
        );
    }
  }

  void _isLightSensorAvailable() async {
    Sensor accel = _dummySensor(Sensor.typeLight, "LightSensor");

    if (isDynamicSensorDiscoverySupported == true) {
      final sensor = await SensorManagerAndroid.instance.getDefaultSensor(Sensor.typeLight);

      if (sensor != null) {
        double? samplingRate = _getSensorSamplingRate(sensor);
        double resolution = sensor.resolution;

        sensors.sensorMap[sensor] = SensorInfo(
          availability: SensorAvailEnum.present,
          samplingRate: samplingRate,
          resolution: resolution,
        );
        return;
      } else {
          sensors.sensorMap[accel] = SensorInfo(
            availability: SensorAvailEnum.notAvail,
            samplingRate: null,
            resolution: null,
          );
      }
    } else {
        sensors.sensorMap[accel] = SensorInfo(
          availability: SensorAvailEnum.unknown,
          samplingRate: null,
          resolution: null,
        );
    }
  }

  SensorInfo? accelData() {
    Sensor accelSensor = sensors.sensorMap.keys.firstWhere((sensor) => sensor.type == Sensor.typeAccelerometer,
        orElse: () => throw Exception('Accelerometer not found!'));
    return sensors.sensorMap[accelSensor];
  }
  SensorInfo? gyroData() {
    Sensor accelSensor = sensors.sensorMap.keys.firstWhere((sensor) => sensor.type == Sensor.typeGyroscope,
        orElse: () => throw Exception('Gyroscope not found!'));
    return sensors.sensorMap[accelSensor];
  }
  SensorInfo? magnetoData() {
    Sensor accelSensor = sensors.sensorMap.keys.firstWhere((sensor) => sensor.type == Sensor.typeMagneticField,
        orElse: () => throw Exception('Gyroscope not found!'));
    return sensors.sensorMap[accelSensor];
  }
  SensorInfo? lightData() {
    Sensor accelSensor = sensors.sensorMap.keys.firstWhere((sensor) => sensor.type == Sensor.typeLight,
        orElse: () => throw Exception('Gyroscope not found!'));
    return sensors.sensorMap[accelSensor];
  }
}

double? _getSensorSamplingRate(Sensor sensor) {
  if (sensor.minDelay > 0) {
    return 1000000 / sensor.minDelay;
  }
  return null;
}

Sensor _dummySensor(int sensorType, String sensorName) {
  // Create and return a dummy sensor
  return Sensor(
    name: sensorName,
    vendor: "Unknown Vendor",
    version: 1,
    type: sensorType,
    maxRange: 10.0,
    resolution: 0.1,
    power: 0.5,
    minDelay: 200,
  );
}