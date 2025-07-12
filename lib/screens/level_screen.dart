import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/core/utils/app_colors.dart';
import 'package:quiz_app/provider/quest_provider.dart';
import 'package:quiz_app/screens/question_screen.dart';
import 'package:quiz_app/widgets/custom_text.dart';

class LevelSelectionScreen extends StatefulWidget {
  final String selectedGrade;

  LevelSelectionScreen({required this.selectedGrade});

  @override
  State<LevelSelectionScreen> createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen> {
  int? pressIndex;
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<QuestProvider>(context, listen: false);
    List<String> levels = provider.fetchLevels(widget.selectedGrade);

    return Scaffold(
      appBar: AppBar(
        title: Text("Level tanlang"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<String>>(
        future: provider.getCompletedLevels(widget.selectedGrade),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Xatolik: ${snapshot.error}"));
          }

          List<String> completedLevels = snapshot.data ?? [];

          return ListView.builder(
            itemCount: levels.length,
            itemBuilder: (context, index) {
              bool isUnlocked =
                  index == 0 || completedLevels.contains(levels[index - 1]);
              final isPressed = pressIndex == index;

              return AnimatedScale(
                scale: isPressed ? 1 : 0.94,
                duration: const Duration(milliseconds: 100),
                child: GestureDetector(
                  onTapDown: (details) => setState(() {
                    pressIndex = index;
                  }),
                  onTapCancel: () => setState(() {
                    pressIndex = null;
                  }),
                  onTapUp: (details) async {
                    Future.delayed(Duration(milliseconds: 100));
                    setState(() {
                      pressIndex = null;
                    });
                  },
                  onTap: isUnlocked
                      ? () {
                          provider.fetchQuestions(
                              widget.selectedGrade, levels[index]);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => QuizScreen()),
                          );
                        }
                      : null, // ❌ Qulfda bo‘lsa, bosish ishlamaydi
                  child: AnimatedContainer(
                    duration: Duration(),
                    alignment: Alignment.center,
                    height: 80.h,
                    width: double.infinity,
                    margin:
                        EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: isUnlocked
                          ? AppColors.whiteColor
                          : Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: "Level ${levels[index]}",
                          color: isUnlocked ? Colors.black : Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(width: 10.w),
                        if (!isUnlocked)
                          Icon(Icons.lock,
                              color: Colors.black54), // Qulf belgisi
                        if (isUnlocked)
                          Consumer<QuestProvider>(
                            builder: (context, questProvider, child) {
                              int correctAnswers = questProvider.getLevelResult(
                                      widget.selectedGrade, levels[index]) ??
                                  0;
                              return CustomText(
                                text:
                                    "To'g'ri javoblar: $correctAnswers/${questProvider.questions.length}",
                                color: Colors.white,
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
