import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:rehab_app/services/internal/logger_service_internal.dart';
import '../../models/pose_detection/pose_detection_model.dart';
import '../../services/external/logger_service.dart';

// enum LogChannel { csv, error, event, plain }
// enum ChannelAccess { public, protected, private }

class PoseDetectionViewModel extends ChangeNotifier{
  // Fields
  late List<CameraDescription> _cameras;
  late CameraDescription _frontCamera;
  late CameraController cameraController;
  late PoseDetector _poseDetector;
  late ExerciseType _exerciseType;
  late ShoulderExercise exercise;
  CustomPaint? customPaint;
  late String? UOID;

  bool _isBusy = false;
  late bool mounted = false;
  bool _canProcess = true;

  int repetitions = 0;
  double currentAngleShoulder = 0;

  // Constructor
  PoseDetectionViewModel() {
    _initialize();
  }

  Future<void> _initialize() async {
    await _asyncInitCamera();
    _initPoseDetector();
    ChannelAccess channelAccess = ChannelAccess.private;
    UOID = await LoggerService().openCsvLogChannel(access: channelAccess, fileName: 'testFile', headerData: 'HeaderData1, HeaderData2, HeaderData3');
    notifyListeners(); // Ensure UI rebuilds when camera is initialized
  }

  @override // Deconstructor
  void dispose() {
    print('Disposing PoseDetectionViewModel...');
    _canProcess = false;
    _poseDetector.close();
    if (cameraController.value.isInitialized) {
      cameraController.stopImageStream();
      cameraController.dispose();
    }
    super.dispose();
  }

  Future<void> onInit() async {
    ChannelAccess channelAccess = ChannelAccess.private;
    // UOID = await LoggerService().openCsvLogChannel(access: channelAccess, fileName: 'testFile', headerData: 'HeaderData1, HeaderData2, HeaderData3');
  }

  void onClose() {
    LoggerService().closeLogChannelSafely(ownerId: UOID!, channel: LogChannel.csv);
  }

  // void onDataChanged() {
  //   bool wasSuccessful = LoggerService().log(channel: LogChannel.csv, ownerId: UOID!, data: 'Dataaaaa');
  // }

  void _initPoseDetector() {
    _poseDetector = PoseDetector(options: PoseDetectorOptions());
  }

  Future<void> _asyncInitCamera() async {
    _cameras = await availableCameras();
    /// setup front camera only
    _frontCamera = _cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front);
    cameraController = CameraController(_frontCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888);
    await cameraController.initialize();

    if(cameraController.value.isInitialized){
      cameraController.startImageStream((CameraImage cameraImage) {
        _processCameraFrame(cameraImage);
      });
    }
  }

  void setExercise(ExerciseType type){
    _exerciseType = type;
    exercise = ExerciseFactory.create(type);
    // print("Exercise set to $_exerciseType \n");
  }

  Future<void> _processCameraFrame(CameraImage cameraImage) async {
    if (_isBusy) return; // Skip if already processing a frame

    // final stopwatch = Stopwatch();
    // stopwatch.start();

    _isBusy = true;
    final format = InputImageFormatValue.fromRawValue(cameraImage.format.raw);

    final inputImage = await _convertCameraImageToInputImage(cameraImage);

    if(inputImage == null) {
      _isBusy = false;
      return;
    }

    final poses = await _poseDetector.processImage(inputImage);

    double? angleRad = calculateAngleRad(
                                  poses,
                                  exercise.jointAngleLocations[0]);
    if (angleRad != null){
      currentAngleShoulder = angleRad * (180 / pi);
    }

    repetitions += checkCorrectRep(exercise, currentAngleShoulder);


    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = PosePainter(
        poses,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        CameraLensDirection.front,
      );
      customPaint = CustomPaint(painter: painter);
    } else {
      customPaint = null;
    }
    _isBusy = false;
    // print(stopwatch.elapsedMilliseconds);
    // stopwatch.stop();
    // print(LoggerService().log(channel: LogChannel.csv, ownerId: UOID!, data: 'Dataaaaa'));
    notifyListeners();
  }

  Future<InputImage?> _convertCameraImageToInputImage(CameraImage image) async{
    // get image format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    // only supported format is nv21 for Android
    if (format == null || format != InputImageFormat.nv21) {
      return null;
    }
    // since format is constraint to nv21, it only has one plane
    final plane = image.planes.first;

    // compose InputImage using bytes
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: InputImageRotation.rotation90deg,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  } // _convertCameraImageToInputImage

  double? calculateAngleRad(List<Pose> poses, List<PoseLandmarkType> types) {
    for (final pose in poses) {
      final PoseLandmark joint1 = pose.landmarks[types[0]]!;
      final PoseLandmark joint2 = pose.landmarks[types[1]]!;
      final PoseLandmark joint3 = pose.landmarks[types[2]]!;

      if (joint1.x > 0 &&
          joint1.y > 0 &&
          joint2.x > 0 &&
          joint2.y > 0 &&
          joint3.x > 0 &&
          joint3.y > 0) {
        double v1x = joint1.x - joint2.x;
        double v1y = joint1.y - joint2.y;
        double v2x = joint3.x - joint2.x;
        double v2y = joint3.y - joint2.y;

        double dotProduct = v1x * v2x + v1y * v2y;

        double v1Length = sqrt(v1x * v1x + v1y * v1y);
        double v2Length = sqrt(v2x * v2x + v2y * v2y);

        if (v1Length == 0 || v2Length == 0) return null;

        double angleRad = acos(dotProduct / (v1Length * v2Length));

        return angleRad;
      } else {
        return null;
      }
    }
  }   // calculateAngleRad
  }   // PoseDetectionViewModel

  int checkCorrectRep(ShoulderExercise e, double angle){
  if(angle > e.jointLimits[0].lower - e.jointLimits[0].tolerance &&
      angle < e.jointLimits[0].lower + e.jointLimits[0].tolerance){
    e.jointLimits[0].reachedLow = true;
  }
  else if((angle > e.jointLimits[0].upper - e.jointLimits[0].tolerance &&
          angle < e.jointLimits[0].upper + e.jointLimits[0].tolerance) &&
          e.jointLimits[0].reachedLow){
    // e.jointLimits[0].reachedHigh = true;
    e.jointLimits[0].reachedLow = false;
    return 1;
  }
  return 0;
  }
class PosePainter extends CustomPainter {
  PosePainter(
      this.poses,
      this.imageSize,
      this.rotation,
      this.cameraLensDirection,
  );

  final List<Pose> poses;
  final Size imageSize;
  final InputImageRotation rotation;
  final CameraLensDirection cameraLensDirection;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = Colors.green;

    final leftPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.yellow;

    final rightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.blueAccent;

    for (final pose in poses) {
      pose.landmarks.forEach((_, landmark) {
        canvas.drawCircle(
            Offset(
              translateX(
                landmark.x,
                size,
                imageSize,
                rotation,
                cameraLensDirection,
              ),
              translateY(
                landmark.y,
                size,
                imageSize,
                rotation,
              ),
            ),
            1,
            paint);
      });

      void paintLine(PoseLandmarkType type1, PoseLandmarkType type2,
          Paint paintType) {
        final PoseLandmark joint1 = pose.landmarks[type1]!;
        final PoseLandmark joint2 = pose.landmarks[type2]!;

        canvas.drawLine(
            Offset(
                translateX(
                  joint1.x,
                  size,
                  imageSize,
                  rotation,
                  cameraLensDirection,
                ),
                translateY(
                  joint1.y,
                  size,
                  imageSize,
                  rotation,
                )),
            Offset(
                translateX(
                  joint2.x,
                  size,
                  imageSize,
                  rotation,
                  cameraLensDirection,
                ),
                translateY(
                  joint2.y,
                  size,
                  imageSize,
                  rotation,
                )),
            paintType);
      }

      //Draw arms
      paintLine(
          PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow, leftPaint);
      paintLine(
          PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist, leftPaint);
      paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow,
          rightPaint);
      paintLine(
          PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist, rightPaint);

      //Draw Body
      paintLine(
          PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip, leftPaint);
      paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip,
          rightPaint);

      //Draw legs
      paintLine(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee, leftPaint);
      paintLine(
          PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle, leftPaint);
      paintLine(
          PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee, rightPaint);
      paintLine(
          PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle, rightPaint);
    }
  }

  double translateX(
      double x,
      Size canvasSize,
      Size imageSize,
      InputImageRotation rotation,
      CameraLensDirection cameraLensDirection,
      ) {
    if (cameraLensDirection == CameraLensDirection.front){
      x = canvasSize.height - x;
    }
    switch (rotation) {
      case InputImageRotation.rotation90deg:
        return x *
            canvasSize.width / imageSize.height;
      case InputImageRotation.rotation270deg:
        return canvasSize.width -
            x *
                canvasSize.width / imageSize.height;
      case InputImageRotation.rotation0deg:
      case InputImageRotation.rotation180deg:
        switch (cameraLensDirection) {
          case CameraLensDirection.back:
            return x * canvasSize.width / imageSize.width;
          default:
            return canvasSize.width - x * canvasSize.width / imageSize.width;
        }
    }
  }

  double translateY(
      double y,
      Size canvasSize,
      Size imageSize,
      InputImageRotation rotation,
      ) {
    switch (rotation) {
      case InputImageRotation.rotation90deg:
      case InputImageRotation.rotation270deg:
        return y *
            canvasSize.height / imageSize.width;
      case InputImageRotation.rotation0deg:
      case InputImageRotation.rotation180deg:
        return y * canvasSize.height / imageSize.height;
    }
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.poses != poses;
  }
}

