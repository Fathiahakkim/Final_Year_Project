import 'voice_permission.dart';
import 'speech_service.dart';

typedef VoiceTextCallback = void Function(String text);

class VoiceController {
  final VoicePermission _permission;
  final SpeechService _speechService;

  VoiceController({VoicePermission? permission, SpeechService? speechService})
    : _permission = permission ?? const VoicePermission(),
      _speechService = speechService ?? SpeechService();

  bool get isListening => _speechService.isListening;

  /// Starts the voice-to-text flow.
  /// - Requests microphone permission
  /// - Initializes speech engine
  /// - Emits final recognized text via callback
  Future<void> start({required VoiceTextCallback onText}) async {
    final granted = await _permission.requestMicrophonePermission();
    if (!granted) {
      return;
    }

    final initialized = await _speechService.initialize();
    if (!initialized) {
      return;
    }

    await _speechService.startListening(onResult: onText);
  }

  /// Stops listening if active.
  Future<void> stop() async {
    await _speechService.stopListening();
  }
}
