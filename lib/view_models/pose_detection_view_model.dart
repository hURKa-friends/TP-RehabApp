import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class PoseDetectionViewModel extends ChangeNotifier{
  // Fields
  late List<CameraDescription> _cameras;
  late CameraDescription _frontCamera;
  late CameraController cameraController;
  late PoseDetector _poseDetector;
  late CustomPaint? customPaint;
  String? _text;
  bool _isBusy = false;
  final Function() onUpdate; // Callback function to trigger UI updates
  final bool mounted;
  bool _canProcess = true;

  late List<Pose> _poses;

  // Constructor
  PoseDetectionViewModel(this.mounted, this.onUpdate()) {
    _initCamera();
    _initPoseDetector();
  }

  @override
  void dispose() {
    _canProcess = false;
    _poseDetector.close();
    cameraController.dispose();
    super.dispose();
  }

  void _initPoseDetector() {
    final options = PoseDetectorOptions();
    _poseDetector = PoseDetector(options: options);
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras(); // Initialize cameras
    _frontCamera = _cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front);

    cameraController = CameraController(_frontCamera, ResolutionPreset.max);
    try {
      await cameraController.initialize();
      if (mounted) {
        // state.setState(() {});
        onUpdate();
      }
      // Start listening to camera frames
      cameraController.startImageStream((CameraImage cameraImage) {
        if (!_isBusy && _canProcess) {
          _isBusy = true;
          _processCameraFrame(cameraImage);
        }
      });
    } catch (e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
          // Handle access errors here.
            break;
          default:
          // Handle other errors here.
            break;
        }
      }
    }
  }

  Future<void> _processCameraFrame(CameraImage cameraImage) async {
    print('Hello');
    final inputImage = await _convertCameraImageToInputImage(cameraImage);
    if(inputImage == null) return;
    _poses = await _poseDetector.processImage(inputImage);
    final poses = await _poseDetector.processImage(inputImage);
    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = PosePainter(
        poses,
        inputImage.metadata!.size,
      );
      customPaint = CustomPaint(painter: painter);
    } else {
      _text = 'Poses found: ${poses.length}\n\n';
      // TODO: set _customPaint to draw landmarks on top of image
      customPaint = null;
    }
    _isBusy = false;
    onUpdate(); // Notify the UI that the frame has been processed
  }

  Future<InputImage?> _convertCameraImageToInputImage(CameraImage image) async{
    // get image format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    // only supported format is nv21 for Android
    if (format == null || format != InputImageFormat.nv21) {
      return null;
    }
    // since format is constraint to nv21, it only has one plane
    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    // compose InputImage using bytes
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
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.poses != poses;
  }
}