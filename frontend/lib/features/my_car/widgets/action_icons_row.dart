import 'package:flutter/material.dart';
import '../theme/my_car_theme.dart';

class ActionIconsRow extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onIconTap;

  const ActionIconsRow({
    super.key,
    this.selectedIndex = 3,
    required this.onIconTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    final actions = [
      {'icon': Icons.directions_car, 'label': 'HGS Transactions'},
      {'icon': Icons.receipt_long, 'label': 'Pay Motor Vehicle Tax'},
      {'icon': Icons.local_parking, 'label': 'ISPARK Transactions'},
      {'icon': Icons.grid_view, 'label': 'Transactions'},
    ];

    // Responsive sizing
    final iconSize =
        isSmallScreen
            ? MyCarTheme.actionIconSize * 0.85
            : MyCarTheme.actionIconSize;
    final fontSize =
        isSmallScreen
            ? MyCarTheme.iconLabelFontSize * 0.9
            : MyCarTheme.iconLabelFontSize;
    final horizontalPadding =
        isSmallScreen
            ? MyCarTheme.horizontalPadding * 0.75
            : MyCarTheme.horizontalPadding;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(actions.length, (index) {
          final isSelected = index == selectedIndex;
          final action = actions[index];
          return Expanded(
            child: GestureDetector(
              onTap: () => onIconTap(index),
              child: Column(
                children: [
                  Container(
                    width: iconSize,
                    height: iconSize,
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? MyCarTheme.accentBlue
                              : MyCarTheme.iconBackground,
                      shape: BoxShape.circle,
                      boxShadow: MyCarTheme.iconShadow,
                    ),
                    child: Icon(
                      action['icon'] as IconData,
                      color: isSelected ? Colors.white : MyCarTheme.iconActive,
                      size: iconSize * 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 2.0 : 4.0,
                    ),
                    child: Text(
                      action['label'] as String,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: MyCarTheme.textPrimary,
                        fontSize: fontSize,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
