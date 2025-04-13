import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:quiz_app/provider/quest_provider.dart';
import 'package:quiz_app/repositor/quest_repo.dart';
import 'package:quiz_app/screens/home_screen.dart';
import 'package:provider/provider.dart';
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
      child: MaterialApp(navigatorKey: navigatorKey,
        title: 'Quiz Math',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.green[400],
          ),
          scaffoldBackgroundColor: Colors.green[400],
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
