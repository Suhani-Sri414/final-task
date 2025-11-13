import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mind_ease_app/model/quiz_model.dart';
import 'package:mind_ease_app/services/api_constants.dart';

class QuizService {
  static const String baseUrl = '${ApiConstants.baseUrl}';

  // ✅ Fetch quiz based on profession
  Future<List<QuizQuestion>> fetchQuiz([String profession = 'student']) async {
    try {
      final url = Uri.parse('$baseUrl/${profession.toLowerCase()}quiz');
      print('📩 Fetching quiz for $profession at $url');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('✅ Quiz fetched successfully with ${data.length} keys');

        if (data['quizzes'] != null && data['quizzes'] is List) {
          final quizzes = data['quizzes'] as List;
          return quizzes.map((e) => QuizQuestion.fromJson(e)).toList();
        } else if (data['questions'] != null && data['questions'] is List) {
          final questions = data['questions'] as List;
          return questions.map((e) => QuizQuestion.fromJson(e)).toList();
        } else {
          throw Exception('Unexpected data format: $data');
        }
      } else {
        throw Exception('Failed to fetch quiz: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error in fetchQuiz: $e');
      rethrow;
    }
  }

  // ✅ Submit quiz
  Future<Map<String, dynamic>> submitQuiz(
      List<Map<String, dynamic>> answers, String profession) async {
    final url = Uri.parse('$baseUrl/${profession.toLowerCase()}quizresult');
    print('📤 Submitting quiz to $url');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'answers': answers}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('❌ Error submitting quiz: ${response.statusCode}');
      throw Exception('Failed to submit quiz');
    }
  }

  // ✅ Fetch result (optional for now)
  Future<Map<String, dynamic>> fetchResult() async {
    final url = Uri.parse('$baseUrl/quizresult');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch result');
    }
  }
}
