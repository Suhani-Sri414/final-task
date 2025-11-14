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

    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final t = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Quiz Result",
          style: TextStyle(fontSize: 18 * t, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(w * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Prediction title
            Text(
              "Prediction:",
              style: TextStyle(
                fontSize: 20 * t,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: h * 0.01),

            // Prediction text (wrapped for small screens)
            Text(
              prediction,
              style: TextStyle(fontSize: 18 * t),
            ),

            SizedBox(height: h * 0.03),

            // Stress Score
            Text(
              "Stress Score: $score",
              style: TextStyle(
                fontSize: 18 * t,
                fontWeight: FontWeight.w500,
              ),
            ),

            SizedBox(height: h * 0.02),

            // Confidence
            Text(
              "Confidence: $confidence",
              style: TextStyle(
                fontSize: 18 * t,
                color: Colors.blueGrey,
              ),
            ),

            SizedBox(height: h * 0.03),

            // Recommendation title
            Text(
              "Recommendation:",
              style: TextStyle(
                fontSize: 18 * t,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: h * 0.01),

            // Wrapped recommendation text
            Text(
              recommendation,
              style: TextStyle(
                fontSize: 16 * t,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
