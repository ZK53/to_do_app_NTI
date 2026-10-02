import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:to_do_app/core/utils/colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/splash.svg",
              height: 344.h,
              width: 334.w,
            ),
            SizedBox(height: 44.h),
            Text(
              "TODO",
              style: TextStyle(
                color: AppColors.spalshText,
                fontWeight: FontWeight.w900,
                fontSize: 36.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
