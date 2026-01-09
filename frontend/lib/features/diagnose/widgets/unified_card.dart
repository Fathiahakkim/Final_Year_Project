import 'package:flutter/material.dart';
import '../theme/diagnose_theme.dart';

class UnifiedCard extends StatelessWidget {
  final TextEditingController complaintController;
  final TextEditingController messageController;
  final ValueChanged<String>? onComplaintChanged;
  final VoidCallback? onSend;

  const UnifiedCard({
    super.key,
    required this.complaintController,
    required this.messageController,
    this.onComplaintChanged,
    this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DiagnoseTheme.cardWhite,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
          bottomLeft: Radius.zero,
          bottomRight: Radius.zero,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, -4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
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
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6FA),
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.all(14),
              child: TextField(
                controller: complaintController,
                onChanged: onComplaintChanged,
                maxLines: null,
                textAlignVertical: TextAlignVertical.top,
                style: const TextStyle(
                  fontSize: 16,
                  color: DiagnoseTheme.textPrimary,
                  height: 1.4,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                cursorColor: DiagnoseTheme.accentBlue,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F6FA),
              borderRadius: BorderRadius.circular(22),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    style: const TextStyle(
                      fontSize: 16,
                      color: DiagnoseTheme.textPrimary,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Type your message',
                      hintStyle: TextStyle(
                        color: DiagnoseTheme.textSecondary,
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    cursorColor: DiagnoseTheme.accentBlue,
                  ),
                ),
                IconButton(
                  onPressed: onSend,
                  icon: const Icon(
                    Icons.send,
                    color: DiagnoseTheme.accentBlue,
                    size: 24,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
