class UserModel {
  String name;
  double quizScore;
  Map<String, int> moodCounts; 
  List<String> recentActivity;
  int dailyStreak;
  List<bool> taskCompletion; 

  UserModel({
    required this.name,
    required this.quizScore,
    required this.moodCounts,
    required this.recentActivity,
    required this.dailyStreak,
    required this.taskCompletion,
  });
}

