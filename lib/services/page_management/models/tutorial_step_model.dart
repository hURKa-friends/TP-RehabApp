class TutorialStep {
  final String assetURI;
  final String heading;
  final String description;
  final void Function() function;

  const TutorialStep({
    required this.assetURI,
    required this.heading,
    required this.description,
    required this.function
  });
}