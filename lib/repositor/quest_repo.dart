import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart' show rootBundle;

class QuestRepo {
  Map<String, dynamic>? _questionsData;

  /// JSON ma'lumotlarni yuklash
  Future<void> loadQuestions() async {
    try {
      String jsonString = await rootBundle.loadString('assets/questions.json');
      _questionsData = json.decode(jsonString);

      if (_questionsData == null || _questionsData!.isEmpty) {
        print("⚠️ Xatolik: JSON fayl bo‘sh yoki noto‘g‘ri!");
      } else {
        print("✅ Ma'lumotlar muvaffaqiyatli yuklandi!");
      }
    } catch (e) {
      print("❌ Xatolik: $e");
    }
  }

  /// Barcha grade'larni olish
  List<String> getAllGrades() {
    if (_questionsData == null) return [];

    return _questionsData!.keys.toList();
  }

  /// Berilgan grade'ning barcha level'larini olish
  List<String> getLevelsForGrade(String grade) {
    if (_questionsData == null ||
        !_questionsData!.containsKey(grade) ||
        _questionsData![grade] is! Map ||
        !_questionsData![grade].containsKey("levels") ||
        _questionsData![grade]["levels"] is! Map) {
      return [];
    }
    return _questionsData![grade]["levels"].keys.toList();
  }

  /// Berilgan grade va level uchun test savollarini olish
  List<Map<String, dynamic>> getQuestions(String grade, String level) {
    if (_questionsData == null ||
        !_questionsData!.containsKey(grade) ||
        _questionsData![grade] is! Map ||
        !_questionsData![grade].containsKey("levels") ||
        _questionsData![grade]["levels"] is! Map ||
        !_questionsData![grade]["levels"].containsKey(level) ||
        _questionsData![grade]["levels"][level] is! List) {
      return [];
    }

    return List<Map<String, dynamic>>.from(
        _questionsData![grade]["levels"][level]);
  }
}
