import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_models/accelerometer_view_model.dart';


class AccelerometerView extends StatelessWidget {
  //final AccelerometerViewModel accelerometerViewModel = AccelerometerViewModel();

  const AccelerometerView({super.key});

  @override
  Widget build(BuildContext context) {
    var accelerometerViewModel = context.watch<AccelerometerViewModel>();

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "ACCELEROMETER",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.amber,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text("Accelerometer X: ${accelerometerViewModel.getX}"),
          Text("Accelerometer Y: ${accelerometerViewModel.getY}"),
          Text("Accelerometer Z: ${accelerometerViewModel.getZ}"),
          Text("Accelerometer Timestamp: ${accelerometerViewModel.getTimestamp}"),
        ],
      ),
    );
  }
}
