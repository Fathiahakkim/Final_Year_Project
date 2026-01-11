import 'package:permission_handler/permission_handler.dart';

class VoicePermission {
  const VoicePermission();

  /// Requests microphone permission.
  /// Returns true if permission is granted.
  Future<bool> requestMicrophonePermission() async {
    final status = await Permission.microphone.status;

    if (status.isGranted) {
      return true;
    }

    final result = await Permission.microphone.request();
    return result.isGranted;
  }

  /// Checks whether microphone permission is already granted.
  Future<bool> isMicrophoneGranted() async {
    return Permission.microphone.isGranted;
  }
}
