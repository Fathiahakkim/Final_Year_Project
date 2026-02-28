class DiagnosisResult {
  final List<DiagnosedIssue> predictions;
  final double highestConfidence;
  final Map<String, double> weights;
  final bool lowConfidence;
  final double confidenceGap;
  final String? message;

  DiagnosisResult({
    required this.predictions,
    required this.highestConfidence,
    required this.weights,
    required this.lowConfidence,
    required this.confidenceGap,
    this.message,
  });

  factory DiagnosisResult.fromJson(Map<String, dynamic> json) {
    // Parse predictions which arrive as [["FaultName", 0.95], ...]
    final List<dynamic> predsJson = json['predictions'] ?? [];
    final List<DiagnosedIssue> parsedPredictions = predsJson.map((item) {
      final list = item as List<dynamic>;
      return DiagnosedIssue(
        name: list[0] as String,
        confidence: (list[1] as num).toDouble(),
      );
    }).toList();

    final weightsJson = json['weights'] as Map<String, dynamic>? ?? {};
    final weights = {
      'nlp_weight': (weightsJson['nlp_weight'] as num?)?.toDouble() ?? 0.0,
      'obd_weight': (weightsJson['obd_weight'] as num?)?.toDouble() ?? 0.0,
    };

    return DiagnosisResult(
      predictions: parsedPredictions,
      highestConfidence: (json['highest_confidence'] as num?)?.toDouble() ?? 0.0,
      weights: weights,
      lowConfidence: json['low_confidence'] as bool? ?? false,
      confidenceGap: (json['confidence_gap'] as num?)?.toDouble() ?? 0.0,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'predictions': predictions.map((p) => [p.name, p.confidence]).toList(),
      'highest_confidence': highestConfidence,
      'weights': weights,
      'low_confidence': lowConfidence,
      'confidence_gap': confidenceGap,
      if (message != null) 'message': message,
    };
  }
}

class SuppressionInfo {
  final bool unknownSuppressed;
  final bool otherSuppressed;

  SuppressionInfo({
    required this.unknownSuppressed,
    required this.otherSuppressed,
  });

  factory SuppressionInfo.fromJson(Map<String, dynamic> json) {
    return SuppressionInfo(
      unknownSuppressed: json['unknown_suppressed'] as bool? ?? false,
      otherSuppressed: json['other_suppressed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'unknown_suppressed': unknownSuppressed,
      'other_suppressed': otherSuppressed,
    };
  }
}

class DiagnosedIssue {
  final String name;
  final double confidence; // 0.0 to 1.0 (will be converted to percentage)

  DiagnosedIssue({
    required this.name,
    required this.confidence,
  });

  IssueSeverity get severity =>
      confidence >= 0.8 ? IssueSeverity.critical : IssueSeverity.warning;

  int get confidencePercentage => (confidence * 100).round();
}

enum IssueSeverity { critical, warning }
