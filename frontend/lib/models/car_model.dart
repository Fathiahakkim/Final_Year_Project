class CarModel {
  final String id;
  final String make;
  final String model;
  final int year;
  final String imageUrl;
  final String healthStatus; // "HEALTHY", "WARNING", "CRITICAL"

  CarModel({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.imageUrl,
    required this.healthStatus,
  });

  String get fullName => '$make $model $year';
}
