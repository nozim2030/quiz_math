// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz_app/core/utils/app_colors.dart';


import 'package:quiz_app/widgets/cuctom_avatar.dart';
import 'package:quiz_app/widgets/custom_text.dart';

class RatingScreen extends StatelessWidget {
  final List<Map<String, dynamic>> players = [
    {
      "name": "Smith Carol",
      "score": "6/10",
      "image": "assets/images/person4.png"
    },
    {"name": "Harry", "score": "5/10", "image": "assets/images/person5.png"},
    {"name": "Jon", "score": "4/10", "image": "assets/images/person6.png"},
    {"name": "Ken", "score": "3/10", "image": "assets/images/person7.png"},
    {"name": "Petter", "score": "2/10", "image": "assets/images/person8.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      appBar: AppBar(
          backgroundColor: AppColors.mainColor,
          elevation: 0,
          title: CustomText(
            text: "Leaderboard",
            size: 20.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.whiteColor,
          )),
      body: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            SizedBox(height: 20.h),
            CustomAvatar(
                name: "John Deh",
                ratingText: "8/10",
                image: "assets/images/person1.jpeg"),
            CustomAvatar(
                name: "David James",
                ratingText: "9/10",
                radius: 50.r,
                image: "assets/images/person2.jpeg"),
            CustomAvatar(
              name: "Micheal",
              ratingText: "7/10",
              image: "assets/images/person3.jpeg",
            )
          ]),
          SizedBox(height: 20),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: BoxDecoration(
                color: AppColors.backroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: players.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(20.r)),
                      child: ListTile(
                          leading: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomText(
                                  text: "${index + 4}",
                                  fontWeight: FontWeight.w600),
                              SizedBox(width: 10.w),
                              CircleAvatar(
                                backgroundImage:
                                    AssetImage(players[index]["image"]),
                              )
                            ],
                          ),
                          title: CustomText(
                              text: players[index]['name'],
                              fontWeight: FontWeight.w600,
                              size: 15.sp),
                          trailing: CustomText(
                            text: players[index]['score'],
                            size: 15.sp,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
