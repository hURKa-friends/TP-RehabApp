[Back to **Page Management documentation**](../page_management.md)
# Example of "Using `PageManagement` directly in your code"
> [!CAUTION]
> If you want to add any of your pages to the global `pageStack` they need to be subtypes of
> `BasePage` more importantly `StatelessPage` or `StatefulPage` and they must be added from a place
> that has `BuildContext context` as `PageNavigator` uses `page.initPage(context);` and
> `_pageStack.last.closePage(context);`.

If your object fulfills these criteria you can add your page to the stack and show its contents:
```dart
    fooFunc(BuildContext context, StatelessPage page) {
      var navigatorViewModel = context.watch<PageNavigatorViewModel>();
      navigatorViewModel.selectPage(context, page);
    }
```

There is no limitation on using `goBack(context)` or `backToRoot(context)` only that you need to know
`BuildContext context` as `PageNavigator` uses `_pageStack.last.closePage(context);`.
```dart
    fooFunc1(BuildContext context) {
      var navigatorViewModel = context.watch<PageNavigatorViewModel>();
      navigatorViewModel.goBack(context, page);
    }
    
    fooFunc2(BuildContext context) {
      var navigatorViewModel = context.watch<PageNavigatorViewModel>();
      navigatorViewModel.backToRoot(context, page);
    }
```
> [!TIP]
> You can use `backToRoot(context)` when ending your page logic after you finish everything you are
> doing in order to skip the whole `pageStack` all the way to the root "MenuPage". This way you skip
> past all of your submenus.

[Back to **Page Management documentation**](../page_management.md)
