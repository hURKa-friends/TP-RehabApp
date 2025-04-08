[Back to **Page Management documentation**](../page_management.md)
# Example of "Creating your own StatefulPage"
`StatefulPage` and `StatefulPageState` are abstract classes that need to be extended by your own 
View class. Your `foo_view.dart` should look like this:
```dart 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rehab_app/services/page_management/models/stateful_page_model.dart';

class FooView extends StatelessPage {
  const FooView({
    super.key,
    required super.icon,
    required super.title,
    super.subPages, // Optional
    super.tutorialSteps // Optional
  });

  @override
  void initPage(BuildContext context) {
    // Here you can call page initialization code or reference ViewModel initialization like this:
    var fooViewModel = Provider.of<FooViewModel>(context, listen: false); /// IMPORTANT listen must be false
    fooViewModel.onInit();
  }

  @override
  void closePage(BuildContext context) {
    // Here you can call page closing code or reference ViewModel disposal like this:
    var fooViewModel = Provider.of<FooViewModel>(context, listen: false); /// IMPORTANT listen must be false
    fooViewModel.onClose();
  }
  
  @override
  FooViewState createState() => FooViewState();
}

class FooViewState extends StatefulPageState {
  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
        body: Text("Your widget tree that you want to show on page.")
    );
  }
}
```
The ViewModel class can be created as usual. Your `foo_viewmodel.dart` should look like this:
```dart
import 'package:flutter/material.dart';

class FooViewModel extends ChangeNotifier {
  FooViewModel() {
    // Default constructor
  }

  Future<void> onInit() async {
    // Here you can call ViewModel initialization code.
  }

  void onClose() {
    // Here you can call ViewModel disposal code.
  }
}
```
You then register this ViewModel in `main.dart`:
```dart
// MVVM application dependencies
import 'package:rehab_app/view_models/menu_view_model.dart';
///
/// Import your MVVM ViewModels here
///
import 'package:rehab_app/view_models/accl_viewmodel.dart';
import 'package:rehab_app/view_models/gyro_viewmodel.dart';
import 'package:rehab_app/view_models/lux_viewmodel.dart';
import 'package:rehab_app/view_models/mag_viewmodel.dart';
import 'package:rehab_app/view_models/settings_view_model.dart';

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
        ChangeNotifierProvider(create: (context) => PageNavigatorViewModel(context,
            MenuView(icon: Icons.home, title: "App Menu"))),
        ChangeNotifierProvider(create: (context) => MenuViewModel()),
        ///
        /// Add your ViewModels here
        ///
        ChangeNotifierProvider(create: (context) => FooViewModel()),
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
```
Than you can make your page accessible adding it to `menu_view_model.dart` `List<BasePage> _pages`:
```dart
import 'package:flutter/material.dart';
import 'package:rehab_app/services/page_management/models/base_page_model.dart';
import 'package:rehab_app/services/page_management/models/tutorial_step_model.dart';
import 'package:rehab_app/services/page_management/views/sub_menu_wrapper.dart';
import 'package:rehab_app/views/example_view.dart';
import 'package:rehab_app/views/graph_view.dart';
///
/// import your MVVM views here
///
import 'package:rehab_app/views/settings_view.dart';

class MenuViewModel extends ChangeNotifier {
  // Private Fields & Parameters
  final List<BasePage> _pages = [
    ///
    /// You can add your pages here
    ///
    FooView(icon: Icons.extension_outlined, title:"FooTitle"),
    GraphView(icon: Icons.data_thresholding_outlined, title: "Sensor graph example"),
    SettingsView(icon: Icons.settings, title: "Settings"),
  ];

  // Getters
  List<BasePage> get pages => _pages;
}
```
[Back to **Page Management documentation**](../page_management.md)