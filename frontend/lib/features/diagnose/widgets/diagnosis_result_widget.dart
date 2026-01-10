import 'package:flutter/material.dart';
import '../../../models/diagnosis_result_model.dart';
import '../theme/diagnose_theme.dart';

class DiagnosisResultWidget extends StatelessWidget {
  final DiagnosisResult diagnosisResult;

  const DiagnosisResultWidget({
    super.key,
    required this.diagnosisResult,
  });

  @override
  Widget build(BuildContext context) {
    if (diagnosisResult.issues.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),
        Text(
          'DIAGNOSIS RESULTS',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: DiagnoseTheme.textSecondary,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        ...diagnosisResult.issues.asMap().entries.map((entry) {
          final index = entry.key;
          final issue = entry.value;
          return _IssueItem(
            issue: issue,
            index: index,
          );
        }),
      ],
    );
  }
}

class _IssueItem extends StatelessWidget {
  final DiagnosedIssue issue;
  final int index;

  const _IssueItem({
    required this.issue,
    required this.index,
  });

  Color _getSeverityColor() {
    switch (issue.severity) {
      case IssueSeverity.critical:
        return const Color(0xFFE53935); // Red
      case IssueSeverity.warning:
        return const Color(0xFFFF9800); // Orange
    }
  }

  IconData _getSeverityIcon() {
    switch (issue.severity) {
      case IssueSeverity.critical:
        return Icons.build;
      case IssueSeverity.warning:
        return Icons.warning_amber_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final severityColor = _getSeverityColor();
    final severityIcon = _getSeverityIcon();
    final confidencePercentage = issue.confidencePercentage;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: severityColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: severityColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: severityColor.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Icon(
                  severityIcon,
                  color: severityColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      issue.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: DiagnoseTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$confidencePercentage%',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: DiagnoseTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: issue.confidence,
              backgroundColor: Colors.grey.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(severityColor),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}