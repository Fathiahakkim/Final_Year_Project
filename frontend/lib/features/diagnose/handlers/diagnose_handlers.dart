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

  Future<void> onSend() async {
    final message = controller.messageController.text.trim();

    if (message.isEmpty) {
      return;
    }

    // Update the complaint field with the message that was sent
    controller.complaintController.text = message;
    controller.setDisplayedComplaint(message);
    controller.setMessageSent(
      true,
    ); // Mark message as sent to keep card expanded

    // Clear the message input immediately
    controller.messageController.clear();

    // Set loading state
    controller.setLoading(true);

    try {
      // Send to backend - use the message as the complaint for diagnosis
      final diagnosisResult = await _diagnosisService.diagnoseComplaint(
        message,
      );

      // Sort issues by confidence (highest first)
      final sortedIssues =
          diagnosisResult.issues.toList()
            ..sort((a, b) => b.confidence.compareTo(a.confidence));

      final sortedResult = DiagnosisResult(
        issues: sortedIssues,
        timestamp: diagnosisResult.timestamp,
      );

      controller.setDiagnosisResult(sortedResult);

      // Append to diagnosis history
      if (sortedResult.issues.isNotEmpty) {
        appState.addDiagnosisHistoryEntry(
          DiagnosisHistoryEntry(
            complaintText: message,
            primaryFaultName: sortedResult.issues.first.name,
            confidence: sortedResult.issues.first.confidence,
            timestamp: sortedResult.timestamp,
          ),
        );
      }
    } catch (e) {
      // For testing: Show dummy data if backend fails
      // TODO: Remove this dummy data when backend is connected
      await Future.delayed(const Duration(seconds: 2)); // Simulate delay

      final dummyResult = DiagnosisResult(
        issues: [
          DiagnosedIssue(
            name: 'Engine Misfire',
            confidence: 0.97,
            severity: IssueSeverity.critical,
          ),
          DiagnosedIssue(
            name: 'Faulty Spark Plug',
            confidence: 0.72,
            severity: IssueSeverity.warning,
          ),
          DiagnosedIssue(
            name: 'Fuel Injector Issue',
            confidence: 0.65,
            severity: IssueSeverity.warning,
          ),
        ],
        timestamp: DateTime.now(),
      );

      controller.setDiagnosisResult(dummyResult);

      // Append to diagnosis history
      if (dummyResult.issues.isNotEmpty) {
        appState.addDiagnosisHistoryEntry(
          DiagnosisHistoryEntry(
            complaintText: message,
            primaryFaultName: dummyResult.issues.first.name,
            confidence: dummyResult.issues.first.confidence,
            timestamp: dummyResult.timestamp,
          ),
        );
      }

      // Uncomment below when backend is ready:
      // controller.setError(e.toString());
      // print('Diagnosis error: $e');
    }
  }

  void dispose() {
    // Handlers only coordinate, don't own resources
  }
}
