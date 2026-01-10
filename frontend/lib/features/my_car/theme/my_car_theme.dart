import 'package:flutter/material.dart';

class MyCarTheme {
  // Colors - matching diagnose theme for consistency
  static const Color primaryDark = Color(0xFF1A1A2E);
  static const Color secondaryDark = Color(0xFF16213E);
  static const Color accentBlue = Color(0xFF4A90E2);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color iconBackground = Color(0xFFFFFFFF);
  static const Color iconActive = Color(0xFF4A90E2);

  // Gradients
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
  );

  // Border Radius
  static const double buttonRadius = 25.0;
  static const double iconRadius = 35.0;
  static const double cardRadius = 12.0;

  // Spacing
  static const double horizontalPadding = 24.0;
  static const double topPadding = 80.0;
  static const double sectionSpacing = 32.0;
  static const double iconSpacing = 16.0;
  static const double headerSpacing = 24.0;

  // Sizes
  static const double carIconSize = 120.0;
  static const double actionIconSize = 60.0;
  static const double buttonHeight = 50.0;

  // Typography
  static const double titleFontSize = 32.0;
  static const double descriptionFontSize = 14.0;
  static const double buttonFontSize = 16.0;
  static const double sectionTitleFontSize = 18.0;
  static const double iconLabelFontSize = 12.0;

  // Shadows
  static List<BoxShadow> get buttonShadow => [
    BoxShadow(
      color: accentBlue.withOpacity(0.3),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get iconShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
}
