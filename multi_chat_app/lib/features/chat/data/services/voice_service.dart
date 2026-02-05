import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'voice_service.g.dart';

class VoiceService {
  final SpeechToText _speech = SpeechToText();
  final FlutterTts _tts = FlutterTts();
  bool _isSpeechInitialized = false;

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
  }) async {
    // CRITICAL: Stop TTS before starting to listen to prevent audio overlap
    // This ensures the AI isn't speaking while the user is trying to talk to the mic.
    await _tts.stop();
    
    await _speech.listen(
      onResult: (result) => onResult(result.recognizedWords),
    );
  }

  Future<void> stopListening() async {
    await _speech.stop();
  }

  Future<void> speak(String text) async {
    // Stop any existing speech or listening before starting new TTS
    await _tts.stop();
    if (text.isNotEmpty) {
      await _tts.setLanguage("en-US");
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
