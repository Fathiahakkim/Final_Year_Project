import 'package:flutter/material.dart';
import '../controllers/diagnose_controller.dart';
import '../handlers/diagnose_handlers.dart';
import 'unified_card.dart';
import '../../voice/voice_controller.dart';

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

    final voiceController = VoiceController();

    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        // Card should move up and stay expanded once message is sent
        // It will show processing status until results arrive
        final messageSent = controller.messageSent;
        final hasResults = controller.diagnosisResult != null;
        final isLoading = controller.isLoading;

        double dynamicHeight;
        if (messageSent || hasResults || isLoading) {
          // Expand to show results - but leave space for car above
          // Card stays expanded once message is sent, but doesn't need to be so tall
          // Reduced from 0.65 to 0.55 to leave more space between car and card
          dynamicHeight = screenHeight * 0.55;
        } else {
          // Normal height when no message sent yet
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
              onVoiceTap: () async {
                await voiceController.start(
                  onText: (text) {
                    controller.messageController.text = text;
                    controller
                        .messageController
                        .selection = TextSelection.fromPosition(
                      TextPosition(offset: text.length),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
