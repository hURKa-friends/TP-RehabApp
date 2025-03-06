import 'package:flutter/material.dart';
import 'package:rehab_app/internal/models/page_model.dart';

class MenuViewModel extends ChangeNotifier {
  // Private Fields & Parameters
  final List<PageModel> _pages = [
    PageModel(icon: Icons.home, title: "Home", body: Placeholder()),
    PageModel(icon: Icons.speed, title: "Accelerometer", body: Placeholder()),
    PageModel(icon: Icons.flip_camera_android, title: "Gyroscope", body: Placeholder()),
    PageModel(icon: Icons.home, title: "Home", body: Placeholder()),
    PageModel(icon: Icons.speed, title: "Accelerometer", body: Placeholder()),
    PageModel(icon: Icons.flip_camera_android, title: "Gyroscope", body: Placeholder()),
    PageModel(icon: Icons.home, title: "Home", body: Placeholder()),
    PageModel(icon: Icons.speed, title: "Accelerometer", body: Placeholder()),
    PageModel(icon: Icons.flip_camera_android, title: "Gyroscope", body: Placeholder()),
    PageModel(icon: Icons.home, title: "Home", body: Placeholder()),
    PageModel(icon: Icons.speed, title: "Accelerometer", body: Placeholder()),
    PageModel(icon: Icons.flip_camera_android, title: "Gyroscope", body: Placeholder()),
    PageModel(icon: Icons.home, title: "Home", body: Placeholder()),
    PageModel(icon: Icons.speed, title: "Accelerometer", body: Placeholder()),
    PageModel(icon: Icons.flip_camera_android, title: "Gyroscope", body: Placeholder()),
    PageModel(icon: Icons.home, title: "Home", body: Placeholder()),
    PageModel(icon: Icons.speed, title: "Accelerometer", body: Placeholder()),
    PageModel(icon: Icons.flip_camera_android, title: "Gyroscope", body: Placeholder()),
    PageModel(icon: Icons.home, title: "Home", body: Placeholder()),
    PageModel(icon: Icons.speed, title: "Accelerometer", body: Placeholder()),
    PageModel(icon: Icons.flip_camera_android, title: "Gyroscope", body: Placeholder()),
  ];

  // Constructors (if needed)

  // Getters
  List<PageModel> get pages => _pages;

  // Methods (if needed)

}