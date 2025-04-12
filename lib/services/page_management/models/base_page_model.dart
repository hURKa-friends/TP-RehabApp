import 'package:flutter/material.dart';
import 'package:rehab_app/models/annotations.dart';
import 'package:rehab_app/services/page_management/models/tutorial_step_model.dart';

abstract class BasePage {
  final IconData icon;
  final String title;
  final List<BasePage>? subPages;
  final List<TutorialStep>? tutorialSteps;

  const BasePage({
    required this.icon,
    required this.title,
    this.subPages,
    this.tutorialSteps,
  });

  @mustBeOverridden
  void initPage(BuildContext context);

  @mustBeOverridden
  void closePage(BuildContext context);
}