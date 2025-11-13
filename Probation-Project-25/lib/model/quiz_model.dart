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
    return QuizQuestion(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      questionText: json['questiontext'] ?? json['question'] ?? '',
      options: (json['options'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}
