import 'package:flutter/material.dart';
import '../theme/diagnose_theme.dart';

class CarVisual extends StatefulWidget {
  const CarVisual({super.key});

  @override
  State<CarVisual> createState() => _CarVisualState();
}

class _CarVisualState extends State<CarVisual>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    // Subtle rotation animation (Y-axis rotation for 3D effect)
    _rotationAnimation = Tween<double>(begin: -0.05, end: 0.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Breathing/scale animation
    _scaleAnimation = Tween<double>(begin: 0.98, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: DiagnoseTheme.carBottomSpacing),
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform(
              alignment: Alignment.center,
              transform:
                  Matrix4.identity()
                    ..setEntry(3, 2, 0.001) // Perspective
                    ..rotateY(_rotationAnimation.value) // 3D rotation
                    ..scale(_scaleAnimation.value), // Breathing effect
              child: Container(
                width: 220,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/car.png',
                    width: 220,
                    height: 150,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback placeholder if image not found
                      return Container(
                        width: 220,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.transparent,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Placeholder car icon
                            Icon(
                              Icons.directions_car,
                              size: 120,
                              color: DiagnoseTheme.accentBlue.withOpacity(
                                0.5,
                              ),
                            ),
                            // Hint text
                            Positioned(
                              bottom: 20,
                              child: Text(
                                'Add car.png to assets/images/',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 10,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
