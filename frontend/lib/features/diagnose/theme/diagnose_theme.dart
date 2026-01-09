import 'package:flutter/material.dart';

class DiagnoseTheme {
  // Colors
  static const Color primaryDark = Color(0xFF1A1A2E);
  static const Color secondaryDark = Color(0xFF16213E);
  static const Color accentBlue = Color(0xFF4A90E2);
  static const Color accentPurple = Color(0xFF7B68EE);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color iconActive = Color(0xFF4A90E2);
  static const Color iconInactive = Color(0xFF9E9E9E);

  // Gradients
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
  );

  static const RadialGradient voiceButtonGlow = RadialGradient(
    colors: [Color(0x804A90E2), Color(0x404A90E2), Color(0x004A90E2)],
    stops: [0.0, 0.5, 1.0],
  );

  // Border Radius
  static const double cardRadius = 12.0;
  static const double inputRadius = 24.0;
  static const double buttonRadius = 50.0;

  // Spacing
  static const double carBottomSpacing = 20.0;
  static const double voiceButtonSize = 80.0;
  static const double complaintCardPadding = 16.0;
  static const double inputPadding = 16.0;
  static const double topPadding = 80.0;
  static const double cardSpacing = 16.0;

  // Shadows
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get carShadow => [
    BoxShadow(
      color: accentBlue.withOpacity(0.3),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> get voiceButtonShadow => [
    BoxShadow(
      color: accentBlue.withOpacity(0.6),
      blurRadius: 30,
      spreadRadius: 8,
    ),
    BoxShadow(
      color: accentBlue.withOpacity(0.3),
      blurRadius: 50,
      spreadRadius: 12,
    ),
  ];
}
