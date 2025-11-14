import 'package:flutter/material.dart';

class QuizResultPage extends StatelessWidget {
  const QuizResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    debugPrint('Received arguments → $args'); 
    if (args == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            "No result data received",
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    
    final prediction = args['prediction'] ?? 'No prediction available';
    final confidence = args['confidence']?.toString() ?? 'N/A';
    final score = args['stress_score']?.toString() ?? '0';
    final recommendation =
        args['recommendation'] ?? 'No recommendation available';

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
            Text(
              "Prediction:",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(prediction, style: const TextStyle(fontSize: 18)),

            const SizedBox(height: 20),
            Text(
              "Stress Score: $score",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 15),
            Text(
              "Confidence: $confidence",
              style: const TextStyle(fontSize: 18, color: Colors.blueGrey),
            ),

            const SizedBox(height: 25),
            Text(
              "Recommendation:",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              recommendation,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
