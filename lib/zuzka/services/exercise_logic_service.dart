import 'package:rehab_app/models/sensor_models.dart';

class ExerciseLogicService {
  /// Detekuje vstávanie zo stoličky na základe zložky akcelerácie Z.
  static bool evaluateChair(List<ImuSensorData> data) {
    if (data.length < 2) return false;

    const double threshold = 45.0; // cm/s (orientačne)
    double sumZ = 0;

    for (var i = 1; i < data.length; i++) {
      double deltaT = data[i].timeStamp.difference(data[i - 1].timeStamp).inMilliseconds / 1000;
      sumZ += (data[i].z + data[i - 1].z) / 2 * deltaT;
    }

    return sumZ.abs() > threshold;
  }

  /// Detekuje pohyb pri vstávaní z postele na základe integrácie zmeny uhla.
  static bool evaluateBed(List<ImuSensorData> data) {
    if (data.length < 2) return false;

    const double angleThreshold = 90.0; // stupne
    double theta = 0;

    for (var i = 1; i < data.length; i++) {
      double dt = data[i].timeStamp.difference(data[i - 1].timeStamp).inMilliseconds / 1000;
      double mag = ((data[i].x).abs() + (data[i].z).abs()) / 2;
      theta += mag * dt; // jednoduchý model uhlu
    }

    return theta > angleThreshold;
  }

  /// Detekuje opakované drepov.
  static bool evaluateSquat(List<ImuSensorData> data) {
    if (data.length < 3) return false;
    const double zThreshold = 2.0;
    int peaks = 0;
    for (int i = 1; i < data.length - 1; i++) {
      if (data[i].z < -zThreshold &&
          data[i - 1].z > data[i].z &&
          data[i + 1].z > data[i].z) {
        peaks++;
      }
    }
    return peaks >= 2;
  }
}