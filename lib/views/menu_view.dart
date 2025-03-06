import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rehab_app/internal/view_models/page_navigator_view_model.dart';
import 'package:rehab_app/view_models/menu_view_model.dart';

class MenuView extends StatelessWidget {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    var navigatorViewModel = context.watch<PageNavigatorViewModel>();
    var menuViewModel = context.watch<MenuViewModel>();

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
            child: InkWell(
              splashColor: colorScheme.primaryContainer,
              onTap: () {
                navigatorViewModel.selectPage(menuViewModel.pages[index]);
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