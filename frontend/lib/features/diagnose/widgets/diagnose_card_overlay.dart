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
        // If there are results, expand to cover more of the screen (including mic)
        // Otherwise use the base card height
        final hasResults = controller.diagnosisResult != null;
        final isLoading = controller.isLoading;

        double dynamicHeight;
        if (hasResults || isLoading) {
          // Expand to cover mic - use larger portion of screen
          dynamicHeight = screenHeight * 0.65;
        } else {
          // Normal height when no results
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
            ),
          ),
        );
      },
    );
  }
}
