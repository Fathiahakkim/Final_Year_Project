import 'package:flutter/material.dart';
import '../theme/obd_theme.dart';
import '../controllers/obd_controller.dart';
import '../models/obd_prediction_model.dart';

class OBDWhiteCard extends StatelessWidget {
  final double cardHeight;
  final double keyboardHeight;
  final OBDController controller;

  const OBDWhiteCard({
    super.key,
    required this.cardHeight,
    required this.keyboardHeight,
    required this.controller,
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

          // Upload button — delegates to controller
          ValueListenableBuilder<bool>(
            valueListenable: controller.isUploading,
            builder: (context, isUploading, _) {
              return SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isUploading ? null : () => controller.pickAndUploadCSV(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: OBDTheme.accentBlue,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: OBDTheme.accentBlue.withOpacity(0.5),
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

          // Error message
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
                    Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
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

          // Prediction results
          ValueListenableBuilder<OBDPredictionResult?>(
            valueListenable: controller.predictionResult,
            builder: (context, result, _) {
              if (result == null) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'Detected Faults',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: OBDTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...result.topFaults.map(
                    (fault) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: OBDTheme.accentBlue.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: OBDTheme.accentBlue.withOpacity(0.15),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                fault.fault.replaceAll('_', ' '),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: OBDTheme.textPrimary,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: OBDTheme.accentBlue.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${(fault.confidence * 100).toStringAsFixed(1)}%',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: OBDTheme.accentBlue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
