import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/core/utils/app_colors.dart';
import 'package:quiz_app/provider/quest_provider.dart';
import 'package:quiz_app/screens/level_screen.dart';
import 'package:quiz_app/widgets/custom_text.dart';

// ignore: must_be_immutable
class ChooseGradeScreen extends StatefulWidget {
  ChooseGradeScreen({super.key});

  @override
  State<ChooseGradeScreen> createState() => _ChooseGradeScreenState();
}

class _ChooseGradeScreenState extends State<ChooseGradeScreen> {
 
  // bool isPress = false;
  int currentIndex = 0;
  int? pressIndex;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<QuestProvider>(context, listen: false);
    List<String> grades = provider.fetchGrades();

    return Scaffold(
      appBar: AppBar(
        title: CustomText(text: "Choose grade", size: 40.sp),
      ),
      body: ListView.builder(
        itemCount: grades.length,
        itemBuilder: (context, index) {
          final isPressed = pressIndex == index;
          return AnimatedScale(
            scale: isPressed ? 1 : 0.94,
            duration:const Duration(milliseconds: 100),
            child: GestureDetector(
              onTapDown: (details) => setState(() {
                pressIndex = index;
              }),
              onTapCancel: () => setState(() {
                pressIndex = null;
              }),
              onTapUp: (details) async {
                await Future.delayed(const Duration(milliseconds: 100));
                setState(() {
                  pressIndex = null;
                });
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) =>
                          LevelSelectionScreen(selectedGrade: grades[index]),
                    ));
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 100),
                margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                alignment: Alignment.center,
                height: 100.h,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: isPressed ? Colors.grey.shade400 : Colors.white,
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(
                            1,
                            2,
                          ),
                          blurRadius: 4,
                          spreadRadius: 3,
                          blurStyle: BlurStyle.inner)
                    ]),
                child: CustomText(
                  text: grades[index],
                  size: 40.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Home"),
      ]),
    );
  }
}
