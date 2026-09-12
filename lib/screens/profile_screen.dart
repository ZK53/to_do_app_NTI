import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:to_do_app/core/utils/colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _headerBuilder(),
            SizedBox(height: 37.h),
            Expanded(
              child: SizedBox(
                width: 331.w,
                height: 63.h,
                child: Column(
                  spacing: 25.h,
                  children: [
                    _itemTile(
                      SvgPicture.asset(
                        "assets/images/profile/profile_icon.svg",
                      ),
                      "Profile",
                    ),
                    _itemTile(
                      Image.asset(
                        "assets/images/profile/change_password_icon.png",
                      ),
                      "Change Password",
                    ),
                    _itemTile(
                      Image.asset("assets/images/profile/settings_icon.png"),
                      "Settings",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerBuilder() {
    return Padding(
      padding: EdgeInsets.only(top: 20.h, left: 20.w),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage("assets/images/flag.png"),
            radius: 30,
          ),
          SizedBox(width: 16.w),
          Column(
            children: [
              Text(
                "Hello!",
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w300),
              ),
              SizedBox(height: 4.h),
              Text(
                "Ahmed Saber",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _itemTile(Widget leading, String title) {
    return ListTile(
      tileColor: Colors.white,
      title: Text(title),
      leading: leading,
      trailing: SvgPicture.asset("assets/images/profile/arrow_icon.svg"),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    );
  }
}
