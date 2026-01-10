import 'package:flutter/material.dart';

class HolographicCarPainter extends CustomPainter {
  final double glowIntensity;
  final double rotation;

  HolographicCarPainter({required this.glowIntensity, this.rotation = 0.0});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.0;

    // Define car dimensions
    final carWidth = size.width * 0.8;
    final carHeight = size.height * 0.7;
    final wheelRadius = carWidth * 0.08;

    // Apply rotation transform
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);

    // Main car body outline (glowing blue)
    _drawCarBody(canvas, carWidth, carHeight, paint);

    // Internal structure lines (engine, chassis, seats)
    _drawInternalStructures(canvas, carWidth, carHeight, paint);

    // Wheels
    _drawWheels(canvas, carWidth, carHeight, wheelRadius, paint);

    // Headlights (bright white)
    _drawHeadlights(canvas, carWidth, carHeight, paint);

    // Engine glow (orange accent)
    _drawEngineGlow(canvas, carWidth, carHeight, paint);

    canvas.restore();
  }

  void _drawCarBody(Canvas canvas, double width, double height, Paint paint) {
    final path = Path();

    // Car body outline with futuristic design
    // Front hood
    path.moveTo(-width * 0.45, -height * 0.25);
    path.quadraticBezierTo(
      -width * 0.3,
      -height * 0.35,
      -width * 0.15,
      -height * 0.3,
    );

    // Windshield
    path.quadraticBezierTo(
      width * 0.05,
      -height * 0.32,
      width * 0.15,
      -height * 0.2,
    );

    // Roof
    path.quadraticBezierTo(
      width * 0.25,
      -height * 0.25,
      width * 0.3,
      -height * 0.15,
    );

    // Rear
    path.quadraticBezierTo(
      width * 0.35,
      -height * 0.1,
      width * 0.4,
      -height * 0.05,
    );

    // Rear bumper
    path.lineTo(width * 0.45, height * 0.15);
    path.quadraticBezierTo(
      width * 0.4,
      height * 0.25,
      width * 0.3,
      height * 0.3,
    );

    // Bottom rear
    path.quadraticBezierTo(
      width * 0.15,
      height * 0.35,
      width * 0.05,
      height * 0.3,
    );

    // Front wheel well
    path.quadraticBezierTo(
      -width * 0.15,
      height * 0.35,
      -width * 0.3,
      height * 0.3,
    );

    // Front bumper
    path.quadraticBezierTo(
      -width * 0.4,
      height * 0.25,
      -width * 0.45,
      height * 0.1,
    );

    // Front section
    path.quadraticBezierTo(
      -width * 0.42,
      -height * 0.1,
      -width * 0.45,
      -height * 0.25,
    );

    path.close();

    // Draw main outline with glowing blue
    paint
      ..color = Color.lerp(
        const Color(0xFF00BFFF),
        const Color(0xFF0080FF),
        glowIntensity,
      )!.withOpacity(0.9)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8 * glowIntensity);

    canvas.drawPath(path, paint);

    // Draw secondary outline for more glow
    paint
      ..strokeWidth = 2.0
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 15 * glowIntensity);

    canvas.drawPath(path, paint);

    // Draw inner outline
    paint
      ..strokeWidth = 1.5
      ..color = const Color(0xFF00D9FF).withOpacity(0.6)
      ..maskFilter = null;

    canvas.drawPath(path, paint);
  }

  void _drawInternalStructures(
    Canvas canvas,
    double width,
    double height,
    Paint paint,
  ) {
    // Engine block
    paint
      ..color = const Color(0xFF4A90E2).withOpacity(0.5)
      ..strokeWidth = 2.0;

    final enginePath = Path();
    enginePath.addRect(
      Rect.fromCenter(
        center: Offset(-width * 0.15, height * 0.05),
        width: width * 0.25,
        height: height * 0.2,
      ),
    );

    canvas.drawPath(enginePath, paint);

    // Chassis lines
    paint.color = const Color(0xFF4A90E2).withOpacity(0.4);
    paint.strokeWidth = 1.5;

    // Horizontal chassis lines
    canvas.drawLine(
      Offset(-width * 0.3, height * 0.1),
      Offset(width * 0.3, height * 0.1),
      paint,
    );

    canvas.drawLine(
      Offset(-width * 0.25, -height * 0.05),
      Offset(width * 0.25, -height * 0.05),
      paint,
    );

    // Vertical support lines
    canvas.drawLine(
      Offset(-width * 0.1, -height * 0.2),
      Offset(-width * 0.1, height * 0.25),
      paint,
    );

    canvas.drawLine(
      Offset(width * 0.1, -height * 0.2),
      Offset(width * 0.1, height * 0.25),
      paint,
    );

    // Seat outlines
    paint.color = const Color(0xFF4A90E2).withOpacity(0.3);
    final seatPath = Path();
    seatPath.addRect(
      Rect.fromCenter(
        center: Offset(0, -height * 0.05),
        width: width * 0.2,
        height: height * 0.15,
      ),
    );
    canvas.drawPath(seatPath, paint);
  }

  void _drawWheels(
    Canvas canvas,
    double width,
    double height,
    double radius,
    Paint paint,
  ) {
    paint
      ..color = const Color(0xFF4A90E2).withOpacity(0.7)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    // Front wheel
    final frontWheel = Offset(-width * 0.25, height * 0.25);
    canvas.drawCircle(frontWheel, radius, paint);

    // Wheel rim details
    paint.strokeWidth = 1.5;
    canvas.drawCircle(frontWheel, radius * 0.7, paint);
    canvas.drawCircle(frontWheel, radius * 0.4, paint);

    // Rear wheel
    final rearWheel = Offset(width * 0.25, height * 0.25);
    paint.strokeWidth = 2.5;
    canvas.drawCircle(rearWheel, radius, paint);

    // Wheel rim details
    paint.strokeWidth = 1.5;
    canvas.drawCircle(rearWheel, radius * 0.7, paint);
    canvas.drawCircle(rearWheel, radius * 0.4, paint);
  }

  void _drawHeadlights(
    Canvas canvas,
    double width,
    double height,
    Paint paint,
  ) {
    // Bright white headlights with glow
    paint
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12);

    final headlightLeft = Offset(-width * 0.35, -height * 0.2);
    final headlightRight = Offset(-width * 0.3, -height * 0.18);

    canvas.drawCircle(headlightLeft, width * 0.06, paint);
    canvas.drawCircle(headlightRight, width * 0.06, paint);

    // Inner bright core
    paint.maskFilter = null;
    canvas.drawCircle(headlightLeft, width * 0.03, paint);
    canvas.drawCircle(headlightRight, width * 0.03, paint);
  }

  void _drawEngineGlow(
    Canvas canvas,
    double width,
    double height,
    Paint paint,
  ) {
    // Orange glow from engine bay
    paint
      ..color = const Color(0xFFFF6B35).withOpacity(0.6 * glowIntensity)
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 15);

    final engineCenter = Offset(-width * 0.15, height * 0.05);
    canvas.drawCircle(engineCenter, width * 0.12, paint);

    // Core glow
    paint
      ..color = const Color(0xFFFF8C42).withOpacity(0.8 * glowIntensity)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawCircle(engineCenter, width * 0.06, paint);
  }

  @override
  bool shouldRepaint(HolographicCarPainter oldDelegate) {
    return oldDelegate.glowIntensity != glowIntensity ||
        oldDelegate.rotation != rotation;
  }
}
