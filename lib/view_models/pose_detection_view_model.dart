import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:flutter/services.dart';
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

  // final _orientations = {
  //   DeviceOrientation.portraitUp: 0,
  //   DeviceOrientation.landscapeLeft: 90,
  //   DeviceOrientation.portraitDown: 180,
  //   DeviceOrientation.landscapeRight: 270,
  // };

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

    // notifyListeners();

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
        inputImage.metadata!.rotation,
        CameraLensDirection.front,
      );
      customPaint = CustomPaint(painter: painter);
    } else {
      customPaint = null;
    }
    _isBusy = false;
    notifyListeners();
  }

  Future<InputImage?> _convertCameraImageToInputImage(CameraImage image) async{
    // get image format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    // only supported format is nv21 for Android
    if (format == null || format != InputImageFormat.nv21) {
      print('---------------------- NO NV21 FORMAT -----------------------');
      return null;
    }
    print('---------------------- NV21 FORMAT -----------------------');
    // since format is constraint to nv21, it only has one plane
    final plane = image.planes.first;

    // final sensorOrientation = _frontCamera.sensorOrientation;
    // InputImageRotation? rotation;
    // var rotationCompensation =
    // _orientations[cameraController.value.deviceOrientation];
    //
    // if (rotationCompensation == null) return null;
    // if (_frontCamera.lensDirection == CameraLensDirection.front) {
    //   // front-facing
    //   rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
    // } else {
    //   // back-facing
    //   rotationCompensation =
    //       (sensorOrientation - rotationCompensation + 360) % 360;
    // }
    // rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    // if (rotation == null) return null;

    // compose InputImage using bytes
    print('conversion');
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: InputImageRotation.rotation90deg,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );


  }

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

        final offsetX_back = translateX(
          joint1.x,
          size,
          imageSize,
          rotation,
          CameraLensDirection.back,
        );

        final offsetX_front = translateX(
          joint1.x,
          size,
          imageSize,
          rotation,
          CameraLensDirection.front,
        );

        print("offsetX_back: $offsetX_back \noffsetY_front $offsetX_front\n");

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
    print("Pose printer");
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
      print("iS: $imageSize.width \ncS: $canvasSize.width \nx: $x");
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