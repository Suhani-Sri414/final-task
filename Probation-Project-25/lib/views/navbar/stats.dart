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
    // 📱 Responsive Sizes
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

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
        padding: EdgeInsets.all(w * 0.04),
        child: ListView(
          children: [
            Text(
              "Welcome back, $userName",
              style: TextStyle(
                fontSize: w * 0.055,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: h * 0.01),

            _buildHealthScore(w, h),

            SizedBox(height: h * 0.02),

            Text(
              "How are you feeling today?",
              style: TextStyle(
                fontSize: w * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: h * 0.01),

            // ✅ RESPONSIVE WRAP INSTEAD OF ROW
            Wrap(
              alignment: WrapAlignment.spaceAround,
              spacing: w * 0.06,
              runSpacing: h * 0.02,
              children: moodIcons.entries.map((entry) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        entry.value,
                        color: moodColors[entry.key],
                        size: w * 0.11,
                      ),
                      onPressed: () {
                        setState(() {
                          controller.addMood(entry.key);
                        });
                      },
                    ),
                    Text(entry.key, style: TextStyle(fontSize: w * 0.035)),
                  ],
                );
              }).toList(),
            ),

            SizedBox(height: h * 0.02),

            Text(
              "Analysis",
              style: TextStyle(
                fontSize: w * 0.048,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: h * 0.01),

            _buildPieChart(w, h),

            SizedBox(height: h * 0.02),
            _buildTaskSection(w, h),

            SizedBox(height: h * 0.02),
            _buildRecentActivity(w),

            SizedBox(height: h * 0.02),
            _buildOverview(w, h),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // HEALTH SCORE
  // --------------------------------------------------------------------------
  Widget _buildHealthScore(double w, double h) {
    return Column(
      children: [
        Text(
          "Your Mental Health Score",
          style: TextStyle(fontSize: w * 0.05, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: h * 0.01),
        Text(
          "${_quizScore.toStringAsFixed(0)}%",
          style: TextStyle(
            fontSize: w * 0.07,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        SizedBox(height: h * 0.01),
        LinearProgressIndicator(
          value: (_quizScore.clamp(0.0, 100.0)) / 100,
          minHeight: h * 0.015,
          backgroundColor: Colors.grey.shade300,
          color: Colors.teal,
          borderRadius: BorderRadius.circular(10),
        ),
      ],
    );
  }

  // --------------------------------------------------------------------------
  // PIE CHART
  // --------------------------------------------------------------------------
  Widget _buildPieChart(double w, double h) {
    final moodData = controller.getMoodPercentages();
    if (moodData.isEmpty) {
      return const Center(child: Text("No mood data yet."));
    }

    final entries = moodData.entries.toList();

    return SizedBox(
      height: h * 0.28,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 0,
          sections: entries.asMap().entries.map((mapEntry) {
            final idx = mapEntry.key;
            final e = mapEntry.value;
            return PieChartSectionData(
              title: "${e.key} ${(e.value).toStringAsFixed(1)}%",
              value: e.value,
              color: Colors.primaries[idx % Colors.primaries.length],
              radius: w * 0.3,
              titleStyle: TextStyle(
                fontSize: w * 0.03,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // TASK SECTION
  // --------------------------------------------------------------------------
  Widget _buildTaskSection(double w, double h) {
    final taskTitles = [
      "Morning Meditation",
      "Journal Entry",
      "Evening Mood Check",
    ];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(w * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Today's Goals",
              style: TextStyle(
                fontSize: w * 0.05,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: h * 0.015),

            ...List.generate(taskTitles.length, (index) {
              return CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  taskTitles[index],
                  style: TextStyle(fontSize: w * 0.04),
                ),
                value: controller.user.taskCompletion[index],
                onChanged: null,
                activeColor: Colors.teal,
              );
            }),

            SizedBox(height: h * 0.015),
            const Divider(),

            Center(
              child: Column(
                children: [
                  LinearProgressIndicator(
                    minHeight: h * 0.015,
                    value: controller.getTaskCompletionPercentage() / 100,
                    color: Colors.teal,
                    backgroundColor: Colors.grey[200],
                  ),
                  SizedBox(height: h * 0.01),
                  Text(
                    "${controller.getTaskCompletionPercentage().toStringAsFixed(0)}% Completed",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: w * 0.04,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // RECENT ACTIVITY
  // --------------------------------------------------------------------------
  Widget _buildRecentActivity(double w) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(w * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Recent Activity",
              style: TextStyle(
                fontSize: w * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
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

  // --------------------------------------------------------------------------
  // OVERVIEW CARDS
  // --------------------------------------------------------------------------
  Widget _buildOverview(double w, double h) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _overviewCard("Daily Streak",
            "${controller.user.dailyStreak} days", Colors.greenAccent, w, h),
        _overviewCard(
            "Top Pages",
            "${controller.user.recentActivity.length}",
            Colors.orangeAccent,
            w,
            h),
        _overviewCard(
            "Total Moods",
            "${controller.user.moodCounts.values.fold(0, (a, b) => a + b)}",
            Colors.purpleAccent,
            w,
            h),
      ],
    );
  }

  Widget _overviewCard(
      String title, String value, Color color, double w, double h) {
    return Container(
      width: w * 0.28,
      padding: EdgeInsets.all(w * 0.03),
      decoration: BoxDecoration(
        color: color.withOpacity(0.25),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: w * 0.035)),
          SizedBox(height: h * 0.005),
          Text(value, style: TextStyle(fontSize: w * 0.05)),
        ],
      ),
    );
  }
}
