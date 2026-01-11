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

    final issues = diagnosisResult.issues;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        ...issues.asMap().entries.map((entry) {
          final index = entry.key;
          final issue = entry.value;
          final isLastItem = index == issues.length - 1;
          return _IssueItem(
            issue: issue,
            index: index,
            isLastItem: isLastItem,
          );
        }),
      ],
    );
  }
}

class _IssueItem extends StatelessWidget {
  final DiagnosedIssue issue;
  final int index;
  final bool isLastItem;

  const _IssueItem({
    required this.issue,
    required this.index,
    required this.isLastItem,
  });

  // Get icon based on issue name or index
  IconData _getIssueIcon() {
    final name = issue.name.toLowerCase();
    if (name.contains('misfire') || name.contains('engine')) {
      return Icons.local_fire_department; // Flame icon for engine misfire
    } else if (name.contains('spark') || name.contains('plug')) {
      return Icons.bolt; // Spark plug icon
    } else if (name.contains('fuel') || name.contains('injector')) {
      return Icons.chat_bubble_outline; // Chat/speech bubble for fuel injector
    } else {
      return Icons.build; // Default icon
    }
  }

  // Always use blue color to match the design
  Color _getIconColor() {
    return DiagnoseTheme.accentBlue;
  }

  @override
  Widget build(BuildContext context) {
    final confidencePercentage = issue.confidencePercentage;
    final icon = _getIssueIcon();
    final iconColor = _getIconColor();

    return Container(
      margin: EdgeInsets.only(bottom: isLastItem ? 4 : 12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row with icon, text, and percentage
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon on the left
              Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              // Issue name in the middle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      issue.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: DiagnoseTheme.textPrimary,
                      ),
                    ),
                    Text(
                      issue.severity.toString().split('.').last,
                      style: TextStyle(
                        fontSize: 12,
                        color: DiagnoseTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Percentage on the right
              Text(
                '$confidencePercentage%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: DiagnoseTheme.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress bar below
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: issue.confidence,
              backgroundColor: const Color(0xFFE5E5E5),
              valueColor: AlwaysStoppedAnimation<Color>(iconColor),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}