import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../theme/obd_theme.dart';
import '../controllers/obd_controller.dart';

class UploadSection extends StatelessWidget {
  final OBDController controller;

  const UploadSection({super.key, required this.controller});

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
      margin: const EdgeInsets.symmetric(
        horizontal: OBDTheme.horizontalPadding,
      ),
      height: 50.0,
      decoration: BoxDecoration(
        color: OBDTheme.accentBlue,
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
          onTap: _handleUpload,
          borderRadius: BorderRadius.circular(25.0),
          child: const Center(
            child: Text(
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
  }
}
