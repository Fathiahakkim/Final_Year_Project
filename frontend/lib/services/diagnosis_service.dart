import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/diagnosis_result_model.dart';

class DiagnosisService {
  // IMPORTANT: Replace with your PC's local IPv4 address for Android device testing
  // Example: 'http://192.168.1.5:8000'
  // Find your PC IP: Windows (ipconfig) or Linux/Mac (ifconfig)
  static const String baseUrl =
      'http://192.168.29.196:8000'; // TODO: Update with your PC's actual IP address
  static const String endpoint = '/api/diagnose';
  static const Duration timeout = Duration(seconds: 30);

  Future<DiagnosisResult> diagnoseComplaint(String complaint) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');

      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'complaint': complaint}),
          )
          .timeout(timeout);

      print('RAW BACKEND RESPONSE: ${response.body}');

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
