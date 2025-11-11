import 'package:shared_preferences/shared_preferences.dart';
import '../model/stats_model.dart';
import 'dart:convert';

class StatsController {
  late UserModel user;

  StatsController({required String name, required double quizScore}) {
    user = UserModel(
      name: name,
      quizScore: quizScore,
      moodCounts: {
        'Happy': 0,
        'Sad': 0,
        'Angry': 0,
        'Calm': 0,
        'Anxious': 0,
      },
      recentActivity: [],
      dailyStreak: 0,
      taskCompletion: [false, false, false], 
    );
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    final moodsJson = prefs.getString('moods');
    final recentJson = prefs.getString('recentActivity');
    final tasksJson = prefs.getString('tasks');
    final streak = prefs.getInt('streak');

    if (moodsJson != null ||recentJson != null ||tasksJson != null ||streak != null) {
      user = UserModel(
        name: user.name,
        quizScore: user.quizScore,
        moodCounts: moodsJson != null
            ? Map<String, int>.from(jsonDecode(moodsJson))
            : user.moodCounts,
        recentActivity: recentJson != null
            ? List<String>.from(jsonDecode(recentJson))
            : user.recentActivity,
        dailyStreak: streak ?? user.dailyStreak,
        taskCompletion: tasksJson != null
            ? List<bool>.from(jsonDecode(tasksJson))
            : user.taskCompletion,
      );
    }
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('moods', jsonEncode(user.moodCounts));
    await prefs.setString('recentActivity', jsonEncode(user.recentActivity));
    await prefs.setInt('streak', user.dailyStreak);
    await prefs.setString('tasks', jsonEncode(user.taskCompletion));
  }

  Future<void> saveTasks() async => saveData();

  void addMood(String mood) {
    user.moodCounts[mood] = (user.moodCounts[mood] ?? 0) + 1;
    _completeMoodTask(); 
    saveData();
  }

  void _setTaskCompleted(int index) {
    if (!user.taskCompletion[index]) {
      user.taskCompletion[index] = true;
      saveData();
    }
  }

  void completeMeditationTask() {
    _setTaskCompleted(0);
  }

  void completeJournalTask() {
    _setTaskCompleted(1);
  }

  void _completeMoodTask() {
    _setTaskCompleted(2);
  }

  void toggleTask(int index) {
    user.taskCompletion[index] = !user.taskCompletion[index];
    saveData();
  }

  void autoCheckJournalTask() {
   if (!user.taskCompletion[1]) { 
     user.taskCompletion[1] = true;
     saveData();
    }
  }

  double getTaskCompletionPercentage() {
    final completed = user.taskCompletion.where((e) => e).length;
    return (completed / user.taskCompletion.length) * 100;
  }

  void updateRecentActivity(String page) {
    if (!user.recentActivity.contains(page)) {
      user.recentActivity.insert(0, page);
      if (user.recentActivity.length > 3) {
        user.recentActivity = user.recentActivity.sublist(0, 3);
      }
      saveData();
    }
  }

  void updateStreak(bool visitedToday) {
    if (visitedToday) {
      user.dailyStreak += 1;
    } else {
      user.dailyStreak = 0;
    }
    saveData();
  }

  Map<String, double> getMoodPercentages() {
    final total = user.moodCounts.values.fold(0, (a, b) => a + b);
    if (total == 0) return {};
    return user.moodCounts.map((k, v) => MapEntry(k, (v / total) * 100));
  }
}
