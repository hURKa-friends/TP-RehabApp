import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rehab_app/internal/view_models/page_navigator_view_model.dart';

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
        leading:
          (navigatorViewModel.pageStack.length > 1) ?
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () { navigatorViewModel.goBack(); },
          ) : null,
      ),
      body: navigatorViewModel.currentPage.body
    );
  }
}