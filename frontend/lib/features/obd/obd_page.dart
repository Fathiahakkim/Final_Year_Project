import 'package:flutter/material.dart';
import 'controllers/obd_controller.dart';
import 'widgets/obd_app_bar.dart';
import 'widgets/obd_background.dart';
import 'widgets/obd_adapter_graphic.dart';
import 'widgets/obd_white_card.dart';
import 'theme/obd_theme.dart';
import '../diagnose/utils/diagnose_spacing.dart';

class OBDPage extends StatefulWidget {
  const OBDPage({super.key});

  @override
  State<OBDPage> createState() => _OBDPageState();
}

class _OBDPageState extends State<OBDPage> {
  late final OBDController _controller;

  @override
  void initState() {
    super.initState();
    _controller = OBDController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final safeAreaTop = mediaQuery.padding.top;
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    final cardHeight = DiagnoseSpacing.calculateCardHeight(screenHeight);

    // Calculate minimum top position for adapter graphic
    final minTop = safeAreaTop + DiagnoseSpacing.topSpacing;

    return Scaffold(
      appBar: const OBDAppBar(),
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      body: OBDBackground(
        child: SafeArea(
          bottom: false,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Adapter graphic
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                top: minTop - safeAreaTop,
                left: 0,
                right: 0,
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: OBDTheme.horizontalPadding,
                    ),
                    child: OBDAdapterGraphic(),
                  ),
                ),
              ),
              // White card overlay at bottom
              OBDWhiteCard(
                cardHeight: cardHeight,
                keyboardHeight: keyboardHeight,
                controller: _controller,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
