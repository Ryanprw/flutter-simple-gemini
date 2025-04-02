import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIService {
  late final GenerativeModel model;
  late final ChatSession chat;

  AIService() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null) {
      throw Exception('API key tidak ditemukan! sesuaikan di .env');
    }

    model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 1,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 8192,
        responseMimeType: 'text/plain',
      ),
    );

    chat = model.startChat();
  }

  Future<String> sendMessage(String message) async {
    final response = await chat.sendMessage(Content.text(message));
    return response.text ?? "Maaf, saya tidak dapat memahami pesan ini.";
  }
}
