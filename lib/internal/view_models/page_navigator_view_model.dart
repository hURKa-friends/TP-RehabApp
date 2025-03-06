import 'package:flutter/material.dart';
import 'package:rehab_app/internal/models/page_model.dart';

class PageNavigatorViewModel extends ChangeNotifier {
  // Private Fields & Parameters
  late PageModel _currentPage;
  final List<PageModel> _pageStack = [];

  // Constructors
  PageNavigatorViewModel(PageModel page) {
    selectPage(page);
  }

  // Getters
  PageModel get currentPage => _currentPage;
  List<PageModel> get pageStack => _pageStack;

  // Methods
  void selectPage(PageModel page) {
    _pageStack.add(page);
    _currentPage = page;
    notifyListeners();
  }

  void goBack() {
    if (_pageStack.length > 1) {
      _pageStack.removeLast();
      _currentPage = _pageStack.last;
      notifyListeners();
    }
  }
}