enum SensorState { on, off }

class ImuSensorData {
  final double x;
  final double y;
  final double z;
  final DateTime timeStamp;
  final SensorState state;

  ImuSensorData({
    required this.x,
    required this.y,
    required this.z,
    required this.timeStamp,
    required this.state,
  });
}

class LuxSensorData {
  final double lux;
  final DateTime timeStamp;
  final SensorState state;

  LuxSensorData({
    required this.lux,
    required this.timeStamp,
    required this.state,
  });
}
