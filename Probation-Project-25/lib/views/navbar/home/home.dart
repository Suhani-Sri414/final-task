import 'package:flutter/material.dart';
import 'package:mind_ease_app/controller/stats_controller.dart';

import 'package:mind_ease_app/views/navbar/home/profile_page.dart';
import 'package:mind_ease_app/views/navbar/home/quizz.dart';
import 'package:mind_ease_app/views/navbar/stats.dart';
import '../journal.dart';
import 'package:mind_ease_app/views/navbar/meditation.dart';
import 'package:mind_ease_app/views/navbar/ai_therapist.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _featuresKey = GlobalKey();
  final StatsController controller = StatsController(name: "User", quizScore: 0);


  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const SizedBox.shrink(),
      JournalPage(controller: controller),
      const MeditationPage(),
      const ChatbotPage(),
      const StatsPage(userName: 'widget.userName', quizScore: 82,),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 253, 247, 231),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 237, 228, 198),
        elevation: 1,
        title: Row(
          children: const [
            Text(
              "Mind",
              style: TextStyle(
                color: Color.fromARGB(255, 31, 58, 95),
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            Text(
              "Ease",
              style: TextStyle(
                color: Color.fromARGB(255, 33, 150, 84),
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ProfilePage()));
              },
              borderRadius: BorderRadius.circular(25),
              child: const CircleAvatar(
                backgroundColor: Color.fromARGB(255, 33, 150, 84),
                child: Icon(Icons.person, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: _selectedIndex == 0
          ? SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Center(
                    child: Column(
                      children: const [
                        Text(
                          "Your journey to inner peace starts here\nWelcome to your safe place for",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 31, 58, 95),
                            height: 1.5,
                          ),
                        ),
                        Text(
                          "mental peace",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 33, 150, 84),
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          "MindEase provides guided meditations, mood tracking, and a supportive\ncommunity to help you navigate life's challenges with calm and clarity.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.35,
                            color: Color.fromARGB(255, 31, 58, 95),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Scrollable.ensureVisible(
                              _featuresKey.currentContext!,
                              duration: const Duration(seconds: 1),
                              curve: Curves.easeInOut,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 33, 150, 84),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 12,
                            ),
                          ),
                          child: const Text(
                            "Explore Features",
                            style:
                                TextStyle(color: Color.fromARGB(255, 31, 58, 95)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Column(
                      children: const [
                        Text(
                          "Everything you need for",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 31, 58, 95),
                          ),
                        ),
                        Text(
                          "wellness",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 33, 150, 84),
                          ),
                        ),
                        Text(
                          "Comprehensive tools and resources to support your mental health journey",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 31, 58, 95),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    key: _featuresKey,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 20,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        FeatureCard(
                          iconPath: 'assets/icons/guided_meditation.png',
                          title: "Guided Meditations",
                          description:
                              "Calm your mind with guided sessions designed to reduce stress and increase focus.",
                          onTap: () {
                            Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => MeditationPage(),
  ),
);

                          },
                        ),
                        FeatureCard(
                          iconPath: 'assets/icons/daily_journal.png',
                          title: "Daily Journal",
                          description:
                              "Reflect on your thoughts and track your emotional growth through daily entries",
                          onTap: () {
                            Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => JournalPage(controller: controller),
  ),
);


                          },
                        ),
                        
                        
                        FeatureCard(
                          iconPath: 'assets/icons/ai_companion.png',
                          title: "AI Companion",
                          description:
                              "Chat with our AI-powered Therapist for real time emotional support.",
                              onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ChatbotPage()));
                          },
                        ),
                        FeatureCard(
                          iconPath: 'assets/icons/mental_wellness_check.png',
                          title: "Mental Wellness Check",
                          description:
                              "A short assessment that suggests whether you're doing fine, need extra self-care, or may benefit from talking to someone.",
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const QuizPage()));
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "Your feelings are valid.\nYour journey is important.\nWelcome to your SAFE SPACE.",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color: Color.fromARGB(255, 31, 58, 95),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image(
                                    image:
                                        AssetImage('assets/images/homepage2.jpg')),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image(
                                    image:
                                        AssetImage('assets/images/homepage1.jpg')),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "Your trusted companion for Mental Wellbeing. Find peace, build resilience, and connect with a supportive community.",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color: Color.fromARGB(255, 31, 58, 95),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor:  Color.fromARGB(255, 31, 58, 95),
        selectedItemColor: Color.fromARGB(255, 33, 150, 84),
        unselectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Journal'),
          BottomNavigationBarItem(icon: Icon(Icons.self_improvement), label: 'Meditation'),
          BottomNavigationBarItem(icon: Icon(Icons.smart_toy), label: 'AI Therapist'),
          BottomNavigationBarItem(icon: Icon(Icons.insert_chart), label: 'Stats'),
        ],
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final String iconPath;
  final String title;
  final String description;
  final VoidCallback? onTap;

  const FeatureCard({
    super.key,
    required this.iconPath,
    required this.title,
    required this.description,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: const Color.fromARGB(255, 253, 247, 231),
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(
          color: Color.fromARGB(255, 31, 58, 95), 
          width: 1, 
        ),
      ),
        
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(iconPath, height: 40, width: 40, fit: BoxFit.contain),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Color.fromARGB(255, 31, 58, 95),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color.fromARGB(255, 31, 58, 95),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
