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