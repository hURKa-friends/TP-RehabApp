import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/page_management/models/stateful_page_model.dart';
import '../services/page_management/models/tutorial_step_model.dart';
import '../view_models/Beerpour_viewmodel.dart';

/// Main page
class BeerPourPage extends StatefulPage {
  const BeerPourPage({Key? key, required IconData icon, required String title, List<TutorialStep>? tutorialSteps})
      : super(key: key, icon: icon, title: title, tutorialSteps: tutorialSteps);
  @override void initPage(BuildContext context) {}
  @override void closePage(BuildContext context) {}
  @override BeerPourPageState createState() => BeerPourPageState();
}

class BeerPourPageState extends StatefulPageState<BeerPourPage> {
  @override Widget buildPage(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BeerPourViewModel(),
      child: Consumer<BeerPourViewModel>(builder: (_, vm, __) {
        return Scaffold(
          appBar: AppBar(title: Text(widget.title)),
          body: Column(children: [
            if (vm.countdownActive)
              Expanded(child: Center(child: Text('Starting in ${vm.countdown}...', style: TextStyle(fontSize: 32))))
            else ...[
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: vm.sensorsRunning ? vm.stopExercise : vm.startExercise,
                child: Text(vm.sensorsRunning ? 'Stop' : 'Start'),
              ),
              SizedBox(height: 24),
              Expanded(child: BeerGlassWidget(beerLevel: vm.beerLevel, angle: vm.angle)),
              if (vm.sensorsRunning)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(vm.isPouring ? 'Pouring...' : 'Tilt to pour', style: TextStyle(fontSize: 18)),
                ),
              Divider(),
              ElevatedButton(onPressed: vm.resetExercise, child: Text('Reset')),
            ],
          ]),
        );
      }),
    );
  }
}

class BeerGlassWidget extends StatelessWidget {
  final double beerLevel;
  final double angle;

  const BeerGlassWidget({required this.beerLevel, required this.angle, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Define glass interior area
    final glassWidth = size.width * 0.6;
    final glassHeight = size.height * 0.8;
    final dx = (size.width - glassWidth) / 2;
    final dy = (size.height - glassHeight) / 2;

    return Stack(children: [
      Positioned(
        left: dx,
        top: dy,
        width: glassWidth,
        height: glassHeight,
        child: CustomPaint(
          painter: GlassLiquidPainter(
            beerLevel: beerLevel,
            angle: angle,
          ),
        ),
      ),
      // Glass outline overlay
      Positioned(
        left: dx,
        top: dy,
        width: glassWidth,
        height: glassHeight,
        child: Image.asset('assets/glass_outline.png', fit: BoxFit.fill),
      ),
    ]);
  }
}

class GlassLiquidPainter extends CustomPainter {
  final double beerLevel;
  final double angle;

  GlassLiquidPainter({required this.beerLevel, required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.amber;
    final width = size.width;
    final height = size.height;
    // Total area of liquid
    final totalArea = width * height * beerLevel;
    // Height difference between sides due to tilt
    final deltaH = tan(angle) * width;
    // Rectangle portion height
    final hRect = (totalArea / width) - deltaH / 2;
    // Clamp
    final hClamped = hRect.clamp(0.0, height);
    final dH = deltaH;

    // Define polygon points (in local coords, origin top-left)
    final yLeft = height - (hClamped + dH);
    final yRight = height - hClamped;
    final path = Path()
      ..moveTo(0, height)
      ..lineTo(width, height)
      ..lineTo(width, yRight)
      ..lineTo(0, yLeft)
      ..close();

    // Clip to glass interior
    canvas.clipRect(Rect.fromLTWH(0, 0, width, height));
    // Draw liquid polygon
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant GlassLiquidPainter old) {
    return old.beerLevel != beerLevel || old.angle != angle;
  }
}

