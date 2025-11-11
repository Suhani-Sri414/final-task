import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatbotService {
  final String baseUrl = 'https://mindbot-1eic.onrender.com';

  Future<String?> sendMessage(String userMessage, String sessionId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'session_id': sessionId,
          'query': userMessage, 
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'];
      } else {
        return 'Server error: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
}
