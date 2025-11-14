import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mind_ease_app/controller/stats_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({
    super.key,
    required String userName,
    required int quizScore,
  });

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  late StatsController controller;
  String userName = "";
  bool isLoading = true;
  double _quizScore = 0.0;

  @override
  void initState() {
    super.initState();
    _loadUserAndInit();
  }

  Future<void> _loadUserAndInit() async {
    setState(() => isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_name') ?? "User";
    final storedScore = prefs.getDouble('quiz_score') ?? 0.0;

    controller = StatsController(name: name, quizScore: storedScore);
    await controller.loadData();

    setState(() {
      userName = name;
      _quizScore = storedScore;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final moodIcons = {
      'Happy': Icons.sentiment_satisfied_alt,
      'Sad': Icons.sentiment_dissatisfied,
      'Angry': Icons.sentiment_very_dissatisfied,
      'Calm': Icons.sentiment_neutral,
      'Anxious': Icons.sentiment_very_dissatisfied_rounded,
    };

    final moodColors = {
      'Happy': Colors.green,
      'Sad': Colors.blueGrey,
      'Angry': Colors.redAccent,
      'Calm': Colors.amber,
      'Anxious': Colors.orangeAccent,
    };

    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFFDF6EC),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFDF6EC),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            Text(
              "Welcome back, $userName",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildHealthScore(),
            const SizedBox(height: 20),
            const Text(
              "How are you feeling today?",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: moodIcons.entries.map((entry) {
                return Column(
                  children: [
                    IconButton(
                      icon: Icon(entry.value, color: moodColors[entry.key]),
                      iconSize: 36,
                      onPressed: () {
                        setState(() {
                          controller.addMood(entry.key);
                        });
                      },
                    ),
                    Text(entry.key),
                  ],
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              "Analysis",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildPieChart(),
            const SizedBox(height: 20),
            _buildTaskSection(),
            const SizedBox(height: 20),
            _buildRecentActivity(),
            const SizedBox(height: 20),
            _buildOverview(),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthScore() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Your Mental Health Score",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          "${_quizScore.toStringAsFixed(0)}%",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: (_quizScore.clamp(0.0, 100.0)) / 100, 
          backgroundColor: Colors.grey.shade300,
          color: Colors.teal,
          minHeight: 8, 
          borderRadius: BorderRadius.circular(
            10,
          ), 
        ),
      ],
    );
  }

  Widget _buildPieChart() {
    final moodData = controller.getMoodPercentages();
    if (moodData.isEmpty) {
      return const Center(child: Text("No mood data yet."));
    }

    final entries = moodData.entries.toList();
    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: entries.asMap().entries.map((mapEntry) {
            final idx = mapEntry.key;
            final e = mapEntry.value;
            final color = Colors.primaries[idx % Colors.primaries.length];
            return PieChartSectionData(
              title: "${e.key} ${(e.value).toStringAsFixed(1)}%",
              value: e.value,
              color: color,
              radius: 120,
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          }).toList(),
          sectionsSpace: 2,
          centerSpaceRadius: 0,
        ),
      ),
    );
  }

  Widget _buildTaskSection() {
    final taskTitles = [
      "Morning Meditation",
      "Journal Entry",
      "Evening Mood Check",
    ];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Today's Goals",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            ...List.generate(taskTitles.length, (index) {
              return CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  taskTitles[index],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                value: controller.user.taskCompletion[index],
                activeColor: Colors.teal,
                onChanged: null,
              );
            }),
            const SizedBox(height: 12),
            const Divider(),
            Center(
              child: Column(
                children: [
                  LinearProgressIndicator(
                    minHeight: 10,
                    value: controller.getTaskCompletionPercentage() / 100,
                    color: Colors.teal,
                    backgroundColor: Colors.grey[200],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${controller.getTaskCompletionPercentage().toStringAsFixed(0)}% Completed",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Recent Activity",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (controller.user.recentActivity.isEmpty)
              const Text("No recent activity yet.")
            else
              ...controller.user.recentActivity
                  .map((page) => Text("• $page"))
                  .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverview() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _overviewCard(
          "Daily Streak",
          "${controller.user.dailyStreak} days",
          Colors.greenAccent,
        ),
        _overviewCard(
          "Top Pages",
          "${controller.user.recentActivity.length}",
          Colors.orangeAccent,
        ),
        _overviewCard(
          "Total Moods",
          "${controller.user.moodCounts.values.fold(0, (a, b) => a + b)}",
          Colors.purpleAccent,
        ),
      ],
    );
  }

  Widget _overviewCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: 100,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
