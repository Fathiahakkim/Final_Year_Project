import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'controllers/obd_controller.dart';
import 'models/obd_prediction_model.dart';
import 'widgets/obd_app_bar.dart';
import 'widgets/obd_background.dart';
import 'widgets/obd_white_card.dart';
import 'theme/obd_theme.dart';
import '../diagnose/utils/diagnose_spacing.dart';
import '../../state/app_state.dart';
import '../../utils/car_glb_map.dart';

class OBDPage extends StatefulWidget {
  final AppState appState;
  final VoidCallback? onNavigateHome;

  const OBDPage({super.key, required this.appState, this.onNavigateHome});

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

    // Calculate minimum top position for 3D car model
    final minTop = safeAreaTop + DiagnoseSpacing.topSpacing;

    return Scaffold(
      appBar: OBDAppBar(onNavigateHome: widget.onNavigateHome),
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

              // Push the 3D car model higher when card expands
              final carTop = hasResults
                  ? (minTop - safeAreaTop) * 0.3
                  : minTop - safeAreaTop;

              return Stack(
                fit: StackFit.expand,
                children: [
                  // 3D Car model — animates upward when results arrive
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOutCubic,
                    top: carTop,
                    left: 0,
                    right: 0,
                    child: ListenableBuilder(
                      listenable: widget.appState,
                      builder: (context, child) {
                        final selectedCar = widget.appState.primaryCar;
                        final glbPath = resolveCarGlb(selectedCar?.make ?? 'BMW');

                        return SizedBox(
                          width: double.infinity,
                          height: 160,
                          child: ModelViewer(
                            src: glbPath,
                            alt: selectedCar != null
                                ? '${selectedCar.make} ${selectedCar.model}'
                                : 'Car Model',
                            autoRotate: true,
                            cameraControls: true,
                            disableZoom: false,
                            cameraOrbit: '0deg 75deg 105%',
                            fieldOfView: '30deg',
                            backgroundColor: Colors.transparent,
                          ),
                        );
                      },
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
