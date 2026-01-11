import 'package:flutter/material.dart';
import '../controllers/diagnose_controller.dart';
import '../utils/diagnose_spacing.dart';
import 'car_visual.dart';
import 'voice_button.dart';
import '../handlers/diagnose_handlers.dart';
import '../../voice/voice_controller.dart';

class DiagnoseFixedContent extends StatelessWidget {
  final DiagnoseController controller;
  final DiagnoseHandlers handlers;
  final double cardHeight;
  final double keyboardHeight;

  const DiagnoseFixedContent({
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
    final safeAreaTop = mediaQuery.padding.top;
    final safeAreaBottom = mediaQuery.padding.bottom;

    final voiceController = VoiceController();

    // Calculate card top position - card moves up when keyboard opens
    final cardBottom = keyboardHeight + safeAreaBottom;
    final cardTop = screenHeight - cardBottom - cardHeight;

    // Element dimensions
    final micHeight = 140.0;
    final carHeight = 150.0;
    final carToMicSpacing = DiagnoseSpacing.spaceBetweenCarAndMic;
    final micToCardSpacing = DiagnoseSpacing.cardClearance;

    // Ensure minimum top spacing (accounting for safe area and app bar)
    final minTop = safeAreaTop;

    // CRITICAL: Mic must ALWAYS be above the card, never behind it
    // Priority order:
    // 1. Mic must stay above card with proper spacing (highest priority)
    // 2. Car should maintain spacing with mic
    // 3. Car should not go above minimum top spacing

    // First, calculate the maximum mic top position to stay above card
    final maxMicTop = cardTop - micToCardSpacing - micHeight;

    // Ideal mic position - above card with proper spacing
    double finalMicTop = maxMicTop;

    // Calculate ideal car position based on mic
    double finalCarTop = finalMicTop - carToMicSpacing - carHeight;

    // If car would go above minimum top, constrain it and recalculate
    if (finalCarTop < minTop) {
      finalCarTop = minTop;
      // Calculate minimum mic position to maintain spacing with car
      final minMicTop = finalCarTop + carHeight + carToMicSpacing;

      // Ensure mic stays above card (highest priority)
      // If minMicTop would put mic behind card, prioritize keeping mic above card
      if (minMicTop > maxMicTop) {
        // Not enough space - prioritize mic above card
        finalMicTop = maxMicTop;
        // Recalculate car position, allowing it to potentially overlap with top constraint
        finalCarTop = finalMicTop - carToMicSpacing - carHeight;
        // Clamp car to minimum top, but mic will maintain its position above card
        if (finalCarTop < minTop) {
          finalCarTop = minTop;
        }
      } else {
        // We have enough space - use the minimum mic position to maintain car spacing
        finalMicTop = minMicTop;
      }
    }

    // Final verification: Ensure mic is absolutely above the card
    final micBottom = finalMicTop + micHeight;
    if (micBottom > cardTop - micToCardSpacing) {
      // Force mic above card as highest priority
      finalMicTop = cardTop - micToCardSpacing - micHeight;
      // Recalculate car accordingly
      finalCarTop = finalMicTop - carToMicSpacing - carHeight;
      // Clamp car to minimum top
      if (finalCarTop < minTop) {
        finalCarTop = minTop;
      }
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
            child: CarVisual(key: controller.carKey),
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
