import 'dart:convert';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:http/http.dart' as http;
import 'diagnosis_service.dart';

/// Service responsible for sending audio files to backend for transcription.
/// Single responsibility: HTTP transcription requests only.
class TranscriptionService {
  static const String endpoint = '/api/v1/transcribe';

  Future<String?> transcribeAudio(String audioFilePath) async {
    try {
      debugPrint('Sending transcription request for file: $audioFilePath');
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${DiagnosisService.baseUrl}$endpoint'),
      );

      // Field name must be exactly "file"
      request.files.add(await http.MultipartFile.fromPath('file', audioFilePath));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final data = jsonDecode(responseBody) as Map<String, dynamic>;

        final text = data['text'] ?? '';

        if (text.isNotEmpty) {
          debugPrint('Transcription received: $text');
          return text;
        } else {
          debugPrint('ERROR: Execution stopped - transcription returned empty text');
          return null;
        }
      } else {
        final errorBody = await response.stream.bytesToString();
        debugPrint(
          'ERROR: Execution stopped - transcription failed with status ${response.statusCode}: $errorBody',
        );
        return null;
      }
    } catch (e) {
      debugPrint('ERROR: Execution stopped - failed to transcribe audio: $e');
      return null;
    }
  }
}
