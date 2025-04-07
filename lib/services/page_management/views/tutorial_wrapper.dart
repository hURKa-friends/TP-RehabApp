import 'package:flutter/material.dart';
import 'package:rehab_app/services/page_management/models/tutorial_step_model.dart';

class TutorialWrapper extends StatefulWidget {
  final List<TutorialStep> steps;
  final Widget Function() childBuilder;

  const TutorialWrapper({
    super.key,
    required this.steps,
    required this.childBuilder,
  });

  @override
  State<TutorialWrapper> createState() => _TutorialWrapperState();
}

class _TutorialWrapperState extends State<TutorialWrapper> {
  final ScrollController _scrollController = ScrollController();
  bool tutorialComplete = false;
  int currentIndex = 0;

  void back() {
    if (currentIndex > 0) {
      setState(() => currentIndex--);
    }
  }

  void next() {
    if (currentIndex < widget.steps.length - 1) {
      setState(() => currentIndex++);
    }
  }

  void complete() {
    setState(() => tutorialComplete = true);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentStep = widget.steps[currentIndex];

    if (tutorialComplete) {
      return widget.childBuilder();
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            /// Image Asset
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0,48.0,24.0,12.0),
              child: Material(
                elevation: 20, // Adjust elevation to control the shadow size
                borderRadius: BorderRadius.circular(20), // Match the border radius for consistency
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.height * 0.4,
                    child: Image.asset(
                      currentStep.assetURI,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            /// Heading text
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0,12.0,24.0,12.0),
              child: Text(
                currentStep.heading,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ),
            /// Description text
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Scrollbar(
                  thumbVisibility: true, // Always show scrollbar for visibility
                  controller: _scrollController,
                  thickness: 6.0,
                  radius: Radius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Text(
                        currentStep.description,
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            /// Navigation buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0,48.0,24.0,48.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /// Back button
                  Visibility(
                    visible: currentIndex > 0,
                    maintainAnimation: true,
                    maintainState: true,
                    maintainSize: true,
                    child: ElevatedButton(
                      onPressed: back,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        backgroundColor: colorScheme.secondaryContainer,
                        minimumSize: Size(100, 50),
                      ),
                      child: Icon(Icons.arrow_back, size: 30, color: colorScheme.onSecondaryContainer),
                    ),
                  ),
                  /// Forward button
                  Visibility(
                    visible: currentIndex != widget.steps.length - 1,
                    maintainAnimation: true,
                    maintainState: true,
                    maintainSize: true,
                    child: ElevatedButton(
                      onPressed: next,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        backgroundColor: colorScheme.secondaryContainer,
                        minimumSize: Size(100, 50),
                      ),
                      child: Icon(Icons.arrow_forward, size: 30, color: colorScheme.onSecondaryContainer),
                    ),
                  ),
                  /// Checkmark button
                  Visibility(
                    visible: currentIndex == widget.steps.length - 1,
                    maintainAnimation: true,
                    maintainState: true,
                    maintainSize: true,
                    child:  ElevatedButton(
                      onPressed: complete,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        backgroundColor: colorScheme.tertiaryContainer,
                        minimumSize: Size(100, 50),
                      ),
                      child: Icon(Icons.check, size: 30, color: colorScheme.onTertiaryContainer),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}