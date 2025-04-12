import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rehab_app/services/page_management/models/stateless_page_model.dart';
import 'package:rehab_app/view_models/menu_view_model.dart';
import 'package:rehab_app/services/page_management/view_models/page_navigator_view_model.dart';

class MenuView extends StatelessPage {
  const MenuView({
    super.key,
    required super.icon,
    required super.title
  });

  @override
  void initPage(BuildContext context) {
    // Intentionally left empty as no setup is needed here
  }

  @override
  void closePage(BuildContext context) {
    /// It should not be possible to close this page, as it should be the lowest
    /// page in pageStack. There is nothing to close !
    throw Exception('App tried to close the Menu Page that is not closable !');
  }

  @override
  Widget buildPage(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    var menuViewModel = context.watch<MenuViewModel>();
    var navigatorViewModel = context.watch<PageNavigatorViewModel>();

    return Scaffold(
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: menuViewModel.pages.length,
        itemBuilder: (context, index) {
          return Card(
            clipBehavior: Clip.hardEdge,
            color: colorScheme.secondaryContainer,
            child: InkWell(
              splashColor: colorScheme.onPrimary,
              onTap: () {
                navigatorViewModel.selectPage(context, menuViewModel.pages[index]);
              },
              child: FittedBox(
                child: Icon(menuViewModel.pages[index].icon),
              ),
            ),
          );
        },
      ),
    );
  }
}