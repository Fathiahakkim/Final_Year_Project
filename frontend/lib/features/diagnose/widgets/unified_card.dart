import 'package:flutter/material.dart';
import '../theme/diagnose_theme.dart';
import '../controllers/diagnose_controller.dart';
import 'diagnosis_result_widget.dart';

class UnifiedCard extends StatelessWidget {
  final DiagnoseController controller;
  final TextEditingController complaintController;
  final TextEditingController messageController;
  final ValueChanged<String>? onComplaintChanged;
  final VoidCallback? onSend;
  final VoidCallback? onVoiceTap;

  const UnifiedCard({
    super.key,
    required this.controller,
    required this.complaintController,
    required this.messageController,
    this.onComplaintChanged,
    this.onSend,
    this.onVoiceTap,
  });

  @override
  Widget build(BuildContext context) {
    // Listen to both controller and messageController for icon updates
    return ListenableBuilder(
      listenable: Listenable.merge([controller, messageController]),
      builder: (context, child) {
        return Container(
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
              // Complaint box - STATIC at top
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    Container(
                      constraints: const BoxConstraints(
                        minHeight: 60,
                        maxHeight: 120,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F6FA),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.all(14),
                      child: SingleChildScrollView(
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
                  ],
                ),
              ),
              // Results section - EXPANDABLE in middle (takes available space)
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Show diagnosis results if available
                      if (controller.diagnosisResult != null)
                        DiagnosisResultWidget(
                          diagnosisResult: controller.diagnosisResult!,
                        )
                      else if (controller.isLoading || controller.messageSent)
                        // Show processing state when loading or when message sent but no results yet
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  DiagnoseTheme.accentBlue,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Processing...',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: DiagnoseTheme.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Analyzing your complaint',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: DiagnoseTheme.textSecondary
                                      .withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        )
                      else if (controller.errorMessage != null)
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Error: ${controller.errorMessage}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              // Message input box - ALWAYS STATIC at bottom
              StatefulBuilder(
                builder: (context, setState) {
                  return Container(
                    height: 44,
                    margin: const EdgeInsets.only(
                      top: 12,
                      bottom: 8,
                      left: 16,
                      right: 16,
                    ),
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
                            onChanged: (text) {
                              // Update icon when text changes
                              setState(() {});
                            },
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
                        // Show voice icon when empty, send icon when text entered (WhatsApp style)
                        Builder(
                          builder: (context) {
                            final hasText =
                                messageController.text.trim().isNotEmpty;
                            final isLoading = controller.isLoading;

                            return IconButton(
                              onPressed:
                                  isLoading
                                      ? null
                                      : (hasText ? onSend : onVoiceTap),
                              icon:
                                  isLoading
                                      ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                DiagnoseTheme.accentBlue,
                                              ),
                                        ),
                                      )
                                      : (hasText
                                          ? const Icon(
                                            Icons.send,
                                            color: DiagnoseTheme.accentBlue,
                                            size: 24,
                                          )
                                          : const Icon(
                                            Icons.mic,
                                            color: DiagnoseTheme.accentBlue,
                                            size: 24,
                                          )),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
