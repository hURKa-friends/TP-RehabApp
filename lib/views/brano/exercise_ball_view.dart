import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/brano/exercise_ball_viewmodel.dart'; // Adjust path if needed

class ExerciseBallView extends StatelessWidget {
  const ExerciseBallView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ExerciseBallViewModel>(
      builder: (context, viewModel, child) {
        var model = viewModel.exerciseBallModel;

        if (!model.showObject) {
          return SizedBox.shrink(); // If not visible, show nothing
        }

        double width = model.wightAndHeight[0] ?? 50; // Default if null
        double height = model.wightAndHeight[1] ?? width; // For ball, use width

        Widget objectWidget;

        switch (model.objectType) {
          case '1': // Ball
            objectWidget = Container(
              width: width,
              height: width,
              decoration: BoxDecoration(
                color: viewModel.currentColor,
                shape: BoxShape.circle,
              ),
            );
            break;

          case '2': // Cube
            objectWidget = Container(
              width: width,
              height: height,
              color: viewModel.currentColor,
            );
            break;

          case '3': // Cylinder
            objectWidget = Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: viewModel.currentColor,
                borderRadius: BorderRadius.circular(width / 2),
              ),
            );
            break;

          default:
            objectWidget = Text('Unknown object');
            break;
        }

        return Positioned(
          left: model.currentPosition?.dx ?? 100,
          top: model.currentPosition?.dy ?? 100,
          child: objectWidget,
        );
      },
    );
  }
}
