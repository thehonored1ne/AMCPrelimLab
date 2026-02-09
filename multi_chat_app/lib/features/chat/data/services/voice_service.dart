import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'voice_service.g.dart';

class VoiceService {
  final SpeechToText _speech = SpeechToText();
  final FlutterTts _tts = FlutterTts();
  bool _isSpeechInitialized = false;

  static const Map<String, String> _languageMap = {
    'English': 'en-US',
    'Spanish': 'es-ES',
    'French': 'fr-FR',
    'German': 'de-DE',
    'Tagalog': 'tl-PH',
  };

  Future<bool> initSpeech({Function(bool)? onListeningStateChanged}) async {
    if (_isSpeechInitialized) return true;
    _isSpeechInitialized = await _speech.initialize(
      onStatus: (status) {
        if (onListeningStateChanged != null) {
          onListeningStateChanged(status == 'listening');
        }
      },
    );
    return _isSpeechInitialized;
  }

  Future<void> startListening({
    required Function(String) onResult,
    String? language,
  }) async {
    // CRITICAL: Stop TTS before starting to listen to prevent audio overlap
    await _tts.stop();
    
    String localeId = 'en-US';
    if (language != null && _languageMap.containsKey(language)) {
      localeId = _languageMap[language]!;
    }

    await _speech.listen(
      onResult: (result) => onResult(result.recognizedWords),
      localeId: localeId,
    );
  }

  Future<void> stopListening() async {
    await _speech.stop();
  }

  Future<void> speak(String text, {String? language}) async {
    // Stop any existing speech or listening before starting new TTS
    await _tts.stop();
    if (text.isNotEmpty) {
      String localeId = 'en-US';
      if (language != null && _languageMap.containsKey(language)) {
        localeId = _languageMap[language]!;
      }
      
      await _tts.setLanguage(localeId);
      await _tts.setPitch(1.0);
      await _tts.speak(text);
    }
  }

  Future<void> stopTts() async {
    await _tts.stop();
  }
}

@riverpod
VoiceService voiceService(VoiceServiceRef ref) {
  return VoiceService();
}
