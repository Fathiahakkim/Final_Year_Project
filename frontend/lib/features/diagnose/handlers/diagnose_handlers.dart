import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../controllers/diagnose_controller.dart';
import '../../../services/diagnosis_service.dart';
import '../../../models/diagnosis_result_model.dart';

class DiagnoseHandlers {
  final DiagnoseController controller;
  final DiagnosisService _diagnosisService = DiagnosisService();
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;

  DiagnoseHandlers(this.controller);

  Future<void> onVoiceTap() async {
    if (_isListening) {
      _stopListening();
      return;
    }

    // Check if speech recognition is available
    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          _isListening = false;
        }
      },
      onError: (error) {
        _isListening = false;
        print('Speech recognition error: $error');
      },
    );

    if (!available) {
      print('Speech recognition not available');
      return;
    }

    // Start listening
    _isListening = true;
    await _speech.listen(
      onResult: (result) {
        if (result.finalResult) {
          // When speech is done, add to complaint box
          final recognizedText = result.recognizedWords.trim();
          if (recognizedText.isNotEmpty) {
            // Append to complaint box (or replace if empty)
            final currentText = controller.complaintController.text.trim();
            if (currentText.isEmpty) {
              controller.complaintController.text = recognizedText;
            } else {
              controller.complaintController.text =
                  '$currentText $recognizedText';
            }
            // Move cursor to end
            controller.complaintController.selection = TextSelection.collapsed(
              offset: controller.complaintController.text.length,
            );
          }
          _isListening = false;
        }
      },
      localeId: 'en_US',
      listenMode: stt.ListenMode.dictation, // Dictation mode like WhatsApp
      cancelOnError: false,
      partialResults: true, // Show partial results as user speaks
    );
  }

  void _stopListening() {
    if (_isListening) {
      _speech.stop();
      _isListening = false;
    }
  }

  bool get isListening => _isListening;

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
    } catch (e) {
      controller.setError(e.toString());
      // Optionally show error to user
      print('Diagnosis error: $e');
    }
  }
}
