import 'package:flutter/material.dart';
import 'widgets/car_visual.dart';
import 'widgets/voice_button.dart';
import 'widgets/unified_card.dart';
import 'theme/diagnose_theme.dart';

class DiagnosePage extends StatefulWidget {
  const DiagnosePage({super.key});

  @override
  State<DiagnosePage> createState() => _DiagnosePageState();
}

class _DiagnosePageState extends State<DiagnosePage> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _complaintController = TextEditingController(
    text: 'Engine is shaking when idling.',
  );
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _carKey = GlobalKey();
  final GlobalKey _micKey = GlobalKey();
  double _previousKeyboardHeight = 0;

  @override
  void initState() {
    super.initState();
    _complaintController.selection = TextSelection.collapsed(
      offset: _complaintController.text.length,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final mediaQuery = MediaQuery.of(context);
        _scrollToContent(mediaQuery.viewInsets.bottom);
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _complaintController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToContent(double keyboardHeight) {
    if (!mounted || !_scrollController.hasClients) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;

      final mediaQuery = MediaQuery.of(context);
      final currentKeyboardHeight = mediaQuery.viewInsets.bottom;
      final screenHeight = mediaQuery.size.height;
      final cardHeight = screenHeight * 0.25;

      if (currentKeyboardHeight > 0) {
        // Keyboard opened - scroll to keep mic visible above card
        final micContext = _micKey.currentContext;
        if (micContext != null) {
          final RenderBox? micRenderBox =
              micContext.findRenderObject() as RenderBox?;
          if (micRenderBox != null) {
            // Calculate viewport with keyboard and card
            final viewportHeight = screenHeight;
            final availableHeight =
                viewportHeight - currentKeyboardHeight - cardHeight;
            final targetMicBottom = availableHeight - 40; // 40px padding

            // Get mic position in screen coordinates
            final micScreenPos = micRenderBox.localToGlobal(Offset.zero);
            final micHeight = micRenderBox.size.height;
            final micBottom = micScreenPos.dy + micHeight;

            // If mic is below target, scroll up
            if (micBottom > targetMicBottom) {
              final scrollNeeded = micBottom - targetMicBottom;
              final currentOffset = _scrollController.offset;
              final maxScroll = _scrollController.position.maxScrollExtent;
              final newOffset = (currentOffset + scrollNeeded).clamp(
                0.0,
                maxScroll > 0 ? maxScroll : 0.0,
              );

              if ((newOffset - currentOffset).abs() > 1) {
                _scrollController.animateTo(
                  newOffset,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              }
            }
          }
        }
      } else {
        // Keyboard closed - scroll to top smoothly
        if (_scrollController.offset > 0) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      }
    });
  }

  void _onVoiceTap() {
    // Placeholder for voice input logic
  }

  void _onComplaintChanged(String text) {
    // Text is automatically updated via controller
  }

  void _onSend() {
    // Placeholder for send logic
    if (_messageController.text.isNotEmpty) {
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    final availableHeight = screenHeight - keyboardHeight;
    final cardHeight = screenHeight * 0.25;

    // Calculate space between car and mic
    final spaceBetweenCarAndMic = 24.0;
    // Calculate space between mic and card (responsive)
    final spaceBetweenMicAndCard = (availableHeight * 0.15).clamp(40.0, 80.0);

    // Auto-scroll when keyboard or layout changes
    if (keyboardHeight != _previousKeyboardHeight) {
      _previousKeyboardHeight = keyboardHeight;
      _scrollToContent(keyboardHeight);
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: DiagnoseTheme.backgroundGradient,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.only(
                  bottom: cardHeight + keyboardHeight + 20,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    CarVisual(key: _carKey),
                    SizedBox(height: spaceBetweenCarAndMic),
                    Center(
                      child: VoiceButton(key: _micKey, onTap: _onVoiceTap),
                    ),
                    SizedBox(height: spaceBetweenMicAndCard),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: keyboardHeight,
              child: SizedBox(
                height: cardHeight,
                child: UnifiedCard(
                  complaintController: _complaintController,
                  messageController: _messageController,
                  onComplaintChanged: _onComplaintChanged,
                  onSend: _onSend,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
