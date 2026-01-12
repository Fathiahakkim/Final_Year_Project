import 'package:flutter/material.dart';
import '../theme/diagnose_theme.dart';

class ComplaintCard extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const ComplaintCard({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.all(DiagnoseTheme.complaintCardPadding),
      decoration: BoxDecoration(
        color: DiagnoseTheme.cardWhite,
        borderRadius: BorderRadius.circular(DiagnoseTheme.cardRadius),
        boxShadow: DiagnoseTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'COMPLAINT',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: DiagnoseTheme.textSecondary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            onChanged: onChanged,
            maxLines: null,
            style: const TextStyle(
              fontSize: 16,
              color: DiagnoseTheme.textPrimary,
              height: 1.4,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              hintText: 'Engine is shaking when idling.',
              hintStyle: TextStyle(
                fontSize: 16,
                color: DiagnoseTheme.textSecondary,
                height: 1.4,
              ),
            ),
            cursorColor: DiagnoseTheme.accentBlue,
          ),
        ],
      ),
    );
  }
}
