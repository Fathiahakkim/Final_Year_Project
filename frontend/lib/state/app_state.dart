import '../models/car_model.dart';

class AppState {
  final List<CarModel> cars;

  AppState() : cars = [
    CarModel(
      id: '1',
      make: 'Honda',
      model: 'CITY',
      year: 2020,
      imageUrl: '', // Will use placeholder or asset
      healthStatus: 'HEALTHY',
    ),
  ];

  CarModel? get primaryCar => cars.isNotEmpty ? cars.first : null;
}

