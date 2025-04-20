import 'package:flutter/material.dart';
import 'package:rehab_app/services/page_management/models/base_page_model.dart';

class PageNavigatorViewModel extends ChangeNotifier {
  // Private variables
  late BasePage _currentPage;
  final List<BasePage> _pageStack = [];

  // Constructor
  PageNavigatorViewModel(BuildContext context, BasePage page) {
    selectPage(context, page);
  }

  // Getters
  BasePage get currentPage => _currentPage;
  List<BasePage> get pageStack => _pageStack;

  void selectPage(BuildContext context, BasePage page) {
    page.initPage(context);
    _pageStack.add(page);
    _currentPage = page;
    notifyListeners();
  }

  void goBack(BuildContext context) {
    if (_pageStack.length > 1) {
      _pageStack.last.closePage(context);
      _pageStack.removeLast();
      _currentPage = _pageStack.last;
      notifyListeners();
    }
  }

  void backToRoot(BuildContext context) {
    while(_pageStack.length > 1) {
     goBack(context);
    }
  }
}