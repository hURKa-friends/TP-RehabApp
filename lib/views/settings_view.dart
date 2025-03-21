import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rehab_app/view_models/settings_view_model.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    var settingsViewModel = context.watch<SettingsViewModel>();
    return Padding(
      padding: EdgeInsets.only(top: 16.0),
      child: Column(
        children: [
          Text("Výber vzhľadu aplikácie (Svetlý/Systém/Tmavý)",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: settingsViewModel.brightness ==  Brightness.dark ? Colors.white : Colors.black,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 16),
          Padding(padding: EdgeInsets.only(left: 40.0, right: 40.0),
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackShape: CustomTrackShape(
                  thumbSize: 40,
                  actualBrightness: settingsViewModel.brightness,),
                thumbShape: CustomThumbShape(
                  thumbSize: 40,
                  sliderValue: settingsViewModel.sliderValue,
                  actualBrightness: settingsViewModel.brightness,
                ),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 0),
              ),
              child: Slider(
                value: settingsViewModel.sliderValue,
                min: 0,
                max: 2,
                onChanged: (value) { settingsViewModel.onSliderChanged(value); },
                onChangeEnd: (value) { settingsViewModel.onSliderChanged(value.roundToDouble()); },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

///
/// Custom Graphic extended libraries for Theme Slider
///
class CustomThumbShape extends SliderComponentShape {
  final double thumbSize;
  final double sliderValue;
  final Brightness actualBrightness;

  CustomThumbShape({
    required this.thumbSize,
    required this.sliderValue,
    required this.actualBrightness
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(thumbSize, thumbSize);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter labelPainter,
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double value,
        required double textScaleFactor,
        required Size sizeWithOverflow,
      }) {
    final Canvas canvas = context.canvas;
    final IconData icon = sliderValue < 0.5 ? Icons.wb_sunny :
                          sliderValue > 1.5 ? Icons.nightlight_round :
                          Icons.brightness_4;
    final Color iconColor = sliderValue < 0.5 ? Colors.orange :
                            sliderValue > 1.5 ? Colors.indigo.shade900 :
                            Colors.purple;

    // Draw shadow
    final Paint shadowPaint = Paint()
      ..color = actualBrightness == Brightness.light ? Colors.black26 : Colors.white30
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 6);

    canvas.drawCircle(center, thumbSize / 2 + 3, shadowPaint);

    // Draw thumb background
    final Paint thumbPaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, thumbSize / 2, thumbPaint);

    // Draw icon
    final TextPainter iconPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: 30,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: iconColor,
        ),
      ),
      textDirection: textDirection,
    );

    iconPainter.layout();
    iconPainter.paint(canvas, center - Offset(iconPainter.width / 2, iconPainter.height / 2));
  }
}
class CustomTrackShape extends SliderTrackShape {
  final double thumbSize;
  late double trackHeight;
  late double backgroundHeight;
  final Brightness actualBrightness;

  CustomTrackShape({required this.thumbSize, required this.actualBrightness}) {
    trackHeight = thumbSize + 2;
    backgroundHeight = thumbSize + 12;
  }

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double thumbRadius = (sliderTheme.thumbShape?.getPreferredSize(isEnabled, isDiscrete).width ?? 10.0) / 2;
    final double trackLeft = offset.dx + thumbRadius;
    final double trackRight = offset.dx + parentBox.size.width - thumbRadius;
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    return Rect.fromLTRB(trackLeft, trackTop, trackRight, trackTop + trackHeight);
  }

  @override
  void paint(
      PaintingContext context,
      Offset offset, {
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required Animation<double> enableAnimation,
        required Offset thumbCenter,
        Offset? secondaryOffset,
        bool? isEnabled,
        bool? isDiscrete,
        required TextDirection textDirection,
      }) {
    final Canvas canvas = context.canvas;
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
    );

    if (trackRect.isEmpty) return;

    final Rect backgroundRect = Rect.fromCenter(
      center: trackRect.center,
      width: trackRect.width + thumbSize + 14,
      height: backgroundHeight,
    );

    // **Draw background (bigger)**
    final Paint backgroundPaint = Paint()
      ..color = actualBrightness == Brightness.light ? Colors.grey.shade400 : Colors.grey.shade200
      ..style = PaintingStyle.fill;

    final RRect backgroundRRect = RRect.fromRectAndRadius(backgroundRect, Radius.circular(backgroundHeight / 2));
    canvas.drawRRect(backgroundRRect, backgroundPaint);

    // **Gradient track (smaller, on top)**
    final Rect gradientRect = Rect.fromCenter(
      center: trackRect.center,
      width: trackRect.width + thumbSize + 4,
      height: trackHeight,
    );

    final Paint gradientPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.orange,
          Colors.deepPurple,
          Colors.deepPurple,
          Colors.indigo.shade900,
        ],
        stops: [0.0, 0.3, 0.6, 1.0],
      ).createShader(trackRect)
      ..style = PaintingStyle.fill;

    final RRect gradientRRect = RRect.fromRectAndRadius(gradientRect, Radius.circular(backgroundHeight / 2));
    canvas.drawRRect(gradientRRect, gradientPaint);

    canvas.drawRRect(gradientRRect, gradientPaint);
  }
}