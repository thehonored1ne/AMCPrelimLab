import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

part 'gemini_service.g.dart';

class GeminiService {
  late GenerativeModel _model;
  final String _apiKey;

  GeminiService(this._apiKey);

  void initModel({required String systemInstruction, bool isVision = false}) {
    // Model 'gemini-3-flash' does not exist. Switching back to 'gemini-1.5-flash'.
    _model = GenerativeModel(
      model: 'gemini-2.5-flash-lite',
      apiKey: _apiKey,
      generationConfig: GenerationConfig(temperature: 0.7),
      systemInstruction: Content.system(systemInstruction),
    );
  }

  Stream<GenerateContentResponse> streamChat(
      List<Content> history,
      String message,
      [List<Uint8List>? imageBytes]
      ) async* {

    final chat = _model.startChat(history: history);

    final content = imageBytes != null && imageBytes.isNotEmpty
        ? Content.multi([
      TextPart(message),
      ...imageBytes.map((bytes) => DataPart('image/jpeg', bytes))
    ])
        : Content.text(message);

    yield* chat.sendMessageStream(content);
  }
}

@riverpod
GeminiService geminiService(GeminiServiceRef ref) {
  final apiKey = dotenv.env['API_KEY'] ?? "";
  return GeminiService(apiKey);
}
