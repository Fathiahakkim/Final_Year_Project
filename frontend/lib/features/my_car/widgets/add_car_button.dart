import 'package:flutter/material.dart';
import '../theme/my_car_theme.dart';

class AddCarButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddCarButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: MyCarTheme.horizontalPadding,
      ),
      height: MyCarTheme.buttonHeight,
      decoration: BoxDecoration(
        color: MyCarTheme.accentBlue,
        borderRadius: BorderRadius.circular(MyCarTheme.buttonRadius),
        boxShadow: MyCarTheme.buttonShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(MyCarTheme.buttonRadius),
          child: const Center(
            child: Text(
              'ADD CAR',
              style: TextStyle(
                color: Colors.white,
                fontSize: MyCarTheme.buttonFontSize,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
