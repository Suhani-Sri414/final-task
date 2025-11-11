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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 253, 247, 231),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 253, 247, 231),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Guided meditations for mental wellness",
                style: TextStyle(
                  color: Color.fromARGB(255, 31, 58, 95),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "You don't have to face this alone. These specially designed meditations are here to support you through difficult times.",
              style: TextStyle(
                  color: Color.fromARGB(255, 31, 58, 95), fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            
            Center(
              child: Column(
                children: [
                  Text(
                    _formatTime(_seconds),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 33, 150, 84),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _isMeditating ? null : _startTimer,
                        icon: const Icon(Icons.play_arrow),
                        label: const Text("Start"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 33, 150, 84),
                          foregroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: _isMeditating ? _stopTimer : null,
                        icon: const Icon(Icons.stop),
                        label: const Text("Stop"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 220, 80, 60),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              "Choose your practice",
              style: TextStyle(
                  color: Color.fromARGB(255, 31, 58, 95),
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 0.6,
              children: [
                meditationCard(
                    title: "Loving-Kindness (Metta)",
                    description:
                        "Cultivates self-compassion and kindness towards yourself.",
                    imagePath: "assets/images/m1.png",
                    url: "https://www.youtube.com/embed/-d_AA9H4z9U"),
                meditationCard(
                    title: "Breathing for Calm",
                    description:
                        "Breathing techniques to centre yourself and find relief.",
                    imagePath: "assets/images/m2.png",
                    url: "https://www.youtube.com/embed/VUjiXcfKBn8"),
                meditationCard(
                    title: "Body Scan for Depression",
                    description:
                        "Reconnect with your body and release tension.",
                    imagePath: "assets/images/m3.png",
                    url: "https://www.youtube.com/embed/_DTmGtznab4"),
                meditationCard(
                    title: "Anxiety Relief Meditation",
                    description:
                        "Calm anxious thoughts and bring peace to your mind.",
                    imagePath: "assets/images/m4.png",
                    url: "https://www.youtube.com/embed/O-6f5wQXSu8"),
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
    return GestureDetector(
      onTap: () {
        _launchURL(url);
        _startTimer();
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                child: Image.asset(
                  imagePath,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              Text(title,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 31, 58, 95),
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
              const SizedBox(height: 4),
              Expanded(
                child: Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(255, 31, 58, 95),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              ElevatedButton(
                onPressed: () {
                  _launchURL(url);
                  _startTimer();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 33, 150, 84),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Start Session",
                    style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
