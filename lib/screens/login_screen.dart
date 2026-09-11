import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:to_do_app/core/components/custom_button.dart';
import 'package:to_do_app/core/components/custom_text_field.dart';
import 'package:to_do_app/core/utils/colors.dart';
import 'package:to_do_app/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isShowen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
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
              obsecure: !isShowen,
              text: "Password",
              prefixIcon: SvgPicture.asset(
                "assets/images/auth/login_password_icon.svg",
              ),
              suffixIcon: isShowen
                  ? "assets/images/auth/login_username_icon_showen.svg"
                  : "assets/images/auth/login_username_icon_hidden.svg",
              onPressed: () {
                setState(() {
                  isShowen = !isShowen;
                });
              },
            ),
          ),
          SizedBox(height: 23.h),
          CustomButton(onPressed: () {}, text: "Login"),
          SizedBox(height: 41.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have aacount?",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: ((context) => RegisterScreen())),
                  (Route route) => false,
                ),
                child: Text(
                  "Register",
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
    );
  }
}
