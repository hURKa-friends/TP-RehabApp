import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rehab_app/services/page_management/view_models/page_navigator_view_model.dart';

class PageNavigatorView extends StatelessWidget {
  const PageNavigatorView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    var navigatorViewModel = context.watch<PageNavigatorViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(navigatorViewModel.currentPage.title),
        scrolledUnderElevation: 10,
        shadowColor: colorScheme.shadow,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        leading: (
          (navigatorViewModel.pageStack.length > 1)
          ? IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () { navigatorViewModel.goBack(context); },
            ) // Show
          : null  // Show nothing
        ),
      ),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 150),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: KeyedSubtree(
          key: ValueKey(navigatorViewModel.currentPage),
          child: navigatorViewModel.currentPage as Widget,
        ),
      ),
    );
  }
}