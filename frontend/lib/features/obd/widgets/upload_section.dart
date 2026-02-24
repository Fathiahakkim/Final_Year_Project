import 'package:flutter/material.dart';
import '../theme/obd_theme.dart';
import '../controllers/obd_controller.dart';

class UploadSection extends StatelessWidget {
  final OBDController controller;

  const UploadSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: controller.isUploading,
      builder: (context, isUploading, _) {
        return Container(
          margin: const EdgeInsets.symmetric(
            horizontal: OBDTheme.horizontalPadding,
          ),
          height: 50.0,
          decoration: BoxDecoration(
            color: isUploading
                ? OBDTheme.accentBlue.withOpacity(0.5)
                : OBDTheme.accentBlue,
            borderRadius: BorderRadius.circular(25.0),
            boxShadow: [
              BoxShadow(
                color: OBDTheme.accentBlue.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isUploading ? null : () => controller.pickAndUploadCSV(),
              borderRadius: BorderRadius.circular(25.0),
              child: Center(
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
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
