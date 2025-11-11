import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mind_ease_app/model/quiz_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizService {
  static const String baseUrl = 'https://mindease-backend-cyvy.onrender.com';

  Future<List<QuizQuestion>> fetchQuiz() async {
    final response = await http.get(Uri.parse('$baseUrl/quiz'));
    debugPrint("Response: ${response.statusCode}");
    debugPrint("Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> questionList = data['questions']['questions'];
      return questionList.map((e) => QuizQuestion.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load quiz');
    }
  }

  Future<Map<String, dynamic>> submitQuiz(List<dynamic> answers) async {
   final prefs = await SharedPreferences.getInstance();
   final token = prefs.getString('auth_token');
   final response = await http.post(
     Uri.parse('$baseUrl/submit'), 
     headers: {
       'Content-Type': 'application/json',
       if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
       'answers': answers, 
      }),
    );
    if (response.statusCode == 200) {
     return jsonDecode(response.body);
    } else {
     debugPrint('Error: ${response.statusCode} ${response.body}');
     throw Exception('Failed to submit quiz');
    }
  }
  
  Future<Map<String, dynamic>> fetchResult() async {
   try {
     final prefs = await SharedPreferences.getInstance();
     final token = prefs.getString('auth_token');

     if (token == null || token.isEmpty) {
       throw Exception('No token found in local storage');
      }

     final response = await http.get(
       Uri.parse('$baseUrl/result'),
       headers: {
         'Content-Type': 'application/json',
         'Authorization': 'Bearer $token',
        },
      );

     debugPrint(' Fetch result response: ${response.statusCode} ${response.body}');

     if (response.statusCode == 200) {
       return jsonDecode(response.body);
      } else {
       throw Exception('Failed to fetch result: ${response.statusCode}');
      }
    } catch (e) {
     debugPrint(' Error fetching result: $e');
     return {'success': false, 'message': e.toString()};
    }
  }
}
