import 'package:flutter/material.dart';
import 'package:rehab_app/models/annotations.dart';
import 'package:rehab_app/services/page_management/models/base_page_model.dart';
import 'package:rehab_app/services/page_management/models/tutorial_step_model.dart';
import 'package:rehab_app/services/page_management/views/sub_menu_wrapper.dart';
import 'package:rehab_app/services/page_management/views/tutorial_wrapper.dart';

abstract class StatelessPage extends StatelessWidget implements BasePage {
  @override final IconData icon;
  @override final String title;
  @override final List<BasePage>? subPages;
  @override final List<TutorialStep>? tutorialSteps;

  @mustBeOverridden
  bool get shouldAutoWrap => true;

  const StatelessPage({
    super.key,
    required this.icon,
    required this.title,
    this.subPages,
    this.tutorialSteps
  });

  @mustBeOverridden
  Widget buildPage(BuildContext context);

  @override
  Widget build(BuildContext context) {
    /// Check if we need to render sub page menu if there are some subPages
    if (subPages != null && subPages!.isNotEmpty && (shouldAutoWrap && this is! SubMenuPageWrapper)) {
      return SubMenuPageWrapper(title: title, icon: icon, subPages: subPages);
    }
    /// Check if we need to render tutorial wrapper if there are tutorialSteps
    if (tutorialSteps != null && tutorialSteps!.isNotEmpty) {
      return TutorialWrapper( steps: tutorialSteps!, childBuilder: () => buildPage(context));
    }
    /// Otherwise render the page itself
    return buildPage(context);
  }
}