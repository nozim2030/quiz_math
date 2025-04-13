import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class QuizResultService {
  static const String _resultsKey = "quiz_results";
  static const String _completedLevelsKey = "completed_levels";

  // 📥 Ma’lumotni yuklash
  static Future<Map<String, Map<String, int>>> loadResults() async {
    final prefs = await SharedPreferences.getInstance();
    String? resultsString = prefs.getString(_resultsKey);
    if (resultsString != null) {
      Map<String, dynamic> rawData = jsonDecode(resultsString);
      return rawData.map((grade, levels) => MapEntry(
            grade,
            Map<String, int>.from(levels),
          ));
    }
    return {}; // Agar oldin natija bo‘lmasa, bo‘sh map qaytadi
  }

  // 📥 Yangi keyin bajarilgan darajalarni yuklash
  static Future<List<String>> loadCompletedLevels() async {
    
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_completedLevelsKey) ?? [];
  }

  // 📤 Ma’lumotni saqlash
  static Future<void> saveResult(String grade, String level, int correctAnswers) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, Map<String, int>> results = await loadResults();

    if (!results.containsKey(grade)) {
      results[grade] = {};
    }
    results[grade]![level] = correctAnswers;

    await prefs.setString(_resultsKey, jsonEncode(results));

    // Saqlangan darajani qo‘shish
    List<String> completedLevels = await loadCompletedLevels();
    if (!completedLevels.contains("$grade-$level")) {
      completedLevels.add("$grade-$level");
      await prefs.setStringList(_completedLevelsKey, completedLevels);
    }
  }

  // 📥 Foydalanuvchi bajargan darajalarni tekshirish
  static Future<bool> isLevelCompleted(String grade, String level) async {
    List<String> completedLevels = await loadCompletedLevels();
    return completedLevels.contains("$grade-$level");
  }
}
