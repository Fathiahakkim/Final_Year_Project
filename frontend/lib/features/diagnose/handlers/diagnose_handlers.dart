import '../controllers/diagnose_controller.dart';
import '../../../services/diagnosis_service.dart';
import '../../../models/diagnosis_result_model.dart';

class DiagnoseHandlers {
  final DiagnoseController controller;
  final DiagnosisService _diagnosisService = DiagnosisService();

  DiagnoseHandlers(this.controller);

  void onVoiceTap() {
    // Placeholder for voice input logic
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
    } catch (e) {
      controller.setError(e.toString());
      // Optionally show error to user
      print('Diagnosis error: $e');
    }
  }
}
