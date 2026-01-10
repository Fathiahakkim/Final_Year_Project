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
  late Animation<double> _glowAnimation;

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

    // Pulsing glow animation
    _glowAnimation = Tween<double>(begin: 0.4, end: 0.9).animate(
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
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // Outer animated glow layers (reflection on dark surface)
                  Container(
                    width: 240,
                    height: 160,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: DiagnoseTheme.accentBlue.withOpacity(
                            _glowAnimation.value * 0.6,
                          ),
                          blurRadius: 60 * _glowAnimation.value,
                          spreadRadius: 20,
                          offset: const Offset(0, 15),
                        ),
                        BoxShadow(
                          color: const Color(
                            0xFF00BFFF,
                          ).withOpacity(_glowAnimation.value * 0.4),
                          blurRadius: 80 * _glowAnimation.value,
                          spreadRadius: 30,
                          offset: const Offset(0, 20),
                        ),
                      ],
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  // Main car container with real car image
                  Container(
                    width: 220,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: DiagnoseTheme.accentBlue.withOpacity(
                            0.5 * _glowAnimation.value,
                          ),
                          blurRadius: 30,
                          spreadRadius: 5,
                          offset: const Offset(0, 10),
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.black.withOpacity(0.2),
                              Colors.black.withOpacity(0.4),
                            ],
                          ),
                        ),
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
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color(0xFF1A1A2E),
                                    const Color(0xFF16213E),
                                  ],
                                ),
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
                  ),
                  // Additional top glow effect
                  Transform(
                    transform:
                        Matrix4.identity()
                          ..rotateY(_rotationAnimation.value * 0.3),
                    child: Container(
                      width: 220,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: RadialGradient(
                          center: Alignment(
                            -0.2 + _rotationAnimation.value * 0.5,
                            -0.4,
                          ),
                          radius: 0.7,
                          colors: [
                            DiagnoseTheme.accentBlue.withOpacity(
                              0.15 * _glowAnimation.value,
                            ),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
