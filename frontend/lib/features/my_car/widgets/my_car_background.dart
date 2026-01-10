import 'package:flutter/material.dart';
import '../theme/my_car_theme.dart';

class MyCarBackground extends StatelessWidget {
  final Widget child;

  const MyCarBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: MyCarTheme.backgroundGradient),
      child: child,
    );
  }
}
