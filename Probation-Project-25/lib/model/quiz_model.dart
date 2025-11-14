

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

  final id = json['_id']?.toString() ?? json['id']?.toString() ?? json['field']?.toString() ??  '';

  // Handle different question text formats
  final questionText = json['question'] ??
      json['questiontext'] ??
      json['questionText'] ??
      'No question text';

  // Handle options coming from two formats:
  // 1. "options": {0: "No", 1: "Yes"}
  // 2. "scale": {0: "Never", 5: "Always"}
  List<String> options = [];

  if (json['options'] is Map) {
    options = (json['options'] as Map)
        .values
        .map((e) => e.toString())
        .toList();
  } else if (json['options'] is List) {
    options = (json['options'] as List)
        .map((e) => e.toString())
        .toList();
  } else if (json['scale'] is Map) {
    options = (json['scale'] as Map)
        .values
        .map((e) => e.toString())
        .toList();
  }

  return QuizQuestion(
    id: id,
    questionText: questionText,
    options: options,
  );
}



}
