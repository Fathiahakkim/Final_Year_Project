import 'package:flutter/material.dart';
import '../theme/diagnose_theme.dart';

class DiagnoseBackground extends StatelessWidget {
  final Widget child;

  const DiagnoseBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: DiagnoseTheme.backgroundGradient,
      ),
      child: child,
    );
  }
}
