enum FeedbackStatus {
  correct,
  incorrect,
  notReviewed,
}

class DiagnosisHistoryEntry {
  final String complaintText;
  final String primaryFaultName;
  final double confidence;
  final DateTime timestamp;
  final FeedbackStatus feedbackStatus;

  DiagnosisHistoryEntry({
    required this.complaintText,
    required this.primaryFaultName,
    required this.confidence,
    required this.timestamp,
    this.feedbackStatus = FeedbackStatus.notReviewed,
  });

  int get confidencePercentage => (confidence * 100).round();
}
