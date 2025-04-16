import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rehab_app/arm_rehab/models/arm_model.dart';

import 'package:rehab_app/services/page_management/models/stateless_page_model.dart';
import 'package:rehab_app/services/page_management/view_models/page_navigator_view_model.dart';

class PosSelectViewModel extends ChangeNotifier {
  final imageHeight = 225.0;
  final imageWidth = 175.0;

  PosSelectViewModel() {
    // Default constructor
  }

  Future<void> onInit() async {
    // Here you can call ViewModel initialization code.
  }

  void onClose() {
    // Here you can call ViewModel disposal code.
  }

  void selectPage(BuildContext context, StatelessPage page) {
    var navigatorViewModel = Provider.of<PageNavigatorViewModel>(context, listen: false);
    navigatorViewModel.selectPage(context, page);
  }

  Widget wristOnlyFloatingButton(int exercise, void Function() selectPage) {
    if (exercise == 3) {
      return FloatingActionButton(
        onPressed: selectPage,
        backgroundColor: Colors.lightGreen,
        child: Icon(Icons.check),
      );
    }
    else {
      return space(1);
    }
  }
}