import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rehab_app/services/page_management/models/stateless_page_model.dart';
import 'package:rehab_app/services/page_management/view_models/page_navigator_view_model.dart';

class SubMenuPageWrapper extends StatelessPage {
  const SubMenuPageWrapper({
    super.key,
    required super.icon,
    required super.title,
    super.subPages
  });

  @override
  bool get shouldAutoWrap => false;

  @override
  void initPage(BuildContext context) {
    // Intentionally left empty as no setup is needed here
  }

  @override
  void closePage(BuildContext context) {
    // Intentionally left empty as no cleanup is needed here
  }

  @override
  Widget buildPage(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    var navigatorViewModel = context.watch<PageNavigatorViewModel>();

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: subPages!.length,
          itemBuilder: (context, index) {
            /// Single menu Item
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 2.0),
              child: Card(
                clipBehavior: Clip.hardEdge,
                color: colorScheme.secondaryContainer,
                child: InkWell(
                  splashColor: colorScheme.onPrimary,
                  onTap: () {
                    navigatorViewModel.selectPage(context, subPages![index]);
                  },
                  child: Row(
                    children: [
                      /// Icon
                      Container(
                        color: colorScheme.inversePrimary,
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(
                            subPages![index].icon,
                            size: MediaQuery.of(context).size.height * 0.1,
                          ),
                        ),
                      ),
                      /// Text
                      Expanded(
                        child: Text(
                          subPages![index].title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}