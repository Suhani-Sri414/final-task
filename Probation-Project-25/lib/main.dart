import 'package:flutter/material.dart';
import 'package:mind_ease_app/views/auth/profession_selection_overlay.dart';
import 'package:mind_ease_app/views/navbar/home/home.dart';
import 'package:mind_ease_app/views/navbar/home/quizz.dart';
import 'package:mind_ease_app/views/navbar/home/quizz_result.dart';
import 'package:mind_ease_app/views/navbar/journal.dart';
import 'package:mind_ease_app/views/auth/login.dart';
import 'package:mind_ease_app/views/navbar/meditation.dart';
import 'package:mind_ease_app/views/navbar/ai_therapist.dart';
import 'package:mind_ease_app/views/auth/register.dart';
import 'package:mind_ease_app/views/navbar/stats.dart';
import 'package:provider/provider.dart';
import 'package:mind_ease_app/controller/quiz_controller.dart';
import 'package:mind_ease_app/controller/stats_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); 

  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuizController()),
      ],
      child: MindEaseApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class MindEaseApp extends StatelessWidget {
  final bool isLoggedIn;
  const MindEaseApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? const HomePage() : const MyLogin(),
      routes: {
        'login': (context) => const MyLogin(),
        'register': (context) => const MyRegister(),
        'profession_selection_overlay': (context) =>  ProfessionSelectionOverlay(),
        'home': (context) => const HomePage(),
        'quizz': (context) => const QuizPage(),
        'quizz_result': (context) =>  QuizResultPage(),
        'journal': (context) => JournalPage(controller: StatsController(name: "User", quizScore: 0)),
        'meditation': (context) => const MeditationPage(),
        'ai_therapist': (context) => const ChatbotPage(),
        'stats': (context) => const StatsPage(userName: '', quizScore: 0),
      },
    );
  }
}
