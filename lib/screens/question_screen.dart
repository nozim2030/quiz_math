import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/core/utils/app_colors.dart';
import 'package:quiz_app/provider/quest_provider.dart';
import 'package:quiz_app/widgets/custom_answer.dart';
import 'package:quiz_app/widgets/custom_text.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent.shade100,
      appBar: AppBar(
        title: const Text(
          "Quiz O'yini",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Consumer<QuestProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.questions.isEmpty) {
            return const Center(
              child: Text(
                "❌ Savollar topilmadi!",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            );
          }

          var question = provider.questions[provider.currentQuestionIndex];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ⏳ Progress bar
                LinearProgressIndicator(
                  borderRadius: BorderRadius.circular(10.r),
                  value: (provider.currentQuestionIndex + 1) /
                      provider.questions.length,
                  color: Colors.green,
                  backgroundColor: Colors.white,
                  minHeight: 20,
                ),
                SizedBox(height: 20.h),

                // 🕒 Timer
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "⏳ Time: ${provider.quesTime}s",
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ),
                SizedBox(height: 20.h),

                // ❓ Savol bloki
                Container(
                  width: double.infinity,
                  height: 150.h,
                  decoration: BoxDecoration(
                    boxShadow: [
                      const BoxShadow(
                        offset: Offset(2, 4),
                        blurRadius: 7,
                        spreadRadius: 2,
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: "Question: ${provider.currentQuestionIndex + 1}",
                        color: Colors.green,
                        size: 40.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: 15.h),
                      CustomText(
                        text: question['question'],
                        size: 35.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 50.h),

                // ✅ Variantlar (to‘g‘ri ishlaydigan)
                Expanded(
                  child: GridView.builder(
                    itemCount: question['options'].length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 30,
                      childAspectRatio: 1.5,
                    ),
                    itemBuilder: (context, index) {
                      String option = question['options'][index];
                      bool isCorrect = provider.isAnswered &&
                          option == question['correctAnswer'];
                      bool isWrong = provider.isAnswered &&
                          option != question['correctAnswer'];

                      return AnswerOptionButton(
  option: option,
  correctAnswer: question['answer'],
  selectedAnswer: provider.selectedAnswer,
  isAnswered: provider.isAnswered,
  isEnabled: !provider.isAnswered,
  onTap: () => provider.answerQuestion(option),
);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
