import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import '../controllers/diagnose_controller.dart';
import '../../../services/diagnosis_service.dart';
import '../../../models/diagnosis_result_model.dart';
import '../../../models/diagnosis_history_entry.dart';
import '../../../state/app_state.dart';

/// Handlers for diagnose page user interactions.
/// Coordinates between services but does not own lifecycle of services.
class DiagnoseHandlers {
  final DiagnoseController controller;
  final AppState appState;
  final DiagnosisService _diagnosisService = DiagnosisService();

  DiagnoseHandlers(this.controller, this.appState);

  /// Updates complaint text from voice transcription WITHOUT triggering diagnosis.
  /// This function ONLY updates UI state and logs the action.
  void setComplaintTextFromVoice(String text) {
    debugPrint('VOICE UI: setComplaintTextFromVoice called with text: "$text"');
    controller.complaintController.text = text;
    // Explicitly do NOT trigger diagnosis here - only UI update
  }

  void onComplaintChanged(String text) {
    // Text is automatically updated via controller
  }

  Future<void> onSend(BuildContext context) async {
    final message = controller.messageController.text.trim();

    if (message.isEmpty) {
      return;
    }

    controller.complaintController.text = message;
    controller.setDisplayedComplaint(message);
    controller.setMessageSent(true);

    controller.messageController.clear();
    controller.setLoading(true);

    try {
      final diagnosisResult = await _diagnosisService.diagnoseComplaint(message);

      final sortedIssues = diagnosisResult.predictions.toList()
        ..sort((a, b) => b.confidence.compareTo(a.confidence));

      // Re-pack sorted predictions into result
      final sortedResult = DiagnosisResult(
        predictions: sortedIssues,
        highestConfidence: diagnosisResult.highestConfidence,
        weights: diagnosisResult.weights,
        lowConfidence: diagnosisResult.lowConfidence,
        confidenceGap: diagnosisResult.confidenceGap,
        message: diagnosisResult.message,
      );

      controller.setDiagnosisResult(sortedResult);

      if (sortedResult.predictions.isNotEmpty) {
        appState.addDiagnosisHistoryEntry(
          DiagnosisHistoryEntry(
            complaintText: message,
            primaryFaultName: sortedResult.predictions.first.name,
            confidence: sortedResult.predictions.first.confidence,
            timestamp: DateTime.now(),
          ),
        );
      }
    } catch (e) {
      controller.setLoading(false);
      if (e is DiagnosisException && e.statusCode == 400) {
        // Do not set error text in card, just show snackbar
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter a valid vehicle complaint.')),
          );
        }
      } else {
        controller.setError('Backend not connected');
      }
      debugPrint('Diagnosis error: $e');
    }
  }

  void dispose() {
    // Handlers only coordinate, don't own resources
  }
}
