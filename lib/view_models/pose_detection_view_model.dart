import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class PoseDetectionViewModel extends ChangeNotifier{
  // Fields
  late List<CameraDescription> _cameras;
  late CameraDescription _frontCamera;
  late CameraController cameraController;
  late PoseDetector _poseDetector;
  CustomPaint? customPaint;
  String? _text;
  bool _isBusy = false;
  //final Function() onUpdate; // Callback function to trigger UI updates
  late bool mounted = false;
  bool _canProcess = true;

  late List<Pose> _poses;

  // Constructor
  PoseDetectionViewModel() {
    _initialize();
  }

  Future<void> _initialize() async {
    await _asyncInitCamera();
    _initPoseDetector();
    notifyListeners(); // Ensure UI rebuilds when camera is initialized
  }

  @override // Deconstructor
  void dispose() {
    _canProcess = false;
    _poseDetector.close();
    if (cameraController.value.isInitialized) {
      cameraController.stopImageStream();  // Stop the image stream before disposal
      cameraController.dispose();
    }
    super.dispose();
  }

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

    notifyListeners();

    if(cameraController.value.isInitialized){
      cameraController.startImageStream((CameraImage cameraImage) {
        _processCameraFrame(cameraImage);
      });
    }
  }

  Future<void> _processCameraFrame(CameraImage cameraImage) async {
    if (_isBusy) return; // Skip if already processing a frame

    _isBusy = true;
    final format = InputImageFormatValue.fromRawValue(cameraImage.format.raw);

    final inputImage = await _convertCameraImageToInputImage(cameraImage);

    if(inputImage == null) {
      _isBusy = false;
      return;
    }

    final poses = await _poseDetector.processImage(inputImage);

    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = PosePainter(
        poses,
        inputImage.metadata!.size,
      );
      customPaint = CustomPaint(painter: painter);
    } else {
      customPaint = null;
    }
    _isBusy = false;
    notifyListeners();
  }

  Future<InputImage?> _convertCameraImageToInputImage(CameraImage image) async{
    /// TODO REPAIR THIS CONVERSION (not working)
    // get image format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    // only supported format is nv21 for Android
    if (format == null || format != InputImageFormat.nv21) {
      print('---------------------------------- NO NV21 FORMAT -------------------------------');
      return null;
    }
    print('----------------------NV21 FORMAT -----------------------');
    // since format is constraint to nv21, it only has one plane
    final plane = image.planes.first;

    // compose InputImage using bytes
    print('conversion');
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: InputImageRotation.rotation0deg, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );


  }

}

class PosePainter extends CustomPainter {
  PosePainter(this.poses,
      this.imageSize,
  );

  final List<Pose> poses;
  final Size imageSize;

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

    double offsetX;
    double offsetY;
    double offsetX1;
    double offsetY1;
    double offsetX2;
    double offsetY2;
    for (final pose in poses) {
      pose.landmarks.forEach((_, landmark) {
        offsetX = size.width - landmark.x * size.width / imageSize.width;
        offsetY = landmark.y * size.height / imageSize.height;
        canvas.drawCircle(
            Offset(offsetX, offsetY),
            1,
            paint);
      });

      void paintLine(PoseLandmarkType type1, PoseLandmarkType type2,
          Paint paintType) {
        final PoseLandmark joint1 = pose.landmarks[type1]!;
        final PoseLandmark joint2 = pose.landmarks[type2]!;
        offsetX1 = size.width - joint1.x * size.width / imageSize.width;
        offsetY1 = joint1.y * size.height / imageSize.height;
        offsetX2 = size.width - joint2.x * size.width / imageSize.width;
        offsetY2 = joint2.y * size.height / imageSize.height;
        canvas.drawLine(
            Offset(offsetX1, offsetY1),
            Offset(offsetX2, offsetY2),
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
    print("Pose printer");
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.poses != poses;
  }
}