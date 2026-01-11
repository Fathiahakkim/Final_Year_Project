import 'package:flutter/material.dart';
import '../theme/diagnose_theme.dart';

class VoiceButton extends StatelessWidget {
  final VoidCallback onTap;

  const VoiceButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120.0,
        height: 120.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF5BA3F5), // Lighter shade of blue
          boxShadow: DiagnoseTheme.voiceButtonShadow,
        ),
        child: const Icon(Icons.mic, color: Colors.white, size: 56.0),
      ),
    );
  }
}
