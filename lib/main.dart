import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Internals
import 'package:rehab_app/internal/models/page_model.dart';
import 'package:rehab_app/internal/view_models/page_navigator_view_model.dart';
import 'package:rehab_app/internal/views/page_navigator_view.dart';
// Services
import 'package:rehab_app/services/logger_service.dart';
// MVVM application dependencies
import 'package:rehab_app/view_models/menu_view_model.dart';
///
/// import your MVVM ViewModels here
///
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
    return MaterialApp(
      title: 'Tele-rehabilitation App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 255, 185, 0), // Marek signature gold color
        ),
      ),
      home: PageNavigatorView(),
    );
  }
}