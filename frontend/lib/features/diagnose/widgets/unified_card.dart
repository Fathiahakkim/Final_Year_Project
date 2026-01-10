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

  const UnifiedCard({
    super.key,
    required this.controller,
    required this.complaintController,
    required this.messageController,
    this.onComplaintChanged,
    this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
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
              // Show diagnosis results if available
              if (controller.diagnosisResult != null)
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DiagnosisResultWidget(
                      diagnosisResult: controller.diagnosisResult!,
                    ),
                  ),
                )
              else if (controller.isLoading)
                Flexible(
                  child: Container(
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.all(16),
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          DiagnoseTheme.accentBlue,
                        ),
                      ),
                    ),
                  ),
                )
              else if (controller.errorMessage != null)
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
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
                  ),
                ),
              // Message input box - minimal bottom padding, flush with card edges
              Container(
                height: 44,
                margin: const EdgeInsets.only(
                  top: 12,
                  bottom: 0,
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
                      onPressed: controller.isLoading ? null : onSend,
                      icon:
                          controller.isLoading
                              ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    DiagnoseTheme.accentBlue,
                                  ),
                                ),
                              )
                              : const Icon(
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
      },
    );
  }
}
