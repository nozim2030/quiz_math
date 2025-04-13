import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/provider/quest_provider.dart';

class QuizScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent.shade100,
      appBar: AppBar(
        title: Text("Quiz O'yini", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Consumer<QuestProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (provider.questions.isEmpty) {
            return Center(
              child: Text(
                "❌ Savollar topilmadi!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            );
          }

          var question = provider.questions[provider.currentQuestionIndex];
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ⏳ Progress bar
                LinearProgressIndicator(
                  value: (provider.currentQuestionIndex + 1) / provider.questions.length,
                  color: Colors.green,
                  backgroundColor: Colors.white,
                  minHeight: 8,
                ),
                SizedBox(height: 20),

                // 🕒 Timer
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "⏳ Qolgan vaqt: ${provider.quesTime}s",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                ),
                SizedBox(height: 10),

                // ❓ Savol kartasi
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 8,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      question['question'],
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // 🔘 Variantlar
                ...question['options'].map<Widget>((option) {
                  bool isCorrect = provider.isAnswered && option == question['correctAnswer'];
                  bool isWrong = provider.isAnswered && option != question['correctAnswer'];

                  return AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: isCorrect ? Colors.green : isWrong ? Colors.red : Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 4, spreadRadius: 2),
                      ],
                    ),
                    child: ListTile(
                      title: Text(
                        option,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      onTap: provider.isAnswered
                          ? null // ✅ Agar javob berilgan bo‘lsa, bosish mumkin emas
                          : () {
                              provider.answerQuestion(option);
                            },
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }
}
