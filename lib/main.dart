import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rehab_app/internal/models/page_model.dart';
import 'package:rehab_app/internal/view_models/page_navigator_view_model.dart';
import 'package:rehab_app/internal/views/page_navigator_view.dart';

void main() {
  runApp(const ChangeNotifierInjector());
}

class ChangeNotifierInjector extends StatelessWidget {
  const ChangeNotifierInjector({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) =>
            PageNavigatorViewModel(
                PageModel(title: "App menu", icon:Icons.home, body: Placeholder())
            ),
        ),
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