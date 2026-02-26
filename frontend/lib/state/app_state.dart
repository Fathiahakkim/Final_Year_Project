import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/car_model.dart';
import '../models/car.dart';
import '../models/diagnosis_history_entry.dart';

class AppState extends ChangeNotifier {
  final List<CarModel> cars;
  final List<DiagnosisHistoryEntry> diagnosisHistory;
  int? selectedHistoryIndex;
  AppState()
      : cars = [],
        diagnosisHistory = [],
        selectedHistoryIndex = null;

  CarModel? get primaryCar => cars.isNotEmpty ? cars.first : null;

  /// Hydrate in-memory state from Hive on app start.
  /// Call this once in main() after the Hive box is opened.
  void loadFromHive() {
    final box = Hive.box<Car>('carsBox');
    final savedCars = box.values.toList();

    if (savedCars.isEmpty) return;

    cars.clear();

    // Convert Hive Car objects → in-memory CarModel objects
    final converted = savedCars.map((car) => CarModel(
      id: car.id,
      make: car.make,
      model: car.model,
      year: int.tryParse(car.year) ?? 0,
      licensePlate: car.licensePlate,
      imageUrl: car.imagePath,
      healthStatus: 'HEALTHY',
    )).toList();

    // Put the selected car first so primaryCar returns it
    final selectedIndex = savedCars.indexWhere((c) => c.isSelected);
    if (selectedIndex > 0) {
      final selected = converted.removeAt(selectedIndex);
      converted.insert(0, selected);
    }

    cars.addAll(converted);
    notifyListeners();
  }

  void addCar(CarModel car) {
    cars.add(car);
    notifyListeners();
  }

  /// Persist car selection to Hive and reorder in-memory list.
  void selectCar(String carId) {
    // --- Update Hive ---
    final box = Hive.box<Car>('carsBox');
    for (final hiveCar in box.values) {
      final shouldSelect = hiveCar.id == carId;
      if (hiveCar.isSelected != shouldSelect) {
        hiveCar.isSelected = shouldSelect;
        hiveCar.save(); // persists change to disk
      }
    }

    // --- Reorder in-memory list ---
    final selectedIndex = cars.indexWhere((c) => c.id == carId);
    if (selectedIndex > 0) {
      final selected = cars.removeAt(selectedIndex);
      cars.insert(0, selected);
    }
    notifyListeners();
  }

  /// Delete a car from Hive and in-memory list.
  /// If the deleted car was selected, promote the next available car.
  void deleteCar(String carId) {
    final box = Hive.box<Car>('carsBox');
    final hiveCar = box.get(carId);
    final wasSelected = hiveCar?.isSelected ?? false;

    // Remove from Hive
    box.delete(carId);

    // Remove from in-memory list
    cars.removeWhere((c) => c.id == carId);

    // If deleted car was selected, select the next available car
    if (wasSelected && cars.isNotEmpty) {
      final nextHiveCar = box.get(cars.first.id);
      if (nextHiveCar != null) {
        nextHiveCar.isSelected = true;
        nextHiveCar.save();
      }
    }

    notifyListeners();
  }

  void addDiagnosisHistoryEntry(DiagnosisHistoryEntry entry) {
    diagnosisHistory.add(entry);
    selectedHistoryIndex = diagnosisHistory.length - 1;
    notifyListeners();
  }

  void updateMostRecentFeedbackStatus(FeedbackStatus status) {
    if (selectedHistoryIndex == null) return;
    if (diagnosisHistory.isEmpty) return;
    if (selectedHistoryIndex! < 0 || selectedHistoryIndex! >= diagnosisHistory.length) return;
    
    final targetIndex = selectedHistoryIndex!;
    final targetEntry = diagnosisHistory[targetIndex];
    
    final updatedEntry = DiagnosisHistoryEntry(
      complaintText: targetEntry.complaintText,
      primaryFaultName: targetEntry.primaryFaultName,
      confidence: targetEntry.confidence,
      timestamp: targetEntry.timestamp,
      feedbackStatus: status,
    );
    
    diagnosisHistory[targetIndex] = updatedEntry;
    notifyListeners();
  }

  void setSelectedHistoryIndex(int? index) {
    selectedHistoryIndex = index;
    notifyListeners();
  }
}

