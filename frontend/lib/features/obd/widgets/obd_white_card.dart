import 'package:flutter/material.dart';
import '../theme/obd_theme.dart';
import '../controllers/obd_controller.dart';
import '../models/obd_prediction_model.dart';

class OBDWhiteCard extends StatelessWidget {
  final double cardHeight;
  final double keyboardHeight;
  final OBDController controller;
  final bool hasResults;

  const OBDWhiteCard({
    super.key,
    required this.cardHeight,
    required this.keyboardHeight,
    required this.controller,
    this.hasResults = false,
  });

  @override
  Widget build(BuildContext context) {
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
            color: OBDTheme.cardWhite,
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
            child: _OBDCardContent(controller: controller),
          ),
        ),
      ),
    );
  }
}

class _OBDCardContent extends StatelessWidget {
  final OBDController controller;

  const _OBDCardContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Prediction results (above upload button) ──────────────
          ValueListenableBuilder<OBDPredictionResult?>(
            valueListenable: controller.predictionResult,
            builder: (context, result, _) {
              if (result == null) return const SizedBox.shrink();
              return _OBDResultsSection(result: result);
            },
          ),

          // ── Title & description ──────────────────────────────────
          Text(
            'Add OBD Data',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: OBDTheme.textPrimary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Upload a CSV file to diagnose faults from OBD sensor data.',
            style: TextStyle(
              fontSize: 14,
              color: OBDTheme.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),

          // ── Upload button ────────────────────────────────────────
          ValueListenableBuilder<bool>(
            valueListenable: controller.isUploading,
            builder: (context, isUploading, _) {
              return SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isUploading
                      ? null
                      : () => controller.pickAndUploadCSV(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: OBDTheme.accentBlue,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        OBDTheme.accentBlue.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    elevation: 0,
                  ),
                  child: isUploading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'UPLOAD FILE',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.0,
                          ),
                        ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // ── Error message ────────────────────────────────────────
          ValueListenableBuilder<String?>(
            valueListenable: controller.uploadError,
            builder: (context, error, _) {
              if (error == null) return const SizedBox.shrink();
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline,
                        color: Colors.red.shade700, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        error,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Displays OBD prediction results in the same style as the Diagnose screen:
/// wrench icon, fault name, severity label, confidence %, and progress bar.
class _OBDResultsSection extends StatelessWidget {
  final OBDPredictionResult result;

  const _OBDResultsSection({required this.result});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Text(
          'Detected Faults',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: OBDTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        // Each fault as a card with icon + progress bar
        ...result.topFaults.asMap().entries.map((entry) {
          final index = entry.key;
          final fault = entry.value;
          final isLast = index == result.topFaults.length - 1;
          return _OBDFaultItem(fault: fault, isLast: isLast);
        }),
        const SizedBox(height: 20),
      ],
    );
  }
}

/// A single fault item styled like the Diagnose screen's _IssueItem:
/// wrench icon | fault name + "warning" | percentage | progress bar
class _OBDFaultItem extends StatelessWidget {
  final OBDFaultPrediction fault;
  final bool isLast;

  const _OBDFaultItem({required this.fault, required this.isLast});

  String _getSeverityLabel(double confidence) {
    if (confidence >= 0.7) return 'critical';
    if (confidence >= 0.4) return 'warning';
    return 'info';
  }

  @override
  Widget build(BuildContext context) {
    final confidencePercent = (fault.confidence * 100).round();
    final severity = _getSeverityLabel(fault.confidence);

    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 4 : 12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row: icon | name + severity | percentage
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.build,
                color: OBDTheme.accentBlue,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fault.fault.replaceAll('_', ' '),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: OBDTheme.textPrimary,
                      ),
                    ),
                    Text(
                      severity,
                      style: TextStyle(
                        fontSize: 12,
                        color: OBDTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '$confidencePercent%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: OBDTheme.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: fault.confidence,
              backgroundColor: const Color(0xFFE5E5E5),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(OBDTheme.accentBlue),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
