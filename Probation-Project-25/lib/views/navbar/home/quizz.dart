import 'package:flutter/material.dart';
import 'package:mind_ease_app/controller/quiz_controller.dart';
import 'package:provider/provider.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<QuizController>(context, listen: false).loadQuiz());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizController>(
      builder: (context, controller, child) {
        
        if (controller.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        
        if (controller.questions.isEmpty) {
          return const Scaffold(
            body: Center(child: Text("No quiz available")),
          );
        }

        final question = controller.currentQuestion;
        final selectedAnswer =
            controller.userAnswers[question.id.toString()] ?? '';

        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 253, 247, 231),
          appBar: AppBar(
            title: Text(
              "Quiz (${controller.currentIndex + 1}/${controller.questions.length})",
            ),
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 33, 150, 84),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Question ${controller.currentIndex + 1} of ${controller.questions.length}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "${((controller.currentIndex + 1) / controller.questions.length * 100).toStringAsFixed(0)}% Complete",
                      style: const TextStyle(
                        color: Color.fromARGB(255, 33, 150, 84),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value:
                        (controller.currentIndex + 1) / controller.questions.length,
                    color: const Color.fromARGB(255, 33, 150, 84),
                    backgroundColor: Colors.grey[300],
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 30),

                
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        question.questionText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      
                      if (question.options.isNotEmpty)
                        ...question.options.map(
                          (option) => RadioListTile(
                            title: Text(option),
                            value: option,
                            groupValue: selectedAnswer,
                            onChanged: (value) {
                              controller.answerQuestion(
                                  question.id.toString(), value!);
                            },
                            activeColor:
                                const Color.fromARGB(255, 33, 150, 84),
                          ),
                        )
                      else
                        TextFormField(
                          initialValue:
                              controller.userAnswers[question.id.toString()] ?? '',
                          decoration: InputDecoration(
                            hintText: "Enter Your Answer",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                          onChanged: (value) {
                            controller.answerQuestion(
                                question.id.toString(), value);
                          },
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: controller.currentIndex > 0
                          ? controller.previousQuestion
                          : null,
                      style: OutlinedButton.styleFrom(
                        foregroundColor:
                            const Color.fromARGB(255, 33, 150, 84),
                        side: const BorderSide(
                            color: Color.fromARGB(255, 33, 150, 84)),
                      ),
                      child: const Text("Previous"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        
                        final currentAnswer =
                            controller.userAnswers[question.id.toString()] ?? '';
                        if (currentAnswer.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please select or enter an answer before continuing."),
                              backgroundColor: Colors.redAccent,
                              duration: Duration(seconds: 2),
                            ),
                          );
                          return;
                        }

                        if (controller.currentIndex <
                            controller.questions.length - 1) {
                          controller.nextQuestion();
                        } else {
                          
                          await controller.submitQuiz(context);
                          final resultData = await controller.fetchResult();
                          print('Full Result Data: $resultData');

                          if (!mounted) return;

                          

                          
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 33, 150, 84),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      child: Text(
                        controller.currentIndex <
                                controller.questions.length - 1
                            ? "Next"
                            : "Submit",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                
                const Text(
                  "Your responses are confidential and will help us provide personalized support.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 31, 58, 95),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
