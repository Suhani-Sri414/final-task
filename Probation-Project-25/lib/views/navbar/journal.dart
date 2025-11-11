import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mind_ease_app/controller/journal_controller.dart';
import 'package:mind_ease_app/controller/stats_controller.dart';

class JournalPage extends StatefulWidget {
  final StatsController controller; // ✅ connect StatsController from StatsPage
  const JournalPage({super.key, required this.controller});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final TextEditingController journalController = TextEditingController();
  final journalControllerInstance = JournalController();

  List<Map<String, dynamic>> savedJournals = [];
  Timer? _journalTimer;
  int _secondsWriting = 0;
  bool _journalAutoChecked = false;

  @override
  void initState() {
    super.initState();
    _loadSavedJournals(); // Load existing entries
  }

  @override
  void dispose() {
    _journalTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadSavedJournals() async {
    final data = await journalControllerInstance.fetchJournalEntries();

    setState(() {
      savedJournals = data;

      // Pre-fill today's journal if exists
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final todayEntry = savedJournals.firstWhere(
        (e) => (e['date'] ?? '').startsWith(today),
        orElse: () => {},
      );

      if (todayEntry.isNotEmpty) {
        journalController.text = todayEntry['content'] ?? '';
      } else {
        journalController.clear();
      }
    });
  }

  void _startJournalTimer() {
    // ✅ Start timer when user begins typing
    _journalTimer ??= Timer.periodic(const Duration(seconds: 1), (timer) async {
      _secondsWriting++;

      if (_secondsWriting >= 10 && !_journalAutoChecked) {
        _journalAutoChecked = true;
        widget.controller.autoCheckJournalTask(); // ✅ mark task complete in stats
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Journal Entry task completed automatically!"),
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate =
        DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());
    const Color tealColor = Color.fromARGB(255, 33, 150, 84);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 253, 247, 231),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            const Icon(Icons.book_outlined,
                size: 60, color: Color.fromARGB(255, 31, 58, 95)),
            const SizedBox(height: 8),
            const Text(
              "Your Daily Journal",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 31, 58, 95),
              ),
            ),
            const SizedBox(height: 20),

            // Journal Input Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: tealColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 31, 58, 95),
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "What's on your mind?",
                    style: TextStyle(
                      color: Color.fromARGB(255, 31, 58, 95),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: journalController,
                    maxLines: 6,
                    onChanged: (_) => _startJournalTimer(), // ✅ detect typing
                    decoration: InputDecoration(
                      hintText:
                          "Write your thoughts, feelings, or reflections here...",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        final text = journalController.text.trim();

                        if (text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please write your journal.')),
                          );
                          return;
                        }

                        final result = await journalControllerInstance
                            .submitJournalEntry(text);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text(result ?? 'Error submitting journal')),
                        );

                        journalController.clear();
                        await _loadSavedJournals();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: tealColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 35, vertical: 10),
                      ),
                      child: const Text("Save Text",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Display Saved Journals
            if (savedJournals.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Saved Journal Entries",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color.fromARGB(255, 31, 58, 95),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: savedJournals.length,
                    itemBuilder: (context, index) {
                      final entry = savedJournals[index];
                      final dateFormatted = DateFormat('EEEE, MMM d, yyyy')
                          .format(DateTime.parse(entry['date']));
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(entry['content'] ?? ''),
                          subtitle: Text("Date: $dateFormatted"),
                        ),
                      );
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
