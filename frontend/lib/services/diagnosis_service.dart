import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/diagnosis_result_model.dart';

class DiagnosisService {
  static const String baseUrl = 'http://localhost:8000'; // Update with your backend URL
  static const String endpoint = '/api/diagnose';
  static const Duration timeout = Duration(seconds: 30);

  Future<DiagnosisResult> diagnoseComplaint(String complaint) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      
      final response = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'complaint': complaint,
            }),
          )
          .timeout(timeout);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return DiagnosisResult.fromJson(jsonResponse);
      } else {
        throw DiagnosisException(
          'Server error: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on FormatException catch (e) {
      throw DiagnosisException('Invalid response format: ${e.message}', null);
    } on http.ClientException catch (e) {
      throw DiagnosisException('Network error: ${e.message}', null);
    } catch (e) {
      throw DiagnosisException('Unexpected error: ${e.toString()}', null);
    }
  }
}

class DiagnosisException implements Exception {
  final String message;
  final int? statusCode;

  DiagnosisException(this.message, this.statusCode);

  @override
  String toString() => message;
}