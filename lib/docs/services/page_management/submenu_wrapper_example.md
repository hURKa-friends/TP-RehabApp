[Back to **Page Management documentation**](../page_management.md)
# Example of "Adding SubMenu to your page"
> [!WARNING]
> Even tho `SubMenuPageWrapper` is `Wrapper` that can and is used to wrap existing pages with 
> non-empty `List<BasePage> subPages` it is highly not recommended to create submenus this way. 
> Preferred way > of creating submenus is by creating normal page object of `SubMenuPageWrapper` 
> as shown in this example.

> [!NOTE]
> `List<BasePage> _pages` represents tree-like structure of the navigation stack. You can create
> submenus of submenus of submenus as you wish.

You can create submenus for your "page" simply by creating `SubMenuPageWrapper` object in the 
`menu_view_model.dart` `List<BasePage> _pages`:
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
    SubMenuPageWrapper(icon: Icons.menu, title: "Submenu example",
      subPages: [
        FooView(icon: Icons.extension_outlined, title: "Foo 1"),
        FooView(icon: Icons.looks_two_outlined, title: "Foo 2"),
        FooView(icon: Icons.looks_3_outlined, title: "Foo 3"),
        FooView(icon: Icons.looks_4_outlined, title: "Foo 4"),
        FooView(icon: Icons.looks_5_outlined, title: "Foo 5"),
        FooView(icon: Icons.looks_6_outlined, title: "Foo 6"),
        FooView(icon: Icons.seven_k_outlined, title: "Foo 7"),
        FooView(icon: Icons.eight_k_outlined, title: "Foo 8"),
        FooView(icon: Icons.nine_k_outlined, title: "Foo 9"),
      ],
    ),
    GraphView(icon: Icons.data_thresholding_outlined, title: "Sensor graph example"),
    SettingsView(icon: Icons.settings, title: "Settings"),
  ];

  // Getters
  List<BasePage> get pages => _pages;
}
```
You can even crete submenus in submenus altering `List<BasePage> _pages` structure:
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
    SubMenuPageWrapper(icon: Icons.menu, title: "Submenu example",
      subPages: [
        SubMenuPageWrapper(icon: Icons.menu, title: "SubSubmenu example",
          subPages: [
            FooView(icon: Icons.extension_outlined, title: "Foo 1"),
            FooView(icon: Icons.looks_two_outlined, title: "Foo 2"),
            FooView(icon: Icons.looks_3_outlined, title: "Foo 3"),
            FooView(icon: Icons.looks_4_outlined, title: "Foo 4"),
          ],
        ),
        FooView(icon: Icons.looks_5_outlined, title: "Foo 5"),
        FooView(icon: Icons.looks_6_outlined, title: "Foo 6"),
        FooView(icon: Icons.seven_k_outlined, title: "Foo 7"),
        FooView(icon: Icons.eight_k_outlined, title: "Foo 8"),
        FooView(icon: Icons.nine_k_outlined, title: "Foo 9"),
      ],
    ),
    GraphView(icon: Icons.data_thresholding_outlined, title: "Sensor graph example"),
    SettingsView(icon: Icons.settings, title: "Settings"),
  ];

  // Getters
  List<BasePage> get pages => _pages;
}
```

> [!TIP]
> If you want to create choice menu for your final page that will change its behaviour based on the 
> selection you can use `FooView's` constructor to pass attributes changing its behaviour. 
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
    SubMenuPageWrapper(icon: Icons.menu, title: "Final page behaviour selection example",
      subPages: [
        FooView(icon: Icons.extension_outlined, title: "Foo Exercise Left", isLeft: true),
        FooView(icon: Icons.extension_outlined, title: "Foo Exercise Right", isLeft: false),
      ],
    ),
    GraphView(icon: Icons.data_thresholding_outlined, title: "Sensor graph example"),
    SettingsView(icon: Icons.settings, title: "Settings"),
  ];

  // Getters
  List<BasePage> get pages => _pages;
}
```
[Back to **Page Management documentation**](../page_management.md)