// System and External dependencies
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// App core dependencies
import 'package:rehab_app/services/page_management/view_models/page_navigator_view_model.dart';
import 'package:rehab_app/services/page_management/views/page_navigator_view.dart';
import 'package:rehab_app/view_models/klaudia/data_acquisition_view_model.dart';
import 'package:rehab_app/views/menu_view.dart';

// Service dependencies
import 'package:rehab_app/services/external/logger_service.dart';
import 'package:rehab_app/services/external/sensor_service.dart';

// MVVM application dependencies
import 'package:rehab_app/view_models/menu_view_model.dart';
import 'package:rehab_app/view_models/pose_detection/pose_detection_view_model.dart';
///
/// Import your MVVM ViewModels here
///
import 'package:rehab_app/view_models/accl_viewmodel.dart';
import 'package:rehab_app/view_models/gyro_viewmodel.dart';
import 'package:rehab_app/view_models/lux_viewmodel.dart';
import 'package:rehab_app/view_models/mag_viewmodel.dart';
import 'package:rehab_app/view_models/settings_view_model.dart';
import 'package:rehab_app/view_models/kneeRehab_view_model.dart';

// Useful defines
final String baseAppDirectoryPath = '/storage/emulated/0/RehabApp';

void main() {
  runApp(const ChangeNotifierInjector());
}

class ChangeNotifierInjector extends StatelessWidget {
  const ChangeNotifierInjector({super.key});

  @override
  Widget build(BuildContext context) {
    ///
    /// Initialize all services here
    ///
    LoggerService();
    SensorService();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PageNavigatorViewModel(context,MenuView(icon: Icons.home, title: "App Menu"))),
        ChangeNotifierProvider(create: (context) => MenuViewModel()),
        ///
        /// Add your ViewModels here
        ///
        ChangeNotifierProvider(create: (context) => AcqViewModel()),
        ChangeNotifierProvider(create: (context) => AcclViewModel()),
        ChangeNotifierProvider(create: (context) => GyroViewModel()),
        ChangeNotifierProvider(create: (context) => MagViewModel()),
        ChangeNotifierProvider(create: (context) => LuxViewModel()),
        ChangeNotifierProvider(create: (context) => PoseDetectionViewModel()),
        ChangeNotifierProvider(create: (context) => SettingsViewModel()),
        ChangeNotifierProvider(create: (context) => KneeRehabMainViewModel()),
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