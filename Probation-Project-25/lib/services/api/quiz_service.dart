import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mind_ease_app/model/quiz_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizService {
  final String baseUrl = 'https://mindease-backend-cyvy.onrender.com';

  Future<List<QuizQuestion>> fetchQuiz(String profession) async {
  try {
    final endpoint = profession.toLowerCase().contains('student')
        ? 'studentquiz'
        : 'quiz';
    final url = Uri.parse('$baseUrl/$endpoint');

    debugPrint('Fetching quiz for $profession → $url');

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch quiz: HTTP ${response.statusCode}');
    }

    final data = json.decode(response.body);
    debugPrint('Full quiz response: $data');

    if (data['success'] != true) {
      throw Exception(
        'Failed to fetch quiz: ${data['message'] ?? 'Unknown error'}',
      );
    }

    
    final nestedQuestions = data['questions'];
    if (nestedQuestions == null || nestedQuestions['questions'] == null) {
      throw Exception('Invalid format: missing nested "questions" key');
    }

    final questionsData = nestedQuestions['questions'];

    if (questionsData is! List) {
      throw Exception('Invalid format: inner "questions" should be a List');
    }

    
    final questionsList = questionsData
        .whereType<Map<String, dynamic>>()
        .map((q) => Map<String, dynamic>.from(q))
        .toList();

    debugPrint('Parsed ${questionsList.length} questions successfully');

    
    final parsedQuestions =
        questionsList.map((q) => QuizQuestion.fromJson(q)).toList();

    return parsedQuestions;
  } catch (e, st) {
    debugPrint('Error in fetchQuiz: $e\n$st');
    return [];
  }
}




  
  Future<Map<String, dynamic>> submitQuiz(
      List<Map<String, dynamic>> answers, String profession) async {
    try {
      final endpoint = profession.toLowerCase().contains('student')
          ? 'stuquizsubmit'
          : 'submit';
      final url = Uri.parse('$baseUrl/$endpoint');

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null || token.isEmpty) {
  throw Exception('No auth token found');
}
      

      
final formattedAnswers = answers.map((a) => a['answer']).toList();

final body = json.encode({
  'answers': formattedAnswers,
});


      debugPrint('Submitting quiz → $url');
      debugPrint('Token Sent → $token');

      debugPrint('Payload: $body');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );
      debugPrint('Response → ${response.statusCode}');
    debugPrint('Body → ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      debugPrint('Quiz submitted successfully → $data');
      return data;
    } else {
      throw Exception(
          'Failed to submit quiz → ${response.statusCode} | ${response.body}');
    }
  } catch (e) {
    debugPrint('Error in submitQuiz: $e');
    throw Exception('Failed to submit quiz → $e');
  }
  }

  
  Future<Map<String, dynamic>> fetchResult() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final url = Uri.parse('$baseUrl/result');
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch result');
      }
    } catch (e, st) {
      debugPrint('Error fetching result: $e\n$st');
      return {'success': false, 'message': 'Failed to fetch result'};
    }
  }
}
