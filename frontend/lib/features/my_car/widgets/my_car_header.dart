import 'package:flutter/material.dart';
import '../theme/my_car_theme.dart';
import '../../../state/app_state.dart';

class MyCarHeader extends StatelessWidget {
  final AppState appState;

  const MyCarHeader({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    // Responsive sizing
    final carIconSize =
        isSmallScreen ? MyCarTheme.carIconSize * 0.85 : MyCarTheme.carIconSize;

    return ListenableBuilder(
      listenable: appState,
      builder: (context, child) {
        final selectedCar = appState.primaryCar;

        return Column(
          children: [
            // Car image or fallback icon
            Container(
              width: carIconSize,
              height: carIconSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.25),
                  width: 2.5,
                ),
              ),
              child: ClipOval(
                child: selectedCar != null
                    ? Image.asset(
                        selectedCar.imageUrl.isNotEmpty
                            ? selectedCar.imageUrl
                            : 'assets/cars/default_car.jpg',
                        height: carIconSize,
                        width: carIconSize,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.directions_car_outlined,
                            size: carIconSize * 0.55,
                            color: Colors.white.withOpacity(0.7),
                          );
                        },
                      )
                    : Icon(
                        Icons.directions_car_outlined,
                        size: carIconSize * 0.55,
                        color: Colors.white.withOpacity(0.7),
                      ),
              ),
            ),
            SizedBox(
              height: MyCarTheme.headerSpacing * (isSmallScreen ? 0.8 : 1.0),
            ),
            // "My Car" title
            Text(
              'My Car',
              style: TextStyle(
                color: MyCarTheme.textPrimary,
                fontSize:
                    isSmallScreen
                        ? MyCarTheme.titleFontSize * 0.85
                        : MyCarTheme.titleFontSize,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            // Description text
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 24.0 : 32.0,
              ),
              child: Text(
                'Define your vehicle information, handle all operations easily.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: MyCarTheme.textSecondary,
                  fontSize:
                      isSmallScreen
                          ? MyCarTheme.descriptionFontSize * 0.9
                          : MyCarTheme.descriptionFontSize,
                  height: 1.5,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
