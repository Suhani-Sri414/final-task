import 'dart:convert';
import 'package:http/http.dart' as http;

class JournalService {
  final String baseUrl = 'https://mindease-backend-cyvy.onrender.com';

  Future<http.Response> submitJournal(String token, String text) {
    final url = Uri.parse('$baseUrl/journal');
    return http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'text': text}),
    );
  }

  Future<http.Response> fetchJournals(String token) {
    final url = Uri.parse('$baseUrl/getjournal');
    return http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }
}
