

import 'package:flutter/material.dart';

class QuizQuestion {
  final String id;
  final String questionText;
  final List<String> options;

  QuizQuestion({
    required this.id,
    required this.questionText,
    required this.options,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
  debugPrint('Parsing question JSON: $json');
  final id = json['_id']?.toString() ?? json['id']?.toString() ?? '';
  final questionText = json['questiontext'] ??
      json['question'] ??
      json['questionText'] ??
      'No question text';
  final options = (json['options'] as List?)?.map((e) => e.toString()).toList() ?? [];
  return QuizQuestion(id: id, questionText: questionText, options: options);
}


}
