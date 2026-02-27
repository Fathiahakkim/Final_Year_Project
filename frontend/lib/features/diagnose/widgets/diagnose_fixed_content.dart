import 'package:flutter/material.dart';
import '../controllers/diagnose_controller.dart';
import '../utils/diagnose_spacing.dart';
import 'car_visual.dart';
import 'voice_button.dart';
import '../handlers/diagnose_handlers.dart';
import '../../voice/voice_controller.dart';
import '../../../state/app_state.dart';

class DiagnoseFixedContent extends StatelessWidget {
  final DiagnoseController controller;
  final DiagnoseHandlers handlers;
  final double cardHeight;
  final double keyboardHeight;
  final AppState appState;

  const DiagnoseFixedContent({
    super.key,
    required this.controller,
    required this.handlers,
    required this.cardHeight,
    required this.keyboardHeight,
    required this.appState,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final safeAreaTop = mediaQuery.padding.top;
    final safeAreaBottom = mediaQuery.padding.bottom;

    final voiceController = VoiceController();

    // Calculate card top position - card moves up when keyboard opens
    final cardBottom = keyboardHeight + safeAreaBottom;
    final cardTop = screenHeight - cardBottom - cardHeight;

    // ── Layout Logic: Lock Car to Top Spacing to match OBD/MyCar Screens ──
    final availableSpace = cardTop - safeAreaTop;
    final micHeight = 140.0;
    final carHeight = 150.0;

    // 1. Lock car position exactly like OBD page (DiagnoseSpacing.topSpacing)
    final finalCarTop = safeAreaTop + DiagnoseSpacing.topSpacing;

    // 2. Center the Voice Mic in the remaining space between the Car and the Card
    final remainingSpaceForMic = cardTop - (finalCarTop + carHeight);
    
    // Default spacing if everything fits comfortably
    double finalMicTop = finalCarTop + carHeight + DiagnoseSpacing.spaceBetweenCarAndMic;

    // If screen is squished (e.g. keyboard), force the mic into the exact center
    // of the remaining space between the bottom of the car and the top of the card
    if (remainingSpaceForMic < micHeight + DiagnoseSpacing.spaceBetweenCarAndMic) {
        final gapMiddle = (finalCarTop + carHeight) + (remainingSpaceForMic / 2);
        finalMicTop = gapMiddle - (micHeight / 2);
    }

    return SafeArea(
      bottom: false,
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            top: finalCarTop - safeAreaTop,
            left: 0,
            right: 0,
            child: CarVisual(key: controller.carKey, appState: appState),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            top: finalMicTop - safeAreaTop,
            left: 0,
            right: 0,
            child: Center(
              child: VoiceButton(
                key: controller.micKey,
                onTap: () async {
                  await voiceController.start(
                    onText: (text) {
                      controller.messageController.text = text;
                      controller.messageController.selection = TextSelection.fromPosition(
                        TextPosition(offset: text.length),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
