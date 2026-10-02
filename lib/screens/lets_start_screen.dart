import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:to_do_app/core/components/custom_button.dart';
import 'package:to_do_app/core/helper/app_initialization.dart';
import 'package:to_do_app/core/helper/navigation.dart';
import 'package:to_do_app/core/utils/colors.dart';
import 'package:to_do_app/screens/login_screen.dart';

class LetsStartScreen extends StatelessWidget {
  const LetsStartScreen({super.key});

  Future<void> _handleGetStarted(BuildContext context) async {
    await AppInitialization.markAppAsLaunched();

    if (context.mounted) {
      CustomNavigation.navigateAndRemoveAll(context, const LoginScreen());
    }
  }

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
              "assets/images/let's_start.svg",
              height: 301.7.h,
              width: 342.86.w,
            ),
            SizedBox(height: 60.4.h),
            Text(
              "Welcome To",
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 24.sp),
            ),
            Text(
              "Do It !",
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 24.sp),
            ),
            SizedBox(height: 40.h),
            Text(
              "Ready to conquer your tasks? Let's do",
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 60.h),
            CustomButton(
              onPressed: () => _handleGetStarted(context),
              text: "Let's Start",
            ),
          ],
        ),
      ),
    );
  }
}
