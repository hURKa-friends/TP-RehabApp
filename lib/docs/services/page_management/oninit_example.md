[Back to **Page Management documentation**](../page_management.md)
# Example of "Defining onInit() action"
`onInit()` method should be created in your ViewModel `foo_viewmodel.dart`:
```dart
  Future<void> onInit() async {
    // Here you can call ViewModel initialization code.
  }
```
and it should be called from your View `foo_view.dart`:
```dart
  @override
  void initPage(BuildContext context) {
    // Here you can call page initialization code or reference ViewModel initialization like this:
    var fooViewModel = Provider.of<FooViewModel>(context, listen: false); /// IMPORTANT listen must be false
    fooViewModel.onInit();
  }
```
[Back to **Page Management documentation**](../page_management.md)