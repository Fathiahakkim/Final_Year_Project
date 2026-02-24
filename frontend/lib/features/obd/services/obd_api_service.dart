import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../models/obd_prediction_model.dart';

/// Service responsible for communicating with the OBD backend API.
///
/// Uses multipart/form-data to upload a CSV file to
/// `POST /api/v1/obd/predict` and returns the parsed prediction result.
class OBDApiService {
  // Must match the base URL used by DiagnosisService.
  // TODO: Update with your PC's actual IP address for device testing.
  static const String baseUrl = 'http://192.168.29.196:8000';
  static const String _endpoint = '/api/v1/obd/predict';
  static const Duration _timeout = Duration(seconds: 60);

  /// Upload from a file path (Android / iOS).
  Future<OBDPredictionResult> predictFromPath(String filePath) async {
    final multipartFile = await http.MultipartFile.fromPath('file', filePath);
    return _sendRequest(multipartFile);
  }

  /// Upload from raw bytes (Web, or Android when path is unavailable).
  Future<OBDPredictionResult> predictFromBytes(
    Uint8List bytes,
    String fileName,
  ) async {
    final multipartFile = http.MultipartFile.fromBytes(
      'file',
      bytes,
      filename: fileName,
    );
    return _sendRequest(multipartFile);
  }

  /// Shared request logic.
  Future<OBDPredictionResult> _sendRequest(
    http.MultipartFile multipartFile,
  ) async {
    try {
      final uri = Uri.parse('$baseUrl$_endpoint');

      final request = http.MultipartRequest('POST', uri)
        ..files.add(multipartFile);

      final streamedResponse = await request.send().timeout(_timeout);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return OBDPredictionResult.fromJson(json);
      } else {
        String detail = 'Server error: ${response.statusCode}';
        try {
          final errorJson = jsonDecode(response.body) as Map<String, dynamic>;
          if (errorJson.containsKey('detail')) {
            detail = errorJson['detail'].toString();
          }
        } catch (_) {}
        throw OBDApiException(detail, response.statusCode);
      }
    } on OBDApiException {
      rethrow;
    } on http.ClientException catch (e) {
      throw OBDApiException('Network error: ${e.message}', null);
    } catch (e) {
      throw OBDApiException('Unexpected error: $e', null);
    }
  }
}

/// Exception thrown by [OBDApiService] on failure.
class OBDApiException implements Exception {
  final String message;
  final int? statusCode;

  OBDApiException(this.message, this.statusCode);

  @override
  String toString() => message;
}
