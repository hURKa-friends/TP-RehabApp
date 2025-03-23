import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Internals
import 'package:rehab_app/models/page_model.dart';
import 'package:rehab_app/services/sensor_service.dart';
import 'package:rehab_app/view_models/page_navigator_view_model.dart';
import 'package:rehab_app/views/page_navigator_view.dart';
// Services
import 'package:rehab_app/services/logger_service.dart';
// MVVM application dependencies
import 'package:rehab_app/view_models/menu_view_model.dart';
import 'package:rehab_app/view_models/pose_detection_view_model.dart';
///
/// import your MVVM ViewModels here
///
import 'package:rehab_app/view_models/accl_viewmodel.dart';
import 'package:rehab_app/view_models/gyro_viewmodel.dart';
import 'package:rehab_app/view_models/lux_viewmodel.dart';
import 'package:rehab_app/view_models/mag_viewmodel.dart';
import 'package:rehab_app/view_models/settings_view_model.dart';
import 'package:rehab_app/views/menu_view.dart';

final String baseAppDirectoryPath = '/storage/emulated/0/RehabApp';

void main() {
  runApp(const ChangeNotifierInjector());
}

class ChangeNotifierInjector extends StatelessWidget {
  const ChangeNotifierInjector({super.key});

  @override
  Widget build(BuildContext context) {
    LoggerService();
    SensorService();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) =>
            PageNavigatorViewModel(
                PageModel(title: "App menu", icon:Icons.home, body: MenuView())
            ),
        ),
        ChangeNotifierProvider(create: (context) => MenuViewModel()),
        ///
        /// You can add your ViewModels here
        ///
        ChangeNotifierProvider(create: (context) => AcclViewModel()),
        ChangeNotifierProvider(create: (context) => GyroViewModel()),
        ChangeNotifierProvider(create: (context) => MagViewModel()),
        ChangeNotifierProvider(create: (context) => LuxViewModel()),
        ChangeNotifierProvider(create: (context) => PoseDetectionViewModel()),
        ChangeNotifierProvider(create: (context) => SettingsViewModel()),
      ],
      child: MyMaterialApp(),
    );
  }
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    var settingsViewModel = context.watch<SettingsViewModel>();
    return MaterialApp(
      title: 'Tele-rehabilitation App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: settingsViewModel.brightness,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 255, 185, 0), // Marek signature gold color
          brightness: settingsViewModel.brightness,
        ),
      ),
      home: PageNavigatorView(),
    );
  }
}