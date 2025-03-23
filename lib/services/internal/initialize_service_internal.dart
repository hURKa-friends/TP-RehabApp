import 'package:rehab_app/services/models/init_models.dart';
import 'package:sensor_manager_android/sensor_manager_android.dart';
import 'package:sensor_manager_android/sensor.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitResourcesServiceInternal {
  bool? isDynamicSensorDiscoverySupported;
  bool? _isMultiTouchSupp;
  late CameraDetails _camera;
  late SensorAvailability sensors;

  initialize() async {
    isDynamicSensorDiscoverySupported = await SensorManagerAndroid.instance.isDynamicSensorDiscoverySupported();

    _isMultiTouchSupp = await _isMultiTouchSupported();

    sensors = SensorAvailability();
    _camera = CameraDetails();

    _isAccelerometerAvailable();
    _isGyroscopeAvailable();
    _isMagnetometerAvailable();
    _isLightSensorAvailable();

    _checkCameraStatus();
  }

  Future<bool> _isMultiTouchSupported() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.systemFeatures.contains('android.hardware.touchscreen.multitouch.distinct');
  }

  Future<void> _initializeCamera() async {
    // Request permission before initializing the camera
    PermissionStatus status = await Permission.camera.request();
    if (status.isGranted) {
      // Proceed with camera initialization (e.g., availableCameras())
      List<CameraDescription> cameras = await availableCameras();
      CameraController controller = CameraController(cameras[0], ResolutionPreset.high);
      await controller.initialize();
    } else {
      // Handle permission denial (e.g., show a dialog or redirect to settings)
      print('Camera permission denied');
    }
  }

  Future<void> _checkCameraStatus() async {

    _initializeCamera();

    List<CameraDescription> cameras = await availableCameras();

    bool isPartOfDev = cameras.any((camera) => camera.lensDirection == CameraLensDirection.front);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var status = await Permission.camera.status;

    if ((isPartOfDev) && status.isGranted) {
      CameraDescription? frontCamera = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front,);
      await prefs.setBool('camera_permission', true);
      _camera.cameraInfo[frontCamera] = status.isGranted;
    } else {
      CameraDescription? frontCamera;
      _camera.cameraInfo[frontCamera] = false;
      await prefs.setBool('camera_permission', false);
    }
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

  bool? multiTouchSupport() {
    return _isMultiTouchSupp;
  }

  Map<CameraDescription?, bool> camInfo() {

    if (_camera.cameraInfo.isNotEmpty) {

      CameraDescription? camera = _camera.cameraInfo.keys.firstWhere(
            (camera) => camera?.lensDirection == CameraLensDirection.front,
        orElse: () => null,
      );

      if (camera != null) {
        return _camera.cameraInfo;
      } else {
        throw Exception('Front camera not found on device!');
      }
    } else {
      throw Exception('No camera information available!');
    }
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

