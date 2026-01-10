import 'package:flutter/foundation.dart' show debugPrint;
import '../controllers/diagnose_controller.dart';
import '../../../services/diagnosis_service.dart';
import '../../../services/voice_recorder_service.dart';
import '../../../services/transcription_service.dart';
import '../../../models/diagnosis_result_model.dart';
import '../../../models/diagnosis_history_entry.dart';
import '../../../state/app_state.dart';

/// Handlers for diagnose page user interactions.
/// Coordinates between services but does not own lifecycle of services.
class DiagnoseHandlers {
  final DiagnoseController controller;
  final AppState appState;
  final DiagnosisService _diagnosisService = DiagnosisService();
  final TranscriptionService _transcriptionService = TranscriptionService();
  // Injected from lifecycle owner (DiagnosePage), not created here
  final VoiceRecorderService _voiceRecorderService;

  DiagnoseHandlers(this.controller, this.appState, this._voiceRecorderService);

  Future<void> initializeVoiceRecorder() async {
    try {
      await _voiceRecorderService.init();
    } catch (e) {
      debugPrint('Failed to initialize voice recorder: $e');
    }
  }

  Future<void> onVoiceTap() async {
    if (_voiceRecorderService.isRecording) {
      // Second tap: Stop recording
      await stopRecordingAndTranscribe();
      return;
    }

    // First tap: Start recording
    try {
      await _voiceRecorderService.startRecording();
      debugPrint('VOICE: recording started');
    } catch (e) {
      debugPrint('Failed to start voice recording: $e');
    }
  }

  Future<void> stopRecordingAndTranscribe() async {
    // Stop recording
    final audioPath = await _voiceRecorderService.stopRecording();

    // Verification log: File path
    debugPrint('VOICE FILE PATH: $audioPath');

    // ONLY if path != null → send HTTP request
    if (audioPath != null) {
      await sendTranscriptionRequest(audioPath);
    } else {
      debugPrint(
        'ERROR: Execution stopped - audioPath is null after stopRecording()',
      );
    }
  }

  Future<void> sendTranscriptionRequest(String audioPath) async {
    final text = await _transcriptionService.transcribeAudio(audioPath);
    if (text != null && text.isNotEmpty) {
      controller.messageController.text = text;
      controller.complaintController.text = text;
    }
  }

  bool get isListening => _voiceRecorderService.isRecording;

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
    // VoiceRecorderService is disposed by lifecycle owner (DiagnosePage)
    // Handlers only coordinate, don't own resources
  }
}
