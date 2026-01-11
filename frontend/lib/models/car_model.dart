class CarModel {
  final String id;
  final String make;
  final String model;
  final int year;
  final String licensePlate;
  final String imageUrl;
  final String healthStatus; // "HEALTHY", "WARNING", "CRITICAL"

  CarModel({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.licensePlate,
    required this.imageUrl,
    required this.healthStatus,
  });

  String get fullName => '$make $model $year';

  /// Convert CarModel to JSON map for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'make': make,
      'model': model,
      'year': year,
      'licensePlate': licensePlate,
      'imageUrl': imageUrl,
      'healthStatus': healthStatus,
    };
  }

  /// Create CarModel from JSON map
  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'] as String,
      make: json['make'] as String,
      model: json['model'] as String,
      year: json['year'] as int,
      licensePlate: json['licensePlate'] as String,
      imageUrl: json['imageUrl'] as String? ?? '',
      healthStatus: json['healthStatus'] as String? ?? 'HEALTHY',
    );
  }
}
