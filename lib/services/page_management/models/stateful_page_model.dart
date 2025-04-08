import 'package:flutter/material.dart';
import 'package:rehab_app/models/annotations.dart';
import 'package:rehab_app/services/page_management/models/base_page_model.dart';
import 'package:rehab_app/services/page_management/models/tutorial_step_model.dart';
import 'package:rehab_app/services/page_management/views/sub_menu_wrapper.dart';
import 'package:rehab_app/services/page_management/views/tutorial_wrapper.dart';

abstract class StatefulPage extends StatefulWidget implements BasePage {
  @override final IconData icon;
  @override final String title;
  @override final List<BasePage>? subPages;
  @override final List<TutorialStep>? tutorialSteps;

  @mustBeOverridden
  bool get shouldAutoWrap => true;

  const StatefulPage({
    super.key,
    required this.icon,
    required this.title,
    this.subPages,
    this.tutorialSteps
  });

  @override
  StatefulPageState createState();
}

abstract class StatefulPageState<T extends StatefulPage> extends State<T> {
  @mustBeOverridden
  Widget buildPage(BuildContext context);

  @override
  Widget build(BuildContext context) {
    /// Check if we need to render sub page menu if there are some subPages
    if (widget.subPages != null && widget.subPages!.isNotEmpty && (widget.shouldAutoWrap && widget is! SubMenuPageWrapper)) {
      return SubMenuPageWrapper(title: widget.title, icon: widget.icon, subPages: widget.subPages);
    }
    /// Check if we need to render tutorial wrapper if there are tutorialSteps
    if (widget.tutorialSteps != null && widget.tutorialSteps!.isNotEmpty) {
      return TutorialWrapper(steps: widget.tutorialSteps!, childBuilder: () => buildPage(context));
    }
    /// Otherwise render the page itself
    return buildPage(context);
  }
}