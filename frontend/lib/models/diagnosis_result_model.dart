class DiagnosisResult {
  final List<DiagnosedIssue> issues;
  final DateTime timestamp;

  DiagnosisResult({
    required this.issues,
    required this.timestamp,
  });

  factory DiagnosisResult.fromJson(Map<String, dynamic> json) {
    return DiagnosisResult(
      issues: (json['issues'] as List<dynamic>?)
              ?.map((issue) => DiagnosedIssue.fromJson(issue as Map<String, dynamic>))
              .toList() ??
          [],
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'issues': issues.map((issue) => issue.toJson()).toList(),
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class DiagnosedIssue {
  final String name;
  final double confidence; // 0.0 to 1.0 (will be converted to percentage)
  final IssueSeverity severity;

  DiagnosedIssue({
    required this.name,
    required this.confidence,
    required this.severity,
  });

  factory DiagnosedIssue.fromJson(Map<String, dynamic> json) {
    return DiagnosedIssue(
      name: json['name'] as String? ?? '',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      severity: _parseSeverity(json['severity'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'confidence': confidence,
      'severity': severity.toString().split('.').last,
    };
  }

  static IssueSeverity _parseSeverity(String? severity) {
    switch (severity?.toLowerCase()) {
      case 'critical':
      case 'high':
        return IssueSeverity.critical;
      case 'warning':
      case 'medium':
        return IssueSeverity.warning;
      case 'low':
      case 'info':
      default:
        return IssueSeverity.warning;
    }
  }

  int get confidencePercentage => (confidence * 100).round();
}

enum IssueSeverity {
  critical,
  warning,
}