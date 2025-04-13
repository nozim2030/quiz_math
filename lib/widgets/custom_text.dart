import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomText extends StatelessWidget {
  final String text;
  final Color? color;
  final double? size;
  final FontWeight? fontWeight;
  const CustomText({
    Key? key,
    required this.text,
    this.color,
    this.size,
    this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: size ?? 18.sp,
          fontWeight: fontWeight ?? FontWeight.normal,
          color: color ?? Colors.black,
          fontFamily: "Baloo_2"),
    );
  }
}
