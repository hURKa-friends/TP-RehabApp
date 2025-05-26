import 'package:flutter/material.dart';


class TutorialStep {
  final String assetURI;
  final String heading;
  final String description;
  final bool hasConfirmButton;
  final void Function(BuildContext context)? onConfirm;

  TutorialStep({
    required this.assetURI,
    required this.heading,
    required this.description,
    this.hasConfirmButton = false,
    this.onConfirm,
  });
}


