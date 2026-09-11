import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:to_do_app/core/utils/colors.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;

  const CustomButton({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: AppColors.button,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
      padding: EdgeInsets.symmetric(horizontal: 120.w, vertical: 14.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 19.sp,
          fontWeight: FontWeight.w300,
          color: Colors.white,
        ),
      ),
    );
  }
}
