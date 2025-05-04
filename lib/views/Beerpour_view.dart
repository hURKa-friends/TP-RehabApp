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
          body: Column(children: [
            if (vm.countdownActive)
              Expanded(child: Center(child: Text('Starting in ${vm.countdown}...', style: TextStyle(fontSize: 32))))
            else ...[
              SizedBox(height: 4),
              ElevatedButton(
                onPressed: vm.sensorsRunning ? vm.stopExercise : vm.startExercise,
                child: Text(vm.sensorsRunning ? 'Stop' : 'Start'),
              ),
              SizedBox(height: 24),
              Expanded(child: BeerGlassWidget(beerLevel: vm.beerLevel, angle: vm.angle)),
              Divider(),
              ElevatedButton(onPressed: vm.resetExercise, child: Text('Reset')),
            ],
          ]),
        );
      }),
    );
  }
}

class BeerGlassWidget extends StatefulWidget {
  final double beerLevel;
  final double angle;

  const BeerGlassWidget({required this.beerLevel, required this.angle, Key? key}) : super(key: key);

  @override
  State<BeerGlassWidget> createState() => _BeerGlassWidgetState();
}

class _BeerGlassWidgetState extends State<BeerGlassWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final size = MediaQuery.of(context).size;
    final glassWidth = size.width * 1;
    final glassHeight = size.height * 0.725;
    Provider.of<BeerPourViewModel>(context, listen: false).setGlassDimensions(glassWidth, glassHeight);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Define glass interior area (these are used for positioning the painter)
    final glassWidth = size.width * 1;
    final glassHeight = size.height * 0.725;
    final dx = (size.width - glassWidth) / 2;
    final dy = (size.height - (glassHeight * 1.375));

    return Stack(children: [
      Positioned(
        left: dx,
        top: dy,
        width: glassWidth,
        height: glassHeight,
        child: CustomPaint(
          painter: GlassLiquidPainter(
            beerLevel: widget.beerLevel,
            angle: widget.angle,
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
    if (beerLevel <= 0) {
      return; // Don't paint anything if beerLevel is zero or negative
    }
    final paint = Paint()..color = Colors.amber.withOpacity(0.85);
    final width = size.width;
    final height = size.height;

    final currentLiquidHeight = height * beerLevel;
    final tiltOffset = tan(angle) * width / 2; // Offset from the center

    // Calculate the y-coordinates of the liquid surface at the edges
    final yLeft = height - (currentLiquidHeight + tiltOffset).clamp(0.0, height);
    final yRight = height - (currentLiquidHeight - tiltOffset).clamp(0.0, height);

    final path = Path()
      ..moveTo(0, height)
      ..lineTo(width, height)
      ..lineTo(width, yRight.clamp(0.0, height)); // Ensure within bounds

    // Define the top edge of the liquid (trapezoid)
    path.lineTo(0, yLeft.clamp(0.0, height)); // Ensure within bounds

    path.close();

    // Clip to the glass area
    canvas.clipRect(Rect.fromLTWH(0, 0, width, height));

    // Draw the liquid
    canvas.drawPath(path, paint);

    // Optional drip effect - adjust dripX based on which side is lower
    if (yLeft <= 0 || yRight <= 0) {
      final dripPaint = Paint()..color = Colors.amber.withOpacity(0.6);
      final dripRadius = width * 0.01;
      double dripX;
      if (yLeft <= 0 && yRight <= 0) {
        dripX = width / 2; // Drip in the middle if both sides are over
      } else if (yLeft <= 0) {
        dripX = 0.0;
      } else {
        dripX = width.toDouble();
      }
      final dripY = 0.0;
      canvas.drawCircle(Offset(dripX, dripY + 10), dripRadius, dripPaint);
    }
  }


  @override
  bool shouldRepaint(covariant GlassLiquidPainter old) {
    return old.beerLevel != beerLevel || old.angle != angle;
  }
}

