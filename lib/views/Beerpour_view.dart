import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  @override
  void initState() {
    super.initState();
    // Set preferred orientations to only portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    // Reset preferred orientations to all when the page is disposed
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }
  @override Widget buildPage(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BeerPourViewModel(),
      child: Consumer<BeerPourViewModel>(builder: (_, vm, __) {
        return Scaffold(
          body: Stack(children: [
            if (vm.unevenPouring)
              Positioned(
                top: 24,
                right: 24,
                child: Icon(Icons.error, size: 32, color: Colors.red),
              ),
            Column(children: [
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
        left: dx + 10,
        top: dy + 25,
        width: glassWidth * 0.95,
        height: glassHeight * 0.925,
        child: CustomPaint(
          painter: GlassLiquidPainter(
            beerLevel: widget.beerLevel,
            angle: widget.angle,
          ),
        ),
      ),
      // Glass outline overlay
      Positioned(
        left: dx - 160,
        top: dy - 130,
        width: glassWidth + 320,
        height: glassHeight + 250,
        child: Image.asset('assets/example/glass_outline.png', fit: BoxFit.fill),
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
    double width = size.width;
    double widthSecond = 0;
    final height = size.height;

    final currentLiquidHeight = height * beerLevel;
    final tiltOffset = tan(angle) * width / 2; // Offset from the center

    // Calculate the y-coordinates of the liquid surface at the edges
    double yLeft = height - (currentLiquidHeight + tiltOffset).clamp(0.0, height);
    double yRight = height - (currentLiquidHeight - tiltOffset).clamp(0.0, height);

    if((((size.width * height)/2) > currentLiquidHeight * size.width) && (height/tan(angle.abs()) < size.width)) {
      if(angle >= 0) {
        width = height/tan(angle).clamp(0.0, size.width);
        widthSecond = 0.0;
        yRight = height;
      } else {
        widthSecond = (size.width - height/tan(-angle)).clamp(0.0, size.width);
        yLeft = height;
      }
    }

    final path = Path()
      ..moveTo(widthSecond, height)
      ..lineTo(width, height)
      ..lineTo(width, yRight.clamp(0.0, height)); // Ensure within bounds

    // Define the top edge of the liquid (trapezoid)
    path.lineTo(widthSecond, yLeft.clamp(0.0, height)); // Ensure within bounds

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
        dripX = width / 2;
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

