import 'package:flutter/material.dart';
import '../../../state/app_state.dart';

class EmptyCarCard extends StatelessWidget {
  final AppState appState;
  final Function(String carId)? onSelectCar;

  const EmptyCarCard({super.key, required this.appState, this.onSelectCar});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, child) {
        if (appState.cars.isEmpty) {
          // Show empty state
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * 0.25,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Simple car icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.directions_car,
                      size: 48,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // "No cars added yet" text
                  const Text(
                    'No cars added yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Description text
                  Text(
                    'Add your first vehicle to enable diagnostics.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          // Show saved cars
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: appState.cars.asMap().entries.map((entry) {
                final index = entry.key;
                final car = entry.value;
                final isSelected = index == 0; // first car = selected

                return Dismissible(
                  key: ValueKey(car.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    appState.deleteCar(car.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${car.fullName} deleted'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  background: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 24),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      if (!isSelected && onSelectCar != null) {
                        onSelectCar!(car.id);
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFE3F2FD)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected
                            ? Border.all(
                                color: const Color(0xFF1976D2),
                                width: 1.5,
                              )
                            : null,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    car.imageUrl.isNotEmpty
                                        ? car.imageUrl
                                        : 'assets/cars/default_car.jpg',
                                    height: 48,
                                    width: 48,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.directions_car,
                                        color: Colors.grey[600],
                                        size: 28,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      car.fullName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF212121),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'License Plate: ${car.licensePlate}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle,
                                  color: Color(0xFF1976D2),
                                  size: 24,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }
}
