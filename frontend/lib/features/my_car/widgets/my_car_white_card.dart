import 'package:flutter/material.dart';
import '../theme/my_car_theme.dart';
import 'empty_car_card.dart';
import 'add_car_form_card.dart';
import '../../../state/app_state.dart';

class MyCarWhiteCard extends StatelessWidget {
  final double cardHeight;
  final double keyboardHeight;
  final bool isExpanded;
  final AppState appState;
  final Function(String, String, int, String)? onSave;
  final VoidCallback? onCancel;

  const MyCarWhiteCard({
    super.key,
    required this.cardHeight,
    required this.keyboardHeight,
    this.isExpanded = false,
    required this.appState,
    this.onSave,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final safeAreaTop = mediaQuery.padding.top;

    final appBarHeight = kToolbarHeight; // ~56px

    // Top section height: safe area + app bar + car icon + spacing + title
    final topPadding = 80.0; // Same as MyCarTheme.topPadding
    final topSectionHeight =
        safeAreaTop +
        appBarHeight +
        topPadding +
        MyCarTheme.carIconSize +
        24 +
        40; // icon + spacing + title

    if (isExpanded) {
      // Expanded state: Position from top after car icon/title, extend to bottom
      // Same approach as diagnose page - just use keyboardHeight
      return AnimatedPositioned(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
        left: 0,
        right: 0,
        top: topSectionHeight,
        bottom: keyboardHeight, // Same as diagnose - no navigationBarHeight
        child: Container(
          decoration: BoxDecoration(
            color: MyCarTheme.cardWhite,
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
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            child: AddCarFormCard(onSave: onSave, onCancel: onCancel),
          ),
        ),
      );
    }

    // Collapsed state: Position from bottom
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
      left: 0,
      right: 0,
      bottom: keyboardHeight,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
        height: cardHeight,
        child: Container(
          decoration: BoxDecoration(
            color: MyCarTheme.cardWhite,
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
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            child: EmptyCarCard(appState: appState),
          ),
        ),
      ),
    );
  }
}
