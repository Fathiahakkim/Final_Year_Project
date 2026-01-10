import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/diagnose_theme.dart';

class VoiceButton extends StatefulWidget {
  final VoidCallback? onTap;

  const VoiceButton({super.key, this.onTap});

  @override
  State<VoiceButton> createState() => _VoiceButtonState();
}

class _VoiceButtonState extends State<VoiceButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
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
    return GestureDetector(
      onTap: widget.onTap ?? () {},
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  DiagnoseTheme.accentBlue,
                  DiagnoseTheme.accentBlue.withBlue(230),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: DiagnoseTheme.accentBlue.withOpacity(
                    0.6 * _glowAnimation.value,
                  ),
                  blurRadius: 50 * _pulseAnimation.value,
                  spreadRadius: 6 * _pulseAnimation.value,
                ),
                BoxShadow(
                  color: DiagnoseTheme.accentBlue.withOpacity(
                    0.5 * _glowAnimation.value,
                  ),
                  blurRadius: 45 * _pulseAnimation.value,
                  spreadRadius: 5 * _pulseAnimation.value,
                ),
                BoxShadow(
                  color: DiagnoseTheme.accentBlue.withOpacity(
                    0.4 * _glowAnimation.value,
                  ),
                  blurRadius: 35 * _pulseAnimation.value,
                  spreadRadius: 3 * _pulseAnimation.value,
                ),
                BoxShadow(
                  color: DiagnoseTheme.accentBlue.withOpacity(
                    0.3 * _glowAnimation.value,
                  ),
                  blurRadius: 25 * _pulseAnimation.value,
                  spreadRadius: 2 * _pulseAnimation.value,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withOpacity(0.3 * _glowAnimation.value),
                          Colors.white.withOpacity(0.0),
                        ],
                        stops: const [0.0, 0.7],
                      ),
                    ),
                  ),
                ),
                ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white,
                        Colors.white.withOpacity(0.7),
                        Colors.white,
                      ],
                      stops: [
                        0.0,
                        0.5 +
                            (math.sin(
                                  _animationController.value * 2 * math.pi,
                                ) *
                                0.3),
                        1.0,
                      ],
                    ).createShader(bounds);
                  },
                  child: const Icon(Icons.mic, color: Colors.white, size: 64),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
