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
  const BeerPourPage({
    Key? key,
    required IconData icon,
    required String title,
    List<TutorialStep>? tutorialSteps,
  }) : super(
    key: key,
    icon: icon,
    title: title,
    tutorialSteps: tutorialSteps,
  );

  @override
  void initPage(BuildContext context) {}

  @override
  void closePage(BuildContext context) {}

  @override
  BeerPourPageState createState() => BeerPourPageState();
}

class BeerPourPageState extends StatefulPageState<BeerPourPage> {
  @override
  void initState() {
    super.initState();
    // Lock to portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    // Reset orientations
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  @override
  Widget buildPage(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BeerPourViewModel(),
      child: Consumer<BeerPourViewModel>(builder: (_, vm, __) {
        return Scaffold(
          body: Stack(
            children: [
              if (vm.unevenPouring)
                Positioned(
                  top: 24,
                  right: 24,
                  child: Icon(Icons.error, size: 32, color: Colors.red),
                ),
              Column(
                children: [
                  if (vm.countdownActive)
                    Expanded(
                      child: Center(
                        child: Text(
                          'Začína za ${vm.countdown}...',
                          style: TextStyle(fontSize: 32),
                        ),
                      ),
                    )
                  else ...[
                    SizedBox(height: 4),
                    ElevatedButton(
                      onPressed:
                      vm.sensorsRunning ? vm.stopExercise : vm.startExercise,
                      child: Text(vm.sensorsRunning ? 'Stop' : 'Start'),
                    ),
                    SizedBox(height: 24),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          if (!vm.isPouring && vm.accelStdDev > 0) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Štatistika merania'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('Počet nárazov: ${vm.impactCount}'),
                                        Text('Hladina trasenia: ${vm.accelStdDev.toStringAsFixed(2)}'),
                                      ],
                                    ),
                                  );
                                },
                              );
                            });
                            return SizedBox.shrink(); // Placeholder
                          } else {
                            return BeerGlassWidget(
                              beerLevel: vm.beerLevel,
                              angle: vm.angle,
                            );
                          }
                        },
                      ),
                    ),

                    Divider(),
                    ElevatedButton(
                      onPressed: vm.resetExercise,
                      child: Text('Reset'),
                    ),

                    // ——— show shake summary when finished ———
                  ],
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}

class BeerGlassWidget extends StatefulWidget {
  final double beerLevel;
  final double angle;

  const BeerGlassWidget({
    required this.beerLevel,
    required this.angle,
    Key? key,
  }) : super(key: key);

  @override
  State<BeerGlassWidget> createState() => _BeerGlassWidgetState();
}

class _BeerGlassWidgetState extends State<BeerGlassWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final size = MediaQuery.of(context).size;
    final glassWidth = size.width;
    final glassHeight = size.height;
    Provider.of<BeerPourViewModel>(context, listen: false)
        .setGlassDimensions(glassWidth, glassHeight);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final glassWidth = size.width * (9/10);
    final glassHeight = size.height * (7/10);
    final dx = (size.width - glassWidth) / 2;
    final dy = ((size.height * (7/10)) - (glassHeight));

    return Stack(
      children: [
        Positioned(
          left: dx + 10,
          top: dy + 17,
          width: glassWidth - 20,
          height: glassHeight - 28,
          child: CustomPaint(
            painter: GlassLiquidPainter(
              beerLevel: widget.beerLevel,
              angle: widget.angle,
            ),
          ),
        ),
        Positioned(
          left: dx - 160,
          top: dy - 130,
          width: glassWidth + 320,
          height: glassHeight + 250,
          child: Image.asset(
            'assets/example/glass_outline.png',
            fit: BoxFit.fill,
          ),
        ),
      ],
    );
  }
}

class GlassLiquidPainter extends CustomPainter {
  final double beerLevel;
  final double angle;

  GlassLiquidPainter({
    required this.beerLevel,
    required this.angle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (beerLevel <= 0) return;

    final paint = Paint()..color = Colors.amber;
    double width = size.width ;
    double widthSecond = 0;
    final height = size.height;

    final currentLiquidHeight = height * beerLevel;
    final tiltOffset = tan(angle) * width / 2;

    double yLeft  = height - (currentLiquidHeight + tiltOffset);
    double yRight = height - (currentLiquidHeight - tiltOffset);

    if ((yLeft >= height || yRight >= height) && (height / tan(angle.abs()) < size.width )) {
      if (angle >= 0) {
        width = height / tan(angle);
        widthSecond = 0.0;
        yRight = height;
      } else {
        widthSecond = (size.width - height / tan(-angle));
        yLeft = height;
      }
    }

    final path = Path()
      ..moveTo(widthSecond, height)
      ..lineTo(width, height)
      ..lineTo(width, yRight.clamp(0.0, height))
      ..lineTo(widthSecond, yLeft.clamp(0.0, height))
      ..close();

    canvas.clipRect(Rect.fromLTWH(0, 0, width, height));
    canvas.drawPath(path, paint);

    // Optional drip
    if (yLeft <= 0 || yRight <= 0) {
      final dripPaint = Paint()..color = Colors.amber.withOpacity(0.6);
      final dripRadius = width * 0.05;
      double dripX;
      if (yLeft <= 0 && yRight <= 0) {
        dripX = width / 2;
      } else if (yLeft <= 0) {
        dripX = 0.0;
      } else {
        dripX = width;
      }
      canvas.drawCircle(Offset(dripX, 10), dripRadius, dripPaint);
    }
  }

  @override
  bool shouldRepaint(covariant GlassLiquidPainter old) {
    return old.beerLevel != beerLevel || old.angle != angle;
  }
}
