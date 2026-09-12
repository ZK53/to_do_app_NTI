import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:to_do_app/core/components/custom_button.dart';
import 'package:to_do_app/core/components/custom_text_field.dart';
import 'package:to_do_app/core/utils/colors.dart';

class UpdateProfile extends StatelessWidget {
  const UpdateProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "assets/images/flag.png",
              height: 293.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 23.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 23.w),
              child: CustomTextField(
                obsecure: false,
                text: "Username",
                prefixIcon: SvgPicture.asset(
                  "assets/images/auth/login_username_icon.svg",
                ),
              ),
            ),
            SizedBox(height: 23.h),
            CustomButton(onPressed: () {}, text: "Save"),
          ],
        ),
      ),
    );
  }
}
