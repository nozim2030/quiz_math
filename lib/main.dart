import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:quiz_app/provider/quest_provider.dart';
import 'package:quiz_app/repositor/quest_repo.dart';

import 'package:provider/provider.dart';
import 'package:quiz_app/screens/choose_grade_screen.dart';



final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  QuestRepo repo = QuestRepo();
  await repo.loadQuestions();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => QuestProvider(repo),
    )
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      child: MaterialApp(
          navigatorKey: navigatorKey,
          title: 'Quiz Math',
          theme: ThemeData(
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.blueAccent,
            ),
            scaffoldBackgroundColor: Colors.blueAccent.shade100,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: ChooseGradeScreen()),
    );
  }
}
