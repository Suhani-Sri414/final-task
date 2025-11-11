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

  
  Future<void> loadQuiz() async {
    isLoading = true;
    notifyListeners();

    try {
      _questions = await _quizService.fetchQuiz();
    } catch (e) {
      debugPrint(' Error loading quiz: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

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

  Future<Map<String, dynamic>> submitAnswers() async {
    try {
      final List<dynamic> answersList = _userAnswers.values.toList();
      final result = await _quizService.submitQuiz(answersList);
      return result;
    } catch (e) {
      debugPrint(' Error submitting quiz: $e');
      return {'success': false, 'message': 'Failed to submit quiz'};
    }
  }

  Future<Map<String, dynamic>> fetchResult() async {
   try {
     final result = await _quizService.fetchResult();
     if (result['success'] == true && result['result'] != null) {
       final res = result['result'];
       final score = (res['score'] ?? 0).toDouble();
       await saveQuizScore(score);
       debugPrint(' Quiz score saved locally: $score');
       debugPrint(' Full API Result: ${result['result']}');
       notifyListeners();

       return {
         'success': true,
         'prediction': res['prediction'] ?? 'No prediction',
         'confidence': res['probability'] != null
            ? '${(res['probability'] * 100).toStringAsFixed(1)}%'
            : 'N/A',
         'score': score,
         'score_text': res['score_text'] ?? '',
        };
      } else {
       debugPrint('Invalid quiz result response: $result');
       return {
         'success': false,
         'message': 'Invalid response format',
         'score': 0.0
        };
      }
    } catch (e) {
     debugPrint('Error fetching result: $e');
     return {
       'success': false,
       'message': 'Failed to fetch result',
       'score': 0.0
      };
    }
  }
  
  Future<void> saveQuizScore(double score) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('quiz_score', score);
      debugPrint(' Score saved in SharedPreferences: $score');
    } catch (e) {
      debugPrint(' Error saving quiz score: $e');
    }
  }

  Future<double> loadQuizScore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedScore = prefs.getDouble('quiz_score') ?? 0.0;
      debugPrint(' Loaded quiz score from storage: $storedScore');
      return storedScore;
    } catch (e) {
      debugPrint(' Error loading quiz score: $e');
      return 0.0;
    }
  }
}
