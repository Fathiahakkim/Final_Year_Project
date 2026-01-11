import 'package:speech_to_text/speech_to_text.dart';

typedef SpeechResultCallback = void Function(String text);

class SpeechService {
  final SpeechToText _speechToText = SpeechToText();
  bool _isInitialized = false;

  bool get isListening => _speechToText.isListening;

  /// Initializes the speech engine.
  /// Must be called before listening.
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    final available = await _speechToText.initialize();
    _isInitialized = available;
    return available;
  }

  /// Starts listening and returns recognized text via callback.
  Future<void> startListening({required SpeechResultCallback onResult}) async {
    if (!_isInitialized) {
      throw StateError('SpeechService not initialized');
    }

    await _speechToText.listen(
      onResult: (result) {
        if (result.finalResult) {
          onResult(result.recognizedWords);
        }
      },
    );
  }

  /// Stops listening.
  Future<void> stopListening() async {
    if (_speechToText.isListening) {
      await _speechToText.stop();
    }
  }
}
