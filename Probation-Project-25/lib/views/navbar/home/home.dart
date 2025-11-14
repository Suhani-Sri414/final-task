import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      const StatsPage(userName: 'widget.userName', quizScore: 82),
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
          children: [
            Text(
              "Mind",
              style: TextStyle(
                color: const Color.fromARGB(255, 31, 58, 95),
                fontWeight: FontWeight.bold,
                fontSize: 22.sp,
              ),
            ),
            Text(
              "Ease",
              style: TextStyle(
                color: const Color.fromARGB(255, 33, 150, 84),
                fontWeight: FontWeight.bold,
                fontSize: 22.sp,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ProfilePage()));
              },
              borderRadius: BorderRadius.circular(25.r),
              child: CircleAvatar(
                backgroundColor: const Color.fromARGB(255, 33, 150, 84),
                radius: 20.r,
                child: Icon(Icons.person, color: Colors.white, size: 22.sp),
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
                  SizedBox(height: 30.h),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "Your journey to inner peace starts here\nWelcome to your safe place for",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromARGB(255, 31, 58, 95),
                            height: 1.5,
                          ),
                        ),
                        Text(
                          "mental peace",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromARGB(255, 33, 150, 84),
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 15.h),
                        Text(
                          "MindEase provides guided meditations, mood tracking, and a supportive\ncommunity to help you navigate life's challenges with calm and clarity.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.35.sp,
                            color: const Color.fromARGB(255, 31, 58, 95),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25.h),
                  Center(
                    child: ElevatedButton(
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
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 25.w,
                          vertical: 12.h,
                        ),
                      ),
                      child: Text(
                        "Explore Features",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color.fromARGB(255, 31, 58, 95),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "Everything you need for",
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromARGB(255, 31, 58, 95),
                          ),
                        ),
                        Text(
                          "wellness",
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromARGB(255, 33, 150, 84),
                          ),
                        ),
                        Text(
                          "Comprehensive tools and resources to support your mental health journey",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(255, 31, 58, 95),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25.h),

                  /// Feature Cards Grid
                  Padding(
                    key: _featuresKey,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5.w,
                      mainAxisSpacing: 20.h,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        FeatureCard(
                          iconPath: 'assets/icons/guided_meditation.png',
                          title: "Guided Meditations",
                          description:
                              "Calm your mind with guided sessions designed to reduce stress and increase focus.",
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => MeditationPage()));
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
                                  builder: (_) => JournalPage(controller: controller)),
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
                                    builder: (context) => const ChatbotPage()));
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

                  SizedBox(height: 10.h),

                  /// Bottom image + text sections
                  Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Your feelings are valid.\nYour journey is important.\nWelcome to your SAFE SPACE.",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w900,
                                  color: const Color.fromARGB(255, 31, 58, 95),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              flex: 1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.r),
                                child: Image.asset(
                                  'assets/images/homepage2.jpg',
                                  height: 120.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30.h),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.r),
                                child: Image.asset(
                                  'assets/images/homepage1.jpg',
                                  height: 120.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 20.w),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Your trusted companion for Mental Wellbeing. Find peace, build resilience, and connect with a supportive community.",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w900,
                                  color: const Color.fromARGB(255, 31, 58, 95),
                                ),
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
        backgroundColor: const Color.fromARGB(255, 31, 58, 95),
        selectedItemColor: const Color.fromARGB(255, 33, 150, 84),
        unselectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Journal'),
          BottomNavigationBarItem(
              icon: Icon(Icons.self_improvement), label: 'Meditation'),
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
          borderRadius: BorderRadius.circular(15.r),
          side: const BorderSide(
            color: Color.fromARGB(255, 31, 58, 95),
            width: 1,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(iconPath, height: 40.h, width: 40.w),
              SizedBox(height: 10.h),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                  color: const Color.fromARGB(255, 31, 58, 95),
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: const Color.fromARGB(255, 31, 58, 95),
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
