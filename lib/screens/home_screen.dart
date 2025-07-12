import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz_app/screens/choose_grade_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Row(
            children: [
              InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChooseGradeScreen(),
                    )),
                child: Container(
                  height: 200.h,
                  width: 200.w,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/rasm2.png'),
                          fit: BoxFit.cover)),
                ),
              ),
              SizedBox(width: 15.w),
              Container(
                height: 200.h,
                width: 200.w,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/rasm1.jpeg'),
                        fit: BoxFit.cover)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
