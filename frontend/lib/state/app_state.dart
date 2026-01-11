import 'package:flutter/foundation.dart';
import '../models/car_model.dart';
import '../models/diagnosis_history_entry.dart';
import '../services/car_storage_service.dart';

class AppState extends ChangeNotifier {
  final List<CarModel> cars;
  final List<DiagnosisHistoryEntry> diagnosisHistory;
  int? selectedHistoryIndex;
  final CarStorageService _storageService = CarStorageService();

  AppState()
      : cars = [],
        diagnosisHistory = [],
        selectedHistoryIndex = null {
    _loadCars();
  }

  CarModel? get primaryCar => cars.isNotEmpty ? cars.first : null;

  /// Load cars from local storage on app start
  Future<void> _loadCars() async {
    final loadedCars = await _storageService.loadCars();
    cars.clear();
    cars.addAll(loadedCars);
    notifyListeners();
  }

  void addCar(CarModel car) {
    cars.add(car);
    notifyListeners();
    _storageService.saveCars(cars);
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

