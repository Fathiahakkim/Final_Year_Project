class DiagnoseSpacing {
  static const double spaceBetweenCarAndMic = 100.0;
  static const double carBottomSpacing = 20.0;
  static const double topSpacing = 60.0;
  static const double extraMicSpacing = 60.0;
  static const double cardClearance = 170.0;
  static const double scrollPadding = 120.0;

  static double calculateSpaceBetweenMicAndCard(double availableHeight) {
    return (availableHeight * 0.15).clamp(40.0, 80.0);
  }

  static double calculateCardHeight(double screenHeight) {
    return screenHeight * 0.25;
  }

  static double calculateBottomPadding(
    double cardHeight,
    double keyboardHeight,
  ) {
    return cardHeight + keyboardHeight + scrollPadding;
  }
}
