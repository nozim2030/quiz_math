import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAvatar extends StatelessWidget {
  final String name;
  final String image;
  final String ratingText;
  final double? radius;
  const CustomAvatar({
    Key? key,
    required this.name,
    required this.image,
    required this.ratingText,
    this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CircleAvatar(
          radius: radius ?? 40.r,
          backgroundImage: AssetImage(image),
        ),
        SizedBox(height: 8.h),
        Text(name, style: TextStyle(fontWeight: FontWeight.w600)),
        Text(ratingText),
      ],
    );
  }
}
