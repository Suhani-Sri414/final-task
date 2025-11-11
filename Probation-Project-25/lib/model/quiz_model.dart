class QuizQuestion {
  final int id;
  final String questionText;
  final List<String> options;
  
  QuizQuestion({
    required this.id,
    required this.questionText,
    required this.options,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'] ?? 0,
      questionText: json['questiontext'] ?? '',
      options: json['options'] != null
          ? List<String>.from(json['options'])
          : <String>[],
    );
  }
}
