import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz_app/core/utils/app_colors.dart';

import 'package:quiz_app/screens/question_screen.dart';

import 'package:quiz_app/widgets/custom_text.dart';

class RegistrScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();

  final String jsonString = '''
  {
    "1": {
      "levels": {
        "1": [
          {"question": "What is 2+2?", "options": ["3", "4", "5"], "answer": "4"}
        ]
      }
    }
  }
  ''';

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> jsonData = jsonDecode(jsonString);

    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 70.h),
            Padding(
              padding: const EdgeInsets.only(top: 100, left: 100),
              child: Container(
                width: 160.w,
                height: 160.h,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: AppColors.whiteColor),
                child: Stack(
                  children: [
                    Positioned(
                      top: 50.sp,
                      left: 30.sp,
                      right: 30.sp,
                      child: CustomText(
                        text: "QUIZ",
                        size: 40.sp,
                        color: AppColors.siniyColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Positioned(
                      top: 90.sp,
                      right: 40.sp,
                      child: CustomText(
                        text: "Math",
                        size: 20.sp,
                        color: AppColors.orangeColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 120.h),
            CustomText(
                text: "Enter your name",
                size: 20.sp,
                color: AppColors.whiteColor,
                fontWeight: FontWeight.w600),
            SizedBox(height: 15.h),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _controller,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "please enter your name";
                  } else if (value.length < 4) {
                    return "please enter full name";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  label: CustomText(
                    text: "Enter name",
                    size: 15.sp,
                    color: AppColors.whiteColor,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.r),
                    borderSide: const BorderSide(color: AppColors.whiteColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.r),
                    borderSide: const BorderSide(color: AppColors.whiteColor),
                  ),
                ),
              ),
            ),
            SizedBox(height: 200.h),
            SizedBox(
              height: 60.h,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orangeColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => QuizScreen(),
                      ),
                    );
                  }
                },
                child: CustomText(
                  text: "Start",
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w600,
                  size: 24.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
