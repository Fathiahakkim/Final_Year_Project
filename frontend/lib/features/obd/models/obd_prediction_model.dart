/// Represents a single fault prediction from the OBD backend.
class OBDFaultPrediction {
  final String fault;
  final double confidence;

  const OBDFaultPrediction({
    required this.fault,
    required this.confidence,
  });

  factory OBDFaultPrediction.fromJson(Map<String, dynamic> json) {
    return OBDFaultPrediction(
      fault: json['fault'] as String,
      confidence: (json['confidence'] as num).toDouble(),
    );
  }
}

/// Represents the full response from POST /api/v1/obd/predict.
class OBDPredictionResult {
  final String source;
  final List<OBDFaultPrediction> topFaults;

  const OBDPredictionResult({
    required this.source,
    required this.topFaults,
  });

  factory OBDPredictionResult.fromJson(Map<String, dynamic> json) {
    final faultsJson = json['top_faults'] as List<dynamic>;
    return OBDPredictionResult(
      source: json['source'] as String,
      topFaults: faultsJson
          .map((e) => OBDFaultPrediction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
