import 'package:flutter/material.dart';
import 'controllers/diagnose_controller.dart';
import 'handlers/diagnose_handlers.dart';
import 'utils/diagnose_spacing.dart';
import 'widgets/diagnose_app_bar.dart';
import 'widgets/diagnose_background.dart';
import 'widgets/diagnose_fixed_content.dart';
import 'widgets/diagnose_card_overlay.dart';
import '../../state/app_state.dart';

class DiagnosePage extends StatefulWidget {
  final AppState appState;

  const DiagnosePage({super.key, required this.appState});

  @override
  State<DiagnosePage> createState() => _DiagnosePageState();
}

class _DiagnosePageState extends State<DiagnosePage> {
  late final DiagnoseController _controller;
  late final DiagnoseHandlers _handlers;

  @override
  void initState() {
    super.initState();
    _controller = DiagnoseController();
    _handlers = DiagnoseHandlers(
      _controller,
      widget.appState,
    );
    _controller.initializeComplaintSelection();
  }

  @override
  void dispose() {
    _handlers.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    final cardHeight = DiagnoseSpacing.calculateCardHeight(screenHeight);

    return Scaffold(
      appBar: const DiagnoseAppBar(),
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      body: DiagnoseBackground(
        child: Stack(
          fit: StackFit.expand,
          children: [
            DiagnoseFixedContent(
              controller: _controller,
              handlers: _handlers,
              cardHeight: cardHeight,
              keyboardHeight: keyboardHeight,
            ),
            DiagnoseCardOverlay(
              controller: _controller,
              handlers: _handlers,
              cardHeight: cardHeight,
              keyboardHeight: keyboardHeight,
            ),
          ],
        ),
      ),
    );
  }
}
