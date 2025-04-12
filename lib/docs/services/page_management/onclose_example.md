[Back to **Page Management documentation**](../page_management.md)
# Example of "Defining onClose() action"
`onClose()` method should be created in your ViewModel `foo_viewmodel.dart`:
```dart
  Future<void> onClose() async {
    // Here you can call ViewModel initialization code.
  }
```
and it should be called from your View `foo_view.dart`:
```dart
  @override
  void closePage(BuildContext context) {
    // Here you can call page closing code or reference ViewModel disposal like this:
    var fooViewModel = Provider.of<FooViewModel>(context, listen: false); /// IMPORTANT listen must be false
    fooViewModel.onClose();
  }
```
[Back to **Page Management documentation**](../page_management.md)