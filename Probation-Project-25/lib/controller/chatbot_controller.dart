import 'package:mind_ease_app/services/api/chatbot_service.dart';

class ChatbotController {
  final ChatbotService _chatbotService = ChatbotService();

  Future<String> getChatbotResponse(String message, String sessionId) async {
    try {
      final response = await _chatbotService.sendMessage(message, sessionId);
      return response ?? 'No response from chatbot.';
    } catch (e) {
      return 'Error: $e';
    }
  }
}
