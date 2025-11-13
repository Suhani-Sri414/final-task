import 'package:flutter/material.dart';

class QuizResultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final result = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz Result"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("🧠 Stress Level: ${result['stress_level']}", 
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Text("📊 Stress Score: ${result['stress_score'].toStringAsFixed(2)}", 
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 15),
            const Text("Confidence Levels:", 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("• Low: ${(result['confidence']['low'] * 100).toStringAsFixed(1)}%"),
            Text("• Moderate: ${(result['confidence']['moderate'] * 100).toStringAsFixed(1)}%"),
            Text("• High: ${(result['confidence']['high'] * 100).toStringAsFixed(1)}%"),
            const SizedBox(height: 25),
            Text("💡 Recommendation:",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(result['recommendation'], style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
