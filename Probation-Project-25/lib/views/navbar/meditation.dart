import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mind_ease_app/controller/stats_controller.dart';

class MeditationPage extends StatefulWidget {
  const MeditationPage({super.key});

  @override
  State<MeditationPage> createState() => _MeditationPageState();
}

class _MeditationPageState extends State<MeditationPage> {
  late StatsController controller;
  Timer? _timer;
  int _seconds = 0;
  bool _isMeditating = false;

  @override
  void initState() {
    super.initState();
    controller = StatsController(name: "User", quizScore: 0);
    controller.loadData();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_isMeditating) return;
    setState(() {
      _isMeditating = true;
      _seconds = 0;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _stopTimer() {
    if (!_isMeditating) return;
    _timer?.cancel();
    setState(() {
      _isMeditating = false;
    });
    controller.updateRecentActivity("Meditation Session");
    controller.saveData();
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textScale = MediaQuery.of(context).textScaler.scale(1.0);

    final padding = width * 0.05;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 253, 247, 231),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Guided meditations for mental wellness",
                style: TextStyle(
                  color: const Color.fromARGB(255, 31, 58, 95),
                  fontSize: 22 * textScale,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: height * 0.015),

            Text(
              "You don't have to face this alone. These specially designed meditations are here to support you through difficult times.",
              style: TextStyle(
                color: const Color.fromARGB(255, 31, 58, 95),
                fontSize: 12 * textScale,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: height * 0.03),

            Center(
              child: Column(
                children: [
                  Text(
                    _formatTime(_seconds),
                    style: TextStyle(
                      fontSize: 32 * textScale,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 33, 150, 84),
                    ),
                  ),

                  SizedBox(height: height * 0.01),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _isMeditating ? null : _startTimer,
                        icon: const Icon(Icons.play_arrow),
                        label: Text(
                          "Start",
                          style: TextStyle(fontSize: 14 * textScale),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 33, 150, 84),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.06,
                            vertical: height * 0.012,
                          ),
                        ),
                      ),

                      SizedBox(width: width * 0.03),

                      ElevatedButton.icon(
                        onPressed: _isMeditating ? _stopTimer : null,
                        icon: const Icon(Icons.stop),
                        label: Text(
                          "Stop",
                          style: TextStyle(fontSize: 14 * textScale),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 220, 80, 60),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.06,
                            vertical: height * 0.012,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: height * 0.035),

            Text(
              "Choose your practice",
              style: TextStyle(
                color: const Color.fromARGB(255, 31, 58, 95),
                fontSize: 17 * textScale,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: height * 0.02),

            GridView.count(
              crossAxisCount: width > 600 ? 3 : 2, // Responsive grid
              crossAxisSpacing: width * 0.03,
              mainAxisSpacing: width * 0.03,
              shrinkWrap: true,
              childAspectRatio: width > 600 ? 0.85 : 0.6,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                meditationCard(
                  title: "Loving-Kindness (Metta)",
                  description:
                      "Cultivates self-compassion and kindness towards yourself.",
                  imagePath: "assets/images/m1.png",
                  url: "https://www.youtube.com/embed/-d_AA9H4z9U",
                ),
                meditationCard(
                  title: "Breathing for Calm",
                  description:
                      "Breathing techniques to centre yourself and find relief.",
                  imagePath: "assets/images/m2.png",
                  url: "https://www.youtube.com/embed/VUjiXcfKBn8",
                ),
                meditationCard(
                  title: "Body Scan for Depression",
                  description:
                      "Reconnect with your body and release tension.",
                  imagePath: "assets/images/m3.png",
                  url: "https://www.youtube.com/embed/_DTmGtznab4",
                ),
                meditationCard(
                  title: "Anxiety Relief Meditation",
                  description:
                      "Calm anxious thoughts and bring peace to your mind.",
                  imagePath: "assets/images/m4.png",
                  url: "https://www.youtube.com/embed/O-6f5wQXSu8",
                ),
                meditationCard(
                  title: "Sleep Meditation",
                  description:
                      "Gentle guidance to help you let go of the day's worries and drift into peaceful, restorative sleep.\n\nBenefits:\n• Improves sleep quality\n• Eases insomnia\n• Calms nighttime anxiety",
                  imagePath: "assets/images/m5.png",
                  url: "https://www.youtube.com/embed/g0jfhRcXtLQ",
                ),
                meditationCard(
                  title: "Mindful Walking",
                  description:
                      "A moving meditation that combines gentle movement with mindfulness.\n\nBenefits:\n• Includes movement\n• Boosts mood naturally\n• Great for restless energy",
                  imagePath: "assets/images/m6.png",
                  url: "https://www.youtube.com/embed/NfPBlRE4RIc",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget meditationCard({
    required String title,
    required String description,
    required String imagePath,
    required String url,
  }) {
    final width = MediaQuery.of(context).size.width;
    final textScale = MediaQuery.of(context).textScaler.scale(1.0);

    return GestureDetector(
      onTap: () {
        _launchURL(url);
        _startTimer();
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.all(width * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                child: Image.asset(
                  imagePath,
                  height: width * 0.25,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              SizedBox(height: width * 0.02),

              Text(
                title,
                style: TextStyle(
                  color: const Color.fromARGB(255, 31, 58, 95),
                  fontWeight: FontWeight.bold,
                  fontSize: 15 * textScale,
                ),
              ),

              SizedBox(height: width * 0.015),

              Expanded(
                child: Text(
                  description,
                  style: TextStyle(
                    fontSize: 12 * textScale,
                    color: const Color.fromARGB(255, 31, 58, 95),
                  ),
                ),
              ),

              SizedBox(height: width * 0.02),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _launchURL(url);
                    _startTimer();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 33, 150, 84),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: width * 0.02,
                    ),
                  ),
                  child: Text(
                    "Start Session",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12 * textScale,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
