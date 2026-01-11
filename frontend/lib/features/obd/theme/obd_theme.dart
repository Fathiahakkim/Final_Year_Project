import 'package:flutter/material.dart';

class OBDTheme {
  // Colors - matching overall app theme for consistency
  static const Color primaryDark = Color(0xFF1A1A2E);
  static const Color secondaryDark = Color(0xFF16213E);
  static const Color accentBlue = Color(0xFF4A90E2);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFFB0B0B0);
  static const Color iconActive = Color(0xFF4A90E2);
  static const Color iconInactive = Color(0xFF9E9E9E);

  // Metric colors
  static const Color rpmColor = Color(0xFFFFA726); // Orange
  static const Color tempColor = Color(0xFF42A5F5); // Light blue
  static const Color voltageColor = Color(0xFF66BB6A); // Green
  static const Color throttleColor = Color(0xFFFFA726); // Orange
  static const Color dtcWarningColor = Color(0xFFFFB74D); // Yellow/Orange
  static const Color dtcErrorColor = Color(0xFFEF5350); // Red

  // Status colors
  static const Color connectedGreen = Color(0xFF66BB6A);
  static const Color simulatedGreen = Color(0xFF66BB6A);

  // Gradients
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
  );

  // Border Radius
  static const double cardRadius = 16.0;
  static const double metricPanelRadius = 12.0;
  static const double buttonRadius = 8.0;
  static const double dtcItemRadius = 8.0;

  // Spacing
  static const double horizontalPadding = 20.0;
  static const double verticalPadding = 20.0;
  static const double topPadding = 80.0;
  static const double sectionSpacing = 24.0;
  static const double cardSpacing = 16.0;
  static const double metricSpacing = 12.0;

  // Sizes
  static const double adapterGraphicSize = 120.0;
  static const double metricPanelHeight = 110.0;
  static const double progressBarHeight = 4.0;
  static const double dtcItemHeight = 60.0;

  // Typography
  static const double titleFontSize = 28.0;
  static const double sectionTitleFontSize = 16.0;
  static const double metricValueFontSize = 24.0;
  static const double metricLabelFontSize = 12.0;
  static const double dtcCodeFontSize = 14.0;
  static const double dtcDescriptionFontSize = 12.0;

  // Shadows
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get metricPanelShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
  ];
}
