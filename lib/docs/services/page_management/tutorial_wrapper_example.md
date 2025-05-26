[Back to **Page Management documentation**](../page_management.md)
# Example of "Adding Tutorial to your page"
First thing you need to do when creating tutorial with `TutorialWrapper` for your `StatelessPage` or
`StatefulPage` is adding your image assets to `assets/your_folder/*`. Then you need to include them
in `pubspec.yaml`.
> [!TIP]
> Common types of assets in flutter include static data (for example, JSON files), configuration 
> files, icons, and images (JPEG, WebP, GIF, animated WebP/GIF, PNG, BMP, and WBMP). 
> https://docs.flutter.dev/ui/assets/assets-and-images

> [!WARNING]
> Current `TutorialWrapper` does not support multi-resolution, multi-theme assets.
```yaml
# The following section is specific to Flutter packages.
flutter:

  # The following line ensures that the Material Icons font is included with your application, so 
  # that you can use the icons in the material Icons class.
  uses-material-design: true

  # To add assets to your application, add an assets section, like this:
  assets:
    - assets/example/000_exercise.gif
    - assets/example/001_exercise.gif
    - assets/example/002_exercise.gif
    - assets/example/003_exercise.gif
    - assets/example/FEI_logo.gif
    # - Add your image assets 
```
Then you can create `List<TutorialStep>` similarly as submenus in `menu_view_model.dart` 
`List<BasePage> _pages`. When creating each `TutorialStep` you define its image `assetURI`, 
`heading` text and `description` text.
> [!TIP]
> To see how these controls are rendered try to open `ExampleView` `Tutorial Wrapper example` in 
> running app.
```dart
import 'package:flutter/material.dart';
import 'package:rehab_app/services/page_management/premenne/base_page_model.dart';
import 'package:rehab_app/services/page_management/premenne/tutorial_step_model.dart';
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
    FooView(icon: Icons.checklist_rtl_outlined, title: "Tutorial Wrapper example",
      tutorialSteps: [
        TutorialStep(
          assetURI: 'assets/foo/001foo.gif',
          heading: 'Heading1',
          description: 'Description text 1',
        ),
        TutorialStep(
          assetURI: 'assets/foo/002foo.gif',
          heading: 'Heading2',
          description: 'Description text 2',
        ),
        TutorialStep(
          assetURI: 'assets/foo/003foo.gif',
          heading: 'Heading3',
          description: 'Description text 3',
        ),
        TutorialStep(
          assetURI: 'assets/foo/004foo.gif',
          heading: 'Heading4',
          description: 'Description text 4',
        ),
      ],
    ),
    GraphView(icon: Icons.data_thresholding_outlined, title: "Sensor graph example"),
    SettingsView(icon: Icons.settings, title: "Settings"),
  ];

  // Getters
  List<BasePage> get pages => _pages;
}
```
Alternatively if your page has only one behaviour and you do not need to create different tutorials 
for different behaviours you can create `List<TutorialStep>` in your View, for example 
`foo_view.dart`, and assign it to a page through its constructor. This approach keeps the app more 
clutter-free, but requires extra steps. Your `foo_view.dart` would look like this:
```dart
import 'package:flutter/material.dart';
import 'package:rehab_app/services/page_management/premenne/stateless_page_model.dart';
import 'package:rehab_app/services/page_management/premenne/tutorial_step_model.dart';

class FooView extends StatelessPage {
  static const List<TutorialStep> _tutorialSteps = [
    TutorialStep(
      assetURI: 'assets/foo/001foo.gif',
      heading: 'Heading1',
      description: 'Description text 1',
    ),
    TutorialStep(
      assetURI: 'assets/foo/002foo.gif',
      heading: 'Heading2',
      description: 'Description text 2',
    ),
    TutorialStep(
      assetURI: 'assets/foo/003foo.gif',
      heading: 'Heading3',
      description: 'Description text 3',
    ),
    TutorialStep(
      assetURI: 'assets/foo/004foo.gif',
      heading: 'Heading4',
      description: 'Description text 4',
    ),
  ];

  const FooView({
      super.key,
      required super.icon,
      required super.title,
      super.subPages, // Optional
  }) : super(tutorialSteps: _tutorialSteps);

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
  Widget buildPage(BuildContext context) {
    return Scaffold(
      body: Text("Your widget tree that you want to show on page."),
    );
  }
}
```
or
```dart
import 'package:flutter/material.dart';
import 'package:rehab_app/services/page_management/premenne/stateless_page_model.dart';
import 'package:rehab_app/services/page_management/premenne/tutorial_step_model.dart';

class FooView extends StatelessPage {
  final List<TutorialStep> _tutorialSteps = [
    TutorialStep(
      assetURI: 'assets/foo/001foo.gif',
      heading: 'Heading1',
      description: 'Description text 1',
    ),
    TutorialStep(
      assetURI: 'assets/foo/002foo.gif',
      heading: 'Heading2',
      description: 'Description text 2',
    ),
    TutorialStep(
      assetURI: 'assets/foo/003foo.gif',
      heading: 'Heading3',
      description: 'Description text 3',
    ),
    TutorialStep(
      assetURI: 'assets/foo/004foo.gif',
      heading: 'Heading4',
      description: 'Description text 4',
    ),
  ];

  FooView({
      super.key,
      required super.icon,
      required super.title,
      super.subPages, // Optional
  }) : super(tutorialSteps: _tutorialSteps);

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
  Widget buildPage(BuildContext context) {
    return Scaffold(
      body: Text("Your widget tree that you want to show on page."),
    );
  }
}
```
then you can add this page to the `menu_view_model.dart` `List<BasePage> _pages` as usual:
```dart
import 'package:flutter/material.dart';
import 'package:rehab_app/services/page_management/premenne/base_page_model.dart';
import 'package:rehab_app/services/page_management/premenne/tutorial_step_model.dart';
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
    FooView(icon: Icons.checklist_rtl_outlined, title: "Tutorial Wrapper example"),
    GraphView(icon: Icons.data_thresholding_outlined, title: "Sensor graph example"),
    SettingsView(icon: Icons.settings, title: "Settings"),
  ];

  // Getters
  List<BasePage> get pages => _pages;
}
```
[Back to **Page Management documentation**](../page_management.md)