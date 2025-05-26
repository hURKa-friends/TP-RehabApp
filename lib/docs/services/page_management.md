[Back to **Documentation for `Tele-Rehabilitation` mobile application and its components**](../rehab_app.md)
# Page Management documentation
`PageManagement` is collection of abstract, view, view model, model classes and page navigator MVVM
component that ensures correct page stack management with page initialization, closing, tutorial
wrapping and `SubMenu` nesting.

## Technical Information
Whole `PageManagement` system is based on abstract model class `BasePage` which is unified data type
for all pages (`Stateless` and `Stateful`) such that we can create single `List<BasePage>` which can
hold all types of pages. This is needed for `PageNavigator` logic to work with all pages. `BasePage`
model defines `@mustBeOverridable` methods `initPage()` and `closePage()` that `PageNavigator` calls
when opening and closing said pages.

`BasePage` is then implemented in abstract classes `StatelessPage` and `StatefulPage` that combine
behaviour of `Widget` and `BasePage`. These classes introduce `shouldAutoWrap` and `buildPage`,
because Widget method `build` is overridden to enable tutorial wrapping and sub menu auto wrapping.

Graphics and logic of tutorial wrapping is provided by `TutorialWrapper` that manages generation and
navigation in tutorial steps from `TutorialStep` model and drawing of the originally wrapped page.

Graphics and logic of submenu wrapping is provided by `SubMenuPageWrapper` that is extension of 
`StatelessPage` and therefore can be used as normal page in `List<BasePage>`. Any `StatelesPage` and
`StatefulPage` that has `subPages` is automatically wrapped by `SubMenuPageWrapper`.

The navigation itself is managed by `PageNavigator`. Every view in app that intends on using global
`PageManagement` should use `PageNavigator` viewModel that uses `pageStack` to keep track of
navigation. This viewModel defines methods to operate this stack like `selectPage()`, `goBack()` and
`backToRoot()`.

## Folder Structure
`PageManagement` is implemented in these files.
```plain
lib/
└── page_management/
    ├── models/
    │   ├── base_page_model.dart
    │   ├── stateful_page_model.dart
    │   ├── stateless_page_model.dart
    │   └── tutorial_step_model.dart
    ├── view_models/
    │   └── page_navigator_view_model.dart
    └── views/
        ├── page_navigator_view.dart
        ├── sub_menu_wrapper.dart
        └── tutorial_wrapper.dart
```

## Example Usage
This section provides links to examples that show you how to use `PageManagement` in your code.

- [Creating your own StatelessPage](./page_management/stateless_page_example.md)
- [Creating your own StatefulPage](./page_management/stateful_page_example.md)
- [Defining onInit() action](./page_management/oninit_example.md)
- [Defining onClose() action](./page_management/onclose_example.md)
- [Adding SubMenu to your page](./page_management/submenu_wrapper_example.md)
- [Adding Tutorial to your page](./page_management/tutorial_wrapper_example.md)
- [Using `PageManagement` directly in your code](./page_management/direct_pagemanagment_example.md)

---

[Back to **Documentation for `Tele-Rehabilitation` mobile application and its components**](../rehab_app.md)

---

## API Documentation

> [!WARNING]
> This section was Semi-auto generated. If you encounter any issues report them.

### abstract class `BasePage`
Is base class that defines a page in the app with icon, title, optional subpages and tutorial steps.
> - **@icon** - Required property that defines the icon representing the page.
> - **@title** - Required property that defines the title of the page.
> - **subPages** - Optional list of BasePage instances that represent sub-pages under this page.
> - **tutorialSteps** - Optional list of TutorialStep instances used for building tutorial walkthroughes.
> - **@initPage(BuildContext context)** - Abstract method that **MUST** be implemented to define initialization logic when the page opens.
> - **@closePage(BuildContext context)** - Abstract method that **MUST** be implemented to define cleanup logic when the page is closed.

---
### class `TutorialStep`
Data model that represents an individual step within a tutorial sequence.
> - **@assetURI** - Required input parameter of type `String` that specifies the asset image path displayed during the tutorial step.
> - **@heading** - Required input parameter of type `String` used as the title or main heading for the step.
> - **@description** - Required input parameter of type `String` providing detailed instructions or content for the tutorial step.

---
### abstract class `StatelessPage`
Abstract class for creating `StatelessWidgets` conforming to the `BasePage` contract.
> **Overridden properties and methods**
> - **@icon** - Required property that defines the icon representing the page.
> - **@title** - Required property that defines the title of the page.
> - **subPages** - Optional list of BasePage instances that represent sub-pages under this page.
> - **tutorialSteps** - Optional list of TutorialStep instances used for building tutorial walkthroughes.
> - **@initPage(BuildContext context)** - Abstract method that **MUST** be implemented to define initialization logic when the page opens.
> - **@closePage(BuildContext context)** - Abstract method that **MUST** be implemented to define cleanup logic when the page is closed.

> **Class specific properties and methods**
> - **shouldAutoWrap** - Optional abstract getter that determines whether the page should be auto-wrapped with UI elements like submenu or tutorial wrappers.
> - **@buildPage(BuildContext context)** -  Abstract method that **MUST** be overridden and is used to render the actual content of the page.
> - **build(BuildContext context)** - **Overridden method** that wraps the actual page content conditionally in either `SubMenuPageWrapper`, `TutorialWrapper`, or renders it directly.

---
### abstract class `StatefulPage`
Abstract class for creating `StatefulWidgets` conforming to the `BasePage` contract.
> **Overridden properties and methods**
> - **@icon** - Required property that defines the icon representing the page.
> - **@title** - Required property that defines the title of the page.
> - **subPages** - Optional list of BasePage instances that represent sub-pages under this page.
> - **tutorialSteps** - Optional list of TutorialStep instances used for building tutorial walkthroughes.
> - **@initPage(BuildContext context)** - Abstract method that **MUST** be implemented to define initialization logic when the page opens.
> - **@closePage(BuildContext context)** - Abstract method that **MUST** be implemented to define cleanup logic when the page is closed.

> **Class specific properties and methods**
> - **shouldAutoWrap** - Optional abstract getter that determines whether the page should be auto-wrapped with UI elements like submenu or tutorial wrappers.
> - **@createState(BuildContext context)** - Abstract method that **MUST** be overridden and must return a `StatefulPageState` instance for this widget.

### abstract class `StatefulPageState`
Abstract state class for rendering the UI of a `StatefulPage`.
> **Class specific properties and methods**
> - **@buildPage(BuildContext context)** -  Abstract method that **MUST** be overridden and is used to render the actual content of the page.
> - **build(BuildContext context)** - **Overridden method** that wraps the actual page content conditionally in either `SubMenuPageWrapper`, `TutorialWrapper`, or renders it directly.

---
### class `SubMenuPageWrapper`
A specialized `StatelessPage` that displays a list of selectable sub-pages as a scrollable card-based menu. Typically used to present grouped pages in a submenu UI.
> **Overridden properties and methods**
> - **@icon** - Required input parameter of type `IconData` used to visually represent this menu in the UI.
> - **@title** - Required input parameter of type `String` used as the menu’s title.
> - **subPages** - Optional input parameter of type `List<BasePage>` representing the pages listed in the submenu. These are rendered as tappable cards.
> - **shouldAutoWrap** - Returns `false`, disabling automatic wrapping with `SubMenuPageWrapper` or `TutorialWrapper` — **this widget is already a wrapper itself**.
> - **@initPage(BuildContext context)** - **Empty override.** No setup logic is needed for this menu wrapper.
> - **@closePage(BuildContext context)** - **Empty override.** No cleanup logic is necessary.
> - **@buildPage(BuildContext context)** - Returns a Scaffold widget that displays a vertical list of sub-pages, each rendered as a `Card` with its associated icon and title.

---
### class `TutorialWrapper`
Stateful UI component that wraps around a `BasePage` and overlays a multi-step tutorial walkthrough before showing the actual content of `BasePage`.
> - **@steps** - Required input argument of type `List<TutorialStep>` that defines the sequence of steps displayed in the tutorial.
> - **@childBuilder** - Required input argument of type `Widget Function()` which builds the underlying child widget to show once the tutorial is complete.

### class `_TutorialWrapperState`
Internal state management for TutorialWrapper, handling navigation and rendering of each tutorial step.
> - **tutorialComplete** - Internal bool state that tracks whether the tutorial has been completed.
> - **currentIndex** - Internal int state that tracks the current tutorial step being shown.
> - **back()** - Method that navigates to the previous tutorial step.
> - **next()** - Method that navigates to the next tutorial step.
> - **complete()** - Method that marks the tutorial as completed and transitions to the child widget.
> - **@build(BuildContext context)** - Builds the tutorial interface, including the current step’s content, navigation controls, and ultimately the wrapped child once completed.

---
### class `PageNavigatorView`
A stateless widget that acts as the main navigation container for page transitions. Displays an app bar with dynamic titles and a fade transition between pages.

### class `PageNavigatorViewModel`
View model that handles custom stack-based navigation between `BasePage`s. Tracks current page and handles transitions, setup, and teardown.
> - **_currentPage** - Internal state storing the currently displayed `BasePage`.
> - **_pageStack** - Internal list storing the stack of visited `BasePages`, enabling back navigation.
> - **currentPage** - Public getter returning the currently active page.
> - **pageStack** - Public getter returning the full navigation stack of pages.
> - **constructor PageNavigatorViewModel(BuildContext context, BasePage page)** -  Initializes the navigator by selecting the provided starting page.
> - **selectPage(BuildContext context, BasePage page)** - Pushes a new page onto the stack, calls its `initPage()` method, and sets it as the current page. Triggers UI updates via `notifyListeners()`.
> - **goBack(BuildContext context)** - Pops the current page off the stack, calls its `closePage()` method, and updates the current page to the previous one. No action taken if already at root.
> - **backToRoot(BuildContext context)** - Repeatedly calls `goBack()` until the stack is reduced to a single root page.

[Back to **Documentation for `Tele-Rehabilitation` mobile application and its components**](../rehab_app.md)