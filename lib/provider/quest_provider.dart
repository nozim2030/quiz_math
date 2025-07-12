import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/screens/level_screen.dart';
import 'package:vibration/vibration.dart';
import 'package:quiz_app/main.dart';
import 'package:quiz_app/repositor/quest_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestProvider extends ChangeNotifier {
  final QuestRepo questRepo;
  bool isLoading = false;
  String? _selectedAnswer; // 🔐 Ichki field
  String? get selectedAnswer => _selectedAnswer;

  List<Map<String, dynamic>> questions = [];
  int currentQuestionIndex = 0;
  int correctAnswer = 0;
  int quesTime = 500; // ⏳ Har bir savol uchun 5 soniya
  Timer? timer;
  bool isAnswered = false; // ✅ Javob berilganligini tekshirish uchun flag
  String selectedGrade = "";
  String selectedLevel = "";

  final AudioPlayer _player = AudioPlayer(); // 🔊 Ovoz player
  Map<String, Map<String, int>> results = {}; // 📝 Level natijalari

  QuestProvider(this.questRepo);

  Future<void> getQuests() async {
    isLoading = true;
    notifyListeners();
    await questRepo.loadQuestions();
    isLoading = false;
    notifyListeners();
  }

  List<String> fetchGrades() {
    return questRepo.getAllGrades();
  }

  List<String> fetchLevels(String grade) {
    return questRepo.getLevelsForGrade(grade);
  }

  void fetchQuestions(String grade, String level) {
    selectedGrade = grade;
    selectedLevel = level;
    questions = questRepo.getQuestions(grade, level);
    for (var question in questions) {
      List options = question['options'];
      options.shuffle(); // ✅ Javoblar tasodifiy joylashadi
      question['options'] = options;
    }
    currentQuestionIndex = 0;
    correctAnswer = 0;
    isAnswered = false;
    notifyListeners();
    startTimer(); // ⏳ Test boshlanganda timer ishga tushadi
  }

  void startTimer() {
    timer?.cancel();
    quesTime = 500; // ⏳ Har bir savol uchun 5 soniya beriladi
    isAnswered = false;

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (quesTime > 0) {
        quesTime--;
        notifyListeners();
      } else {
        timer.cancel();
        if (!isAnswered) {
          isAnswered = true;
          _vibrate(); // ⏳ Vaqt tugadi, vibratsiya ishlaydi
          nextQuestion();
        }
      }
    });
  }

  // void answerQuestion(String selectedAnswer) {
  //   if (!isAnswered) {
  //     isAnswered = true;
  //     timer?.cancel(); // ⏳ Javob tanlanganda timer to‘xtaydi

  //     String correctAns = questions[currentQuestionIndex]['answer'];

  //     if (correctAns == selectedAnswer) {
  //       correctAnswer++; // ✅ To‘g‘ri javob bo‘lsa +1 qo‘shiladi
  //       _playSound("sound/correct.wav"); // ✅ Ovoz ishlaydi
  //     } else {
  //       _vibrate(); // ❌ Noto‘g‘ri javob bo‘lsa vibratsiya
  //     }

  //     nextQuestion();
  //   }
  // }
  void answerQuestion(String selectedAnswer) {
    if (!isAnswered) {
      isAnswered = true;
      timer?.cancel();

      _selectedAnswer = selectedAnswer; // ✅ Tanlangan variantni saqlaymiz

      String correctAns = questions[currentQuestionIndex]['answer'];

      if (correctAns == selectedAnswer) {
        correctAnswer++;
        _playSound("sound/correct.wav");
      } else {
        _vibrate();
      }

      notifyListeners(); // 🔁 UI yangilansin
      nextQuestion();
    }
  }

  // void nextQuestion() {
  //   if (currentQuestionIndex < questions.length - 1) {
  //     currentQuestionIndex++;
  //     startTimer();
  //     notifyListeners();
  //   } else {
  //     timer?.cancel();
  //     saveResults();
  //     showResultDialog();
  //     print("✅ Test tugadi! To‘g‘ri javoblar: $correctAnswer");
  //   }
  // }

  void nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      currentQuestionIndex++;
      isAnswered = false;
      _selectedAnswer = null; // 🧹 Keyingi savol uchun tozalaymiz
      startTimer();
      notifyListeners();
    } else {
      timer?.cancel();
      saveResults();
      showResultDialog();
      print("✅ Test tugadi! To‘g‘ri javoblar: $correctAnswer");
    }
  }

  void showResultDialog() {
    Future.delayed(Duration.zero, () {
      showDialog(
        context: navigatorKey.currentContext!,
        barrierDismissible: false, // Tashqarisini bosib yopib bo‘lmasin
        builder: (context) {
          return Consumer<QuestProvider>(
            builder: (context, questProvider, child) {
              int correctAnswers = questProvider.correctAnswer;
              int totalQuestions = questProvider.questions.length;
              bool isSuccess = correctAnswers >= 7;

              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                backgroundColor:
                    isSuccess ? Colors.green.shade50 : Colors.red.shade50,
                title: Row(
                  children: [
                    Icon(
                      isSuccess
                          ? Icons.emoji_events
                          : Icons.warning_amber_rounded,
                      color: isSuccess ? Colors.green : Colors.red,
                    ),
                    SizedBox(width: 10),
                    Text(
                      isSuccess ? "🎉 Tabriklaymiz!" : "😢 Afsus!",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isSuccess ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 700),
                      curve: Curves.easeInOut,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:
                            isSuccess ? Colors.greenAccent : Colors.redAccent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "Siz $correctAnswers ta to‘g‘ri javob berdingiz! ($correctAnswers/$totalQuestions)",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    if (isSuccess)
                      Text(
                        "Keyingi bosqich ochildi!",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    else
                      Text(
                        "Yana harakat qilib ko‘ring!",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // dialogni yopish
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LevelSelectionScreen(
                            selectedGrade: selectedGrade,
                          ),
                        ),
                      );
                    },
                    child: Text("OK"),
                  ),
                ],
              );
            },
          );
        },
      );
    });
  }

  // 📌 Ovoz chalish funksiyasi
  void _playSound(String path) async {
    print("🔊 Ovoz chalinyapti: $path");
    await _player.play(AssetSource(path));
    await Future.delayed(Duration(milliseconds: 500));
    await _player.stop();
  }

  // 📌 Vibratsiya funksiyasi
  void _vibrate() {
    print("vibrator ishladi");
    Vibration.vibrate(duration: 500);
  }

  void saveResults() {
    if (!results.containsKey(selectedGrade)) {
      results[selectedGrade] = {};
    }
    results[selectedGrade]![selectedLevel] = correctAnswer;
    notifyListeners();
    completeLevel(selectedGrade, selectedLevel);
  }

  int? getLevelResult(String grade, String level) {
    return results[grade]?[level];
  }

  bool isLevelLocked(String grade, String level) {
    return results[grade]?[level] == null;
  }

  void completeLevel(String grade, String level) {
    SharedPreferences.getInstance().then((prefs) {
      List<String> completedLevels = prefs.getStringList(grade) ?? [];
      if (!completedLevels.contains(level)) {
        completedLevels.add(level);
        prefs.setStringList(grade, completedLevels);
      }
    });
  }

  Future<List<String>> getCompletedLevels(String grade) {
    final prefs = SharedPreferences.getInstance();
    return prefs.then((prefs) => prefs.getStringList(grade) ?? []);
  }
}
