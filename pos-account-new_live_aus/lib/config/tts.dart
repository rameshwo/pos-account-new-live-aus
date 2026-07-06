import 'package:text_to_speech/text_to_speech.dart';

class Tts {
  static TextToSpeech? _tts;

  static Future<void> _init() async {
    try {
      _tts = TextToSpeech();

      _tts!.setRate(0.9);
      _tts!.setVolume(1.0);

      // Try setting language safely
      try {
        _tts!.setLanguage('en-US');
      } catch (_) {
        // language not supported → ignore
      }
    } catch (e) {
      ///
    }
  }

  static Future<bool?> speak({required String text}) async {
    if (text.isEmpty) return null;
    if (_tts == null) await _init();

    try {
      if (_tts != null) return await _tts!.speak(text);
    } catch (e) {
      //
    }
    return null;
  }
}
