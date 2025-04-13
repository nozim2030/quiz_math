import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/core/utils/app_colors.dart';
import 'package:quiz_app/provider/quest_provider.dart';
import 'package:quiz_app/screens/level_screen.dart';
import 'package:quiz_app/widgets/custom_text.dart';

class HomeScreen extends StatelessWidget {
  int currentIndex = 0;
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
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) =>
                        LevelSelectionScreen(selectedGrade: grades[index]),
                  ));
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              alignment: Alignment.center,
              height: 100.h,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.amberColor),
              child: CustomText(
                text: grades[index],
                size: 40.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
      ]),
    );
  }
}
