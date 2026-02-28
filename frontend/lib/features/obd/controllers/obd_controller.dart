import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import '../models/obd_metrics_model.dart';
import '../models/obd_dtc_model.dart';
import '../models/obd_prediction_model.dart';
import '../services/obd_api_service.dart';
import '../../../core/obd_cache.dart';
import '../../../services/diagnosis_service.dart';

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

  // ── OBD prediction state ────────────────────────────────────────────
  final OBDApiService _apiService = OBDApiService();

  final ValueNotifier<bool> isUploading = ValueNotifier<bool>(false);
  final ValueNotifier<String?> uploadedFileName = ValueNotifier<String?>(null);
  final ValueNotifier<OBDPredictionResult?> predictionResult =
      ValueNotifier<OBDPredictionResult?>(null);
  final ValueNotifier<String?> uploadError = ValueNotifier<String?>(null);
  final ValueNotifier<bool> isPredicting = ValueNotifier<bool>(false);

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

  // ── File picking + upload (single source of truth) ──────────────────
  /// Opens the file picker, uploads the selected CSV to the backend,
  /// and stores the prediction result. Widgets should call this method
  /// instead of handling file picking themselves.
  Future<void> pickAndUploadCSV() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        withData: true, // ensures bytes are loaded on all platforms
      );

      if (result == null || result.files.isEmpty) {
        debugPrint('[OBD] File picker cancelled.');
        return;
      }

      final pickedFile = result.files.first;
      
      // Reset previous state
      uploadError.value = null;
      predictionResult.value = null;
      uploadedFileName.value = pickedFile.name;
      isUploading.value = true;

      if (pickedFile.bytes != null) {
        final parsedFeatureMap = _parseCSV(pickedFile.bytes!);
        
        if (parsedFeatureMap.isEmpty) {
          uploadError.value = 'Failed to parse CSV or file is empty.';
        } else {
          ObdCache.set(parsedFeatureMap);
          debugPrint('[OBD] Cached ${parsedFeatureMap.length} features globally.');
          // Update UI metrics state based on parsed data (Optional but good UX)
          if (parsedFeatureMap.containsKey('rpm_mean')) {
             metrics.value = OBDMetricsModel(
               rpm: parsedFeatureMap['rpm_mean']?.toDouble() ?? metrics.value.rpm,
               coolantTemp: parsedFeatureMap['coolant_mean']?.toDouble() ?? metrics.value.coolantTemp,
               batteryVoltage: parsedFeatureMap['battery_voltage_mean'] ?? metrics.value.batteryVoltage,
               throttlePosition: parsedFeatureMap['throttle_mean']?.toDouble() ?? metrics.value.throttlePosition,
             );
          }
        }
      } else {
        throw Exception('Cannot read selected file — bytes are null.');
      }
    } catch (e) {
      uploadError.value = 'Unexpected error: $e';
      debugPrint('[OBD] Unexpected error: $e');
      uploadedFileName.value = null;
    } finally {
      isUploading.value = false;
      notifyListeners();
    }
  }

  Future<void> sendOBDData() async {
    if (ObdCache.latestObd == null) return;
    try {
      isPredicting.value = true;
      uploadError.value = null;
      predictionResult.value = null;

      // Pass empty string, backend logic maps "" to None/null for hybrid execution
      final diagnosisService = DiagnosisService();
      final diagResult = await diagnosisService.diagnoseComplaint('');

      // Map global DiagnosisResult back into local OBD card UI shape effortlessly
      final converted = OBDPredictionResult(
        source: 'OBD-Only Inference',
        topFaults: diagResult.predictions
            .map((p) => OBDFaultPrediction(fault: p.name, confidence: p.confidence))
            .toList(),
      );

      predictionResult.value = converted;
    } catch (e) {
      uploadError.value = 'Prediction failed: $e';
    } finally {
      isPredicting.value = false;
    }
  }

  void clearUploadedFile() {
    uploadedFileName.value = null;
    predictionResult.value = null;
    uploadError.value = null;
    ObdCache.clear();
    
    // Reset metrics to an empty default state
    metrics.value = OBDMetricsModel(
      rpm: 2200,
      coolantTemp: 195,
      batteryVoltage: 13.7,
      throttlePosition: 36,
    );
    notifyListeners();
  }

  Map<String, double> _parseCSV(Uint8List bytes) {
    try {
      final String content = String.fromCharCodes(bytes);
      final List<String> lines = content.split(RegExp(r'\r?\n')).where((line) => line.trim().isNotEmpty).toList();
      if (lines.length < 2) return {};
      
      final List<String> headers = lines[0].split(',').map((e) => e.trim()).toList();
      final Map<String, List<double>> colValues = {for (var h in headers) h: []};
      
      for (int i = 1; i < lines.length; i++) {
        final List<String> values = lines[i].split(',');
        for (int j = 0; j < headers.length; j++) {
          if (j < values.length) {
            final val = double.tryParse(values[j].trim());
            if (val != null) colValues[headers[j]]?.add(val);
          }
        }
      }
      
      final Map<String, double> featureMap = {};
      final requiredColumns = [
        "rpm_mean", "rpm_std", "coolant_mean", "coolant_max", "speed_mean", 
        "throttle_mean", "engine_load_mean", "fuel_trim_mean", "o2_var", "battery_voltage_mean"
      ];
      
      for (final col in requiredColumns) {
        if (colValues.containsKey(col) && colValues[col]!.isNotEmpty) {
          final sum = colValues[col]!.reduce((a, b) => a + b);
          featureMap[col] = sum / colValues[col]!.length; // Mean
        }
      }
      return featureMap;
    } catch (e) {
      debugPrint('[OBD] CSV parsing error: $e');
      return {};
    }
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
    isUploading.dispose();
    uploadedFileName.dispose();
    predictionResult.dispose();
    uploadError.dispose();
    isPredicting.dispose();
    super.dispose();
  }
}
