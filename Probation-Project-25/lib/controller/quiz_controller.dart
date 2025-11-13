import 'package:flutter/material.dart';
import 'package:mind_ease_app/model/quiz_model.dart';
import 'package:mind_ease_app/services/api/quiz_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizController with ChangeNotifier {
  final QuizService _quizService = QuizService();

  List<QuizQuestion> _questions = [];
  int _currentIndex = 0;
  final Map<String, String> _userAnswers = {};
  bool isLoading = false;

  List<QuizQuestion> get questions => _questions;
  int get currentIndex => _currentIndex;
  QuizQuestion get currentQuestion => _questions[_currentIndex];
  Map<String, String> get userAnswers => _userAnswers;

  /// ✅ Load quiz dynamically (auto-detects profession)
  Future<void> loadQuiz() async {
  isLoading = true;
  notifyListeners();

  try {
    final prefs = await SharedPreferences.getInstance();
    final profession = prefs.getString('profession') ?? 'student';
    debugPrint('👤 Loading quiz for: $profession');

    _questions = await _quizService.fetchQuiz(profession);

    debugPrint('✅ Loaded ${_questions.length} questions');
  } catch (e) {
    debugPrint('❌ Error loading quiz: $e');
    _questions = [];
  } finally {
    isLoading = false;
    notifyListeners();
  }
}


  /// ✅ Handle answer selection
  void answerQuestion(String questionId, String answer) {
    _userAnswers[questionId] = answer;
    notifyListeners();
  }

  void nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (_currentIndex > 0) {
      _currentIndex--;
      notifyListeners();
    }
  }

  /// ✅ Submit quiz dynamically based on saved profession
  Future<void> submitQuiz(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profession = prefs.getString('profession') ?? 'student';

      // Convert user answers for backend format
      final formattedAnswers = _userAnswers.entries
          .map((e) => {'questionId': e.key, 'answer': e.value})
          .toList();

      debugPrint('📤 Submitting ${formattedAnswers.length} answers for $profession');

      final result = await _quizService.submitQuiz(formattedAnswers, profession);

      debugPrint('✅ Quiz submitted successfully → $result');

      if (!context.mounted) return;

      Navigator.pushReplacementNamed(
        context,
        '/quizResult',
        arguments: result,
      );
    } catch (e, st) {
      debugPrint('❌ Error submitting quiz: $e\n$st');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error submitting quiz')),
        );
      }
    }
  }

  /// ✅ Fetch quiz result dynamically (auto-selects based on profession)
  Future<Map<String, dynamic>> fetchResult() async {
    try {
      final result = await _quizService.fetchResult();

      if (result['success'] == true) {
        final res = result['result'] ?? result;

        final score = (res['stress_score'] ?? res['score'] ?? 0).toDouble();
        await saveQuizScore(score);

        debugPrint('💾 Quiz score saved: $score');

        return {
          'success': true,
          'prediction': res['prediction'] ?? 'No prediction',
          'stress_level': res['stress_level'] ?? '',
          'confidence': res['confidence'] ?? '',
          'stress_score': res['stress_score'] ?? '',
          'recommendation':
              res['recommendation'] ?? res['score_text'] ?? 'No data available',
        };
      } else {
        return {'success': false, 'message': 'Invalid response'};
      }
    } catch (e, st) {
      debugPrint('❌ Error fetching result: $e\n$st');
      return {'success': false, 'message': 'Failed to fetch result'};
    }
  }

  /// ✅ Save and Load Quiz Score
  Future<void> saveQuizScore(double score) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('quiz_score', score);
  }

  Future<double> loadQuizScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('quiz_score') ?? 0.0;
  }
}
