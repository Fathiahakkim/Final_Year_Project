import 'package:flutter/material.dart';
import '../state/app_state.dart';

class HomeScreen extends StatelessWidget {
  final AppState appState;
  final Function(int) onNavigate;

  const HomeScreen({
    super.key,
    required this.appState,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF251B7C), // Dark blue/black background
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome back section
              const Text(
                'Welcome back!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              
              // Action cards row
              Row(
                children: [
                  Expanded(
                    child: _ActionCard(
                      customIcon: _DiagnoseIcon(),
                      title: 'Diagnose',
                      description: 'Start diagnosing your vehicle issues.',
                      onTap: () {
                        // Navigate to Diagnose screen (index 2)
                        onNavigate(2);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _ActionCard(
                      customIcon: _LiveDataIcon(),
                      title: 'Live Data',
                      description: 'View Real-time engine insight by OBD data.',
                      onTap: () {
                        // Navigate to OBD Data screen (index 3)
                        onNavigate(3);
                      },
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // My Cars section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'My Cars',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to My Cars screen (index 1)
                      onNavigate(1);
                    },
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Cars carousel
              ListenableBuilder(
                listenable: appState,
                builder: (context, child) {
                  if (appState.cars.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3F3CBF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Text(
                          'No cars registered yet',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  }
                  
                  return SizedBox(
                    height: 280,
                    child: PageView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: appState.cars.length,
                      itemBuilder: (context, index) {
                        final car = appState.cars[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            right: index < appState.cars.length - 1 ? 16 : 0,
                          ),
                          child: _CarCard(
                            car: car,
                            onTap: () {
                              // Navigate to My Cars screen (index 1)
                              onNavigate(1);
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final Widget customIcon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _ActionCard({
    required this.customIcon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF3F3CBF),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: customIcon,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Diagnose Icon - Car with magnifying glass
class _DiagnoseIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      height: 28,
      child: Stack(
        children: [
          // Car icon
          Positioned(
            left: 2,
            bottom: 2,
            child: Icon(
              Icons.directions_car,
              color: Colors.blue,
              size: 18,
            ),
          ),
          // Magnifying glass overlay
          Positioned(
            right: 0,
            top: 0,
            child: CustomPaint(
              size: const Size(14, 14),
              painter: _MagnifyingGlassPainter(),
            ),
          ),
        ],
      ),
    );
  }
}

class _MagnifyingGlassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.blue;

    // Draw magnifying glass circle
    canvas.drawCircle(
      Offset(size.width * 0.6, size.height * 0.6),
      size.width * 0.35,
      paint,
    );

    // Draw handle
    final handlePath = Path();
    handlePath.moveTo(size.width * 0.85, size.height * 0.85);
    handlePath.lineTo(size.width, size.height);
    canvas.drawPath(handlePath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom Live Data Icon - Colorful graph
class _LiveDataIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      height: 28,
      child: CustomPaint(
        painter: _GraphIconPainter(),
      ),
    );
  }
}

class _GraphIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    // Draw colorful graph lines
    final path1 = Path();
    path1.moveTo(2, size.height - 8);
    path1.lineTo(6, size.height - 4);
    path1.lineTo(10, size.height - 12);
    path1.lineTo(14, size.height - 6);
    path1.lineTo(18, size.height - 10);
    paint.color = Colors.orange;
    canvas.drawPath(path1, paint);

    final path2 = Path();
    path2.moveTo(2, size.height - 4);
    path2.lineTo(6, size.height - 8);
    path2.lineTo(10, size.height - 2);
    path2.lineTo(14, size.height - 8);
    path2.lineTo(18, size.height - 4);
    paint.color = Colors.green;
    canvas.drawPath(path2, paint);

    final path3 = Path();
    path3.moveTo(4, size.height - 6);
    path3.lineTo(8, size.height - 10);
    path3.lineTo(12, size.height - 4);
    path3.lineTo(16, size.height - 12);
    path3.lineTo(20, size.height - 8);
    paint.color = Colors.blue;
    canvas.drawPath(path3, paint);

    final path4 = Path();
    path4.moveTo(4, size.height - 10);
    path4.lineTo(8, size.height - 6);
    path4.lineTo(12, size.height - 8);
    path4.lineTo(16, size.height - 4);
    path4.lineTo(20, size.height - 6);
    paint.color = Colors.purple;
    canvas.drawPath(path4, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CarCard extends StatelessWidget {
  final dynamic car;
  final VoidCallback onTap;

  const _CarCard({
    required this.car,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF271F98), // Dark Blue left
              Color(0xFFD85876), // Pink right
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  car.fullName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 18,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Car image container
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2), 
                    width: 1,
                  ),
                  gradient: const RadialGradient(
                    center: Alignment.center,
                    radius: 1.0,
                    colors: [
                      Color(0xFF7B68EE), // Bright center blue/purple
                      Color(0xFF271F98), // Dark edges
                    ],
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(11), // 1px less to fit inside border
                  child: Image.asset(
                    car.imageUrl.isNotEmpty
                        ? car.imageUrl
                        : 'assets/cars/default_car.jpg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.directions_car,
                        size: 80,
                        color: Colors.white70,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
