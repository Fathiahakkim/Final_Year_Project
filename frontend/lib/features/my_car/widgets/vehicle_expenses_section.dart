import 'package:flutter/material.dart';
import '../theme/my_car_theme.dart';

class VehicleExpensesSection extends StatelessWidget {
  final String month;

  const VehicleExpensesSection({super.key, this.month = 'May 2024'});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: MyCarTheme.horizontalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Vehicle Expenses',
            style: TextStyle(
              color: MyCarTheme.textPrimary,
              fontSize: MyCarTheme.sectionTitleFontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            month,
            style: TextStyle(
              color: MyCarTheme.textSecondary,
              fontSize: MyCarTheme.descriptionFontSize,
            ),
          ),
        ],
      ),
    );
  }
}
