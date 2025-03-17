import 'package:flutter/material.dart';
import 'package:rehab_app/models/page_model.dart';
import 'package:rehab_app/views/accelerometer_view.dart';
///
/// import your MVVM views here
///
import 'package:rehab_app/views/settings_view.dart';

class MenuViewModel extends ChangeNotifier {
  // Private Fields & Parameters
  final List<PageModel> _pages = [
    PageModel(icon: Icons.home, title: "Home", body: Placeholder()),
    ///
    /// You can add your pages here
    PageModel(icon: Icons.add_chart_rounded, title: "Accelerometer", body: AccelerometerView()),
    ///
    PageModel(icon: Icons.settings, title: "Settings", body: SettingsView()),
  ];

  // Constructors (if needed)

  // Getters
  List<PageModel> get pages => _pages;

  // Methods (if needed)

}