import 'package:hive/hive.dart';

part 'car.g.dart';

@HiveType(typeId: 0)
class Car extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String make;

  @HiveField(2)
  final String model;

  @HiveField(3)
  final String year;

  @HiveField(4)
  final String licensePlate;

  @HiveField(5)
  final String imagePath;

  @HiveField(6)
  bool isSelected;

  Car({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.licensePlate,
    required this.imagePath,
    this.isSelected = false,
  });
}
