import 'package:flutter/material.dart';
import 'controllers/obd_controller.dart';
import 'models/obd_prediction_model.dart';
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
          child: ValueListenableBuilder<OBDPredictionResult?>(
            valueListenable: _controller.predictionResult,
            builder: (context, result, _) {
              final hasResults = result != null;

              // Compute dynamic card height: expand when results are present
              final dynamicCardHeight = hasResults
                  ? screenHeight * 0.55
                  : cardHeight;

              // Push the adapter graphic higher when card expands
              final adapterTop = hasResults
                  ? (minTop - safeAreaTop) * 0.3
                  : minTop - safeAreaTop;

              return Stack(
                fit: StackFit.expand,
                children: [
                  // Adapter graphic — animates upward when results arrive
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOutCubic,
                    top: adapterTop,
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
                  // White card overlay at bottom — expands on results
                  OBDWhiteCard(
                    cardHeight: dynamicCardHeight,
                    keyboardHeight: keyboardHeight,
                    controller: _controller,
                    hasResults: hasResults,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
