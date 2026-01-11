import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/obd_metrics_model.dart';
import '../models/obd_dtc_model.dart';

class OBDController extends ChangeNotifier {
  final ValueNotifier<bool> isConnected = ValueNotifier<bool>(true);
  final ValueNotifier<OBDMetricsModel> metrics = ValueNotifier<OBDMetricsModel>(
    OBDMetricsModel(
      rpm: 2200,
      coolantTemp: 195,
      batteryVoltage: 13.7,
      throttlePosition: 36,
    ),
  );
  final ValueNotifier<List<OBDDTCModel>> dtcCodes = ValueNotifier<List<OBDDTCModel>>([
    OBDDTCModel(
      code: 'P0300',
      description: 'Engine Misfire',
      severity: 97,
    ),
    OBDDTCModel(
      code: 'P0171',
      description: 'System Too Lean',
      severity: 68,
    ),
  ]);

  Timer? _updateTimer;

  OBDController() {
    _startSimulation();
  }

  void _startSimulation() {
    // Simulate live data updates
    _updateTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (isConnected.value) {
        _updateMetrics();
      }
    });
  }

  void _updateMetrics() {
    final current = metrics.value;
    // Simulate small variations in metrics
    final newMetrics = OBDMetricsModel(
      rpm: current.rpm + (200 - (400 * (DateTime.now().millisecond % 1000) / 1000)),
      coolantTemp: current.coolantTemp.clamp(180, 210),
      batteryVoltage: current.batteryVoltage + ((DateTime.now().millisecond % 20) - 10) / 10,
      throttlePosition: current.throttlePosition.clamp(0, 100),
    );
    metrics.value = newMetrics;
  }

  void uploadOBDData(String filePath) {
    // Handle file upload logic
    // This would typically parse the file and update metrics/dtcCodes
    debugPrint('Uploading OBD data from: $filePath');
  }

  void connect() {
    isConnected.value = true;
    _startSimulation();
  }

  void disconnect() {
    isConnected.value = false;
    _updateTimer?.cancel();
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    isConnected.dispose();
    metrics.dispose();
    dtcCodes.dispose();
    super.dispose();
  }
}
