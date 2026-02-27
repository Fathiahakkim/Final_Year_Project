import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../theme/my_car_theme.dart';
import '../../../state/app_state.dart';
import '../../../utils/car_glb_map.dart';

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
        final glbPath = resolveCarGlb(selectedCar?.make);

        return Column(
          children: [
            // 3D car model viewer or fallback icon
            SizedBox(
              width: double.infinity,
              height: 160,
              child: selectedCar != null
                  ? ModelViewer(
                      src: glbPath,
                      alt: '${selectedCar.make} ${selectedCar.model}',
                      autoRotate: true,
                      cameraControls: true,
                      disableZoom: false,
                      cameraOrbit: '0deg 75deg 105%',
                      fieldOfView: '30deg',
                      backgroundColor: Colors.transparent,
                    )
                  : Container(
                      width: carIconSize,
                      height: carIconSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.25),
                          width: 2.5,
                        ),
                      ),
                      child: Icon(
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
