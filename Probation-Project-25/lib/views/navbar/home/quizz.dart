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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    // scale values
    double wp(double v) => width * v / 100;
    double hp(double v) => height * v / 100;

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
              style: TextStyle(fontSize: wp(4.5)),
            ),
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 33, 150, 84),
          ),
          body: Padding(
            padding: EdgeInsets.all(wp(4)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ------------------ HEAD TEXT ------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Question ${controller.currentIndex + 1} of ${controller.questions.length}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: wp(4),
                      ),
                    ),
                    Text(
                      "${((controller.currentIndex + 1) / controller.questions.length * 100).toStringAsFixed(0)}% Complete",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 33, 150, 84),
                        fontWeight: FontWeight.bold,
                        fontSize: wp(3.8),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: hp(1)),

                // ------------------ PROGRESS BAR ------------------
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: (controller.currentIndex + 1) /
                        controller.questions.length,
                    color: const Color.fromARGB(255, 33, 150, 84),
                    backgroundColor: Colors.grey[300],
                    minHeight: hp(1),
                  ),
                ),

                SizedBox(height: hp(3)),

                // ------------------ QUESTION CARD ------------------
                Container(
                  padding: EdgeInsets.all(wp(5)),
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
                        style: TextStyle(
                          fontSize: wp(4.8),
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: hp(2)),

                      // ------------------ ANSWERS ------------------
                      if (question.options.isNotEmpty)
                        ...question.options.map(
                          (option) => RadioListTile(
                            title: Text(
                              option,
                              style: TextStyle(fontSize: wp(4)),
                            ),
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
                              controller.userAnswers[question.id.toString()] ??
                                  '',
                          style: TextStyle(fontSize: wp(4)),
                          decoration: InputDecoration(
                            hintText: "Enter Your Answer",
                            hintStyle: TextStyle(fontSize: wp(3.5)),
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

                SizedBox(height: hp(3)),

                // ------------------ BUTTONS ------------------
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
                          color: Color.fromARGB(255, 33, 150, 84),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: wp(6),
                          vertical: hp(1.5),
                        ),
                      ),
                      child: Text(
                        "Previous",
                        style: TextStyle(fontSize: wp(3.8)),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final currentAnswer =
                            controller.userAnswers[question.id.toString()] ??
                                '';

                        if (currentAnswer.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Please select or enter an answer before continuing.",
                              ),
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
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 33, 150, 84),
                        padding: EdgeInsets.symmetric(
                          horizontal: wp(8),
                          vertical: hp(1.8),
                        ),
                      ),
                      child: Text(
                        controller.currentIndex <
                                controller.questions.length - 1
                            ? "Next"
                            : "Submit",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: wp(4),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: hp(2)),

                // ------------------ FOOTER TEXT ------------------
                Text(
                  "Your responses are confidential and will help us provide personalized support.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: wp(3),
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 31, 58, 95),
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
