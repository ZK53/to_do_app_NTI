import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:to_do_app/core/components/custom_button.dart';
import 'package:to_do_app/core/components/custom_text_field.dart';
import 'package:to_do_app/core/utils/colors.dart';
import 'package:to_do_app/screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool passwordShowen = false;
  bool confirmPasswordShowen = false;

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
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 23.h),
              child: CustomTextField(
                obsecure: !passwordShowen,
                text: "Password",
                prefixIcon: SvgPicture.asset(
                  "assets/images/auth/login_password_icon.svg",
                ),
                suffixIcon: passwordShowen
                    ? "assets/images/auth/login_username_icon_showen.svg"
                    : "assets/images/auth/login_username_icon_hidden.svg",
                onPressed: () {
                  setState(() {
                    passwordShowen = !passwordShowen;
                  });
                },
              ),
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 23.h),
              child: CustomTextField(
                obsecure: !confirmPasswordShowen,
                text: "Confirm Password",
                prefixIcon: SvgPicture.asset(
                  "assets/images/auth/login_password_icon.svg",
                ),
                suffixIcon: confirmPasswordShowen
                    ? "assets/images/auth/login_username_icon_showen.svg"
                    : "assets/images/auth/login_username_icon_hidden.svg",
                onPressed: () {
                  setState(() {
                    confirmPasswordShowen = !confirmPasswordShowen;
                  });
                },
              ),
            ),
            SizedBox(height: 23.h),
            CustomButton(onPressed: () {}, text: "Register"),
            SizedBox(height: 41.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an aacount?",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: ((context) => LoginScreen())),
                    (Route route) => false,
                  ),
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
