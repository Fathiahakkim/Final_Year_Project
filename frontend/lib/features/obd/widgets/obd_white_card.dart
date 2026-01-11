import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../theme/obd_theme.dart';
import '../controllers/obd_controller.dart';

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

  Future<void> _handleUpload() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['log', 'txt', 'csv'],
      );

      if (result != null) {
        controller.uploadOBDData(result.files.single.path ?? '');
      }
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            'Manually upload an OBD data log file for review.',
            style: TextStyle(
              fontSize: 14,
              color: OBDTheme.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _handleUpload,
              style: ElevatedButton.styleFrom(
                backgroundColor: OBDTheme.accentBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                elevation: 0,
              ),
              child: const Text(
                'UPLOAD FILE',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
