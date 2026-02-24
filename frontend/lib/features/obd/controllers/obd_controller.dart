import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import '../models/obd_metrics_model.dart';
import '../models/obd_dtc_model.dart';
import '../models/obd_prediction_model.dart';
import '../services/obd_api_service.dart';

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
  final ValueNotifier<OBDPredictionResult?> predictionResult =
      ValueNotifier<OBDPredictionResult?>(null);
  final ValueNotifier<String?> uploadError = ValueNotifier<String?>(null);

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
      final fileName = pickedFile.name;

      debugPrint('[OBD] Platform: kIsWeb=$kIsWeb');
      debugPrint('[OBD] File name: $fileName');
      debugPrint('[OBD] bytes is null: ${pickedFile.bytes == null}');
      debugPrint('[OBD] path  is null: ${pickedFile.path == null}');

      // Reset previous state
      uploadError.value = null;
      predictionResult.value = null;
      isUploading.value = true;

      OBDPredictionResult prediction;

      if (pickedFile.bytes != null) {
        // Web always, Android sometimes — use bytes
        debugPrint('[OBD] Uploading via bytes (${pickedFile.bytes!.length} bytes)');
        prediction = await _apiService.predictFromBytes(
          pickedFile.bytes!,
          fileName,
        );
      } else if (pickedFile.path != null) {
        // Android/iOS fallback — use file path
        debugPrint('[OBD] Uploading via path: ${pickedFile.path}');
        prediction = await _apiService.predictFromPath(pickedFile.path!);
      } else {
        throw Exception(
          'Cannot read selected file — both bytes and path are null.',
        );
      }

      predictionResult.value = prediction;
      debugPrint('[OBD] Prediction received: ${prediction.topFaults.length} faults');
    } on OBDApiException catch (e) {
      uploadError.value = e.message;
      debugPrint('[OBD] API error: ${e.message}');
    } catch (e) {
      uploadError.value = 'Unexpected error: $e';
      debugPrint('[OBD] Unexpected error: $e');
    } finally {
      isUploading.value = false;
      notifyListeners();
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
    predictionResult.dispose();
    uploadError.dispose();
    super.dispose();
  }
}
