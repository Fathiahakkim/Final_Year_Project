import 'package:flutter/material.dart';
import '../theme/obd_theme.dart';

class OBDAdapterGraphic extends StatelessWidget {
  const OBDAdapterGraphic({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: OBDTheme.adapterGraphicSize,
        height: OBDTheme.adapterGraphicSize * 0.6,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1F3A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: CustomPaint(
          painter: _OBDAdapterPainter(),
        ),
      ),
    );
  }
}

class _OBDAdapterPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.grey.shade700;

    final pinPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.grey.shade800;

    // Draw adapter body
    final adapterRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.1, size.height * 0.2, size.width * 0.8, size.height * 0.6),
      const Radius.circular(4),
    );
    canvas.drawRRect(adapterRect, paint);

    // Draw pins (two rows)
    final pinWidth = size.width * 0.04;
    final pinHeight = size.height * 0.15;
    final pinSpacing = size.width * 0.08;
    final startX = size.width * 0.15;
    final topRowY = size.height * 0.35;
    final bottomRowY = size.height * 0.6;

    // Top row pins
    for (int i = 0; i < 8; i++) {
      final pinRect = Rect.fromLTWH(
        startX + (pinSpacing * i),
        topRowY,
        pinWidth,
        pinHeight,
      );
      canvas.drawRect(pinRect, pinPaint);
    }

    // Bottom row pins
    for (int i = 0; i < 8; i++) {
      final pinRect = Rect.fromLTWH(
        startX + (pinSpacing * i),
        bottomRowY,
        pinWidth,
        pinHeight,
      );
      canvas.drawRect(pinRect, pinPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
