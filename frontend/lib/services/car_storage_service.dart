import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/car_model.dart';

/// Service responsible for persisting and loading car data from local storage
class CarStorageService {
  static const String _carsKey = 'saved_cars';

  /// Load all cars from local storage
  Future<List<CarModel>> loadCars() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final carsJson = prefs.getString(_carsKey);
      
      if (carsJson == null || carsJson.isEmpty) {
        return [];
      }

      final List<dynamic> carsList = json.decode(carsJson);
      return carsList
          .map((carJson) => CarModel.fromJson(carJson as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error loading cars from storage: $e');
      return [];
    }
  }

  /// Save all cars to local storage
  Future<bool> saveCars(List<CarModel> cars) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final carsJson = json.encode(cars.map((car) => car.toJson()).toList());
      return await prefs.setString(_carsKey, carsJson);
    } catch (e) {
      debugPrint('Error saving cars to storage: $e');
      return false;
    }
  }

  /// Clear all saved cars from storage
  Future<bool> clearCars() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_carsKey);
    } catch (e) {
      debugPrint('Error clearing cars from storage: $e');
      return false;
    }
  }
}
