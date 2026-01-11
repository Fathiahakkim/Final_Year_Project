import 'package:flutter/material.dart';
import '../theme/obd_theme.dart';

class OBDBackground extends StatelessWidget {
  final Widget child;

  const OBDBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: OBDTheme.backgroundGradient,
      ),
      child: child,
    );
  }
}
