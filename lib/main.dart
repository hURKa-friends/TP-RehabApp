// System and External dependencies
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

// App core dependencies
import 'package:rehab_app/services/page_management/view_models/page_navigator_view_model.dart';
import 'package:rehab_app/services/page_management/views/page_navigator_view.dart';
import 'package:rehab_app/views/menu_view.dart';

// Service dependencies
import 'package:rehab_app/services/external/logger_service.dart';
import 'package:rehab_app/services/external/sensor_service.dart';

// MVVM application dependencies
import 'package:rehab_app/view_models/menu_view_model.dart';
///
/// Import your MVVM ViewModels here
import 'package:rehab_app/arm_rehab/view_models/arm_select_view_model.dart';
import 'package:rehab_app/arm_rehab/view_models/pos_select_view_model.dart';
import 'package:rehab_app/arm_rehab/view_models/orient_select_view_model.dart';
import 'package:rehab_app/arm_rehab/view_models/exercise_select_view_model.dart';
import 'package:rehab_app/arm_rehab/view_models/repetition_select_view_model.dart';
import 'package:rehab_app/arm_rehab/view_models/exercise_setpoints_view_model.dart';
import 'package:rehab_app/arm_rehab/view_models/exercise_start_view_model.dart';
import 'package:rehab_app/arm_rehab/view_models/exercise_summary_view_model.dart';
///
import 'package:rehab_app/view_models/accl_viewmodel.dart';
import 'package:rehab_app/view_models/gyro_viewmodel.dart';
import 'package:rehab_app/view_models/lux_viewmodel.dart';
import 'package:rehab_app/view_models/mag_viewmodel.dart';
import 'package:rehab_app/view_models/settings_view_model.dart';

// Useful defines
final String baseAppDirectoryPath = '/storage/emulated/0/RehabApp';

void main() {
  runApp(const ChangeNotifierInjector());
}

class ChangeNotifierInjector extends StatelessWidget {
  const ChangeNotifierInjector({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    ///
    /// Initialize all services here
    ///
    LoggerService();
    SensorService();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PageNavigatorViewModel(context,
            MenuView(icon: Icons.home, title: "App Menu"))),
        ChangeNotifierProvider(create: (context) => MenuViewModel()),
        ///
        /// Add your ViewModels here
        ChangeNotifierProvider(create: (context) => ArmSelectViewModel()),
        ChangeNotifierProvider(create: (context) => PosSelectViewModel()),
        ChangeNotifierProvider(create: (context) => OrientSelectViewModel()),
        ChangeNotifierProvider(create: (context) => ExerciseSelectViewModel()),
        ChangeNotifierProvider(create: (context) => RepetitionSelectViewModel()),
        ChangeNotifierProvider(create: (context) => ExerciseSetpointsViewModel()),
        ChangeNotifierProvider(create: (context) => ExerciseStartViewModel()),
        ChangeNotifierProvider(create: (context) => ExerciseSummaryViewModel()),
        ///
        ChangeNotifierProvider(create: (context) => AcclViewModel()),
        ChangeNotifierProvider(create: (context) => GyroViewModel()),
        ChangeNotifierProvider(create: (context) => MagViewModel()),
        ChangeNotifierProvider(create: (context) => LuxViewModel()),
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