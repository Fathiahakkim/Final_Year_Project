import 'package:flutter/material.dart';
import '../controllers/diagnose_controller.dart';
import '../handlers/diagnose_handlers.dart';
import 'unified_card.dart';

class DiagnoseCardOverlay extends StatelessWidget {
  final DiagnoseController controller;
  final DiagnoseHandlers handlers;
  final double cardHeight;
  final double keyboardHeight;

  const DiagnoseCardOverlay({
    super.key,
    required this.controller,
    required this.handlers,
    required this.cardHeight,
    required this.keyboardHeight,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        // Calculate dynamic height based on diagnosis state
        // Card should only expand when there are results to show or when loading
        // NOT just because message was sent - keeps message input in same position
        final hasResults = controller.diagnosisResult != null;
        final isLoading = controller.isLoading;

        double dynamicHeight;
        if (hasResults || isLoading) {
          // Expand to cover mic - use larger portion of screen
          // Only expand when there are actual results or loading
          dynamicHeight = screenHeight * 0.65;
        } else {
          // Normal height when no results and not loading
          // This keeps message input at consistent position even on error
          dynamicHeight = cardHeight;
        }

        return AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          left: 0,
          right: 0,
          bottom: keyboardHeight,
          child: SizedBox(
            height: dynamicHeight,
            child: UnifiedCard(
              controller: controller,
              complaintController: controller.complaintController,
              messageController: controller.messageController,
              onComplaintChanged: handlers.onComplaintChanged,
              onSend: handlers.onSend,
              onVoiceTap: handlers.onVoiceTap,
            ),
          ),
        );
      },
    );
  }
}
