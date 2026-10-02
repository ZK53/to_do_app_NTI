import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:to_do_app/core/helper/navigation.dart';
import 'package:to_do_app/core/utils/colors.dart';
import 'package:to_do_app/screens/change_password_screen.dart';
import 'package:to_do_app/screens/login_screen.dart';
import 'package:to_do_app/screens/update_profile_screen.dart';
import 'package:to_do_app/services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _logout(BuildContext context) async {
    await AuthService.logout();
    if (context.mounted) {
      CustomNavigation.navigateAndRemoveAll(
        context,
        const LoginScreen(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 37.h),
            Expanded(
              child: Column(
                children: [
                  _buildMenuItem(
                    context,
                    SvgPicture.asset(
                      "assets/images/profile/profile_icon.svg",
                    ),
                    "Profile",
                    () => CustomNavigation.navigationPush(
                      context,
                      const UpdateProfileScreen(),
                    ),
                  ),
                  SizedBox(height: 25.h),
                  _buildMenuItem(
                    context,
                    Image.asset(
                      "assets/images/profile/change_password_icon.png",
                    ),
                    "Change Password",
                    () => CustomNavigation.navigationPush(
                      context,
                      const ChangePasswordScreen(),
                    ),
                  ),
                  SizedBox(height: 25.h),
                  _buildMenuItem(
                    context,
                    Image.asset("assets/images/profile/settings_icon.png"),
                    "Logout",
                    () => _logout(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: const AssetImage("assets/images/flag.png"),
            radius: 40,
          ),
          SizedBox(width: 20.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "User",
                style:
                    TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 5.h),
              Text(
                "user@example.com",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    Widget icon,
    String title,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(15.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              SizedBox(width: 24.w, height: 24.h, child: icon),
              SizedBox(width: 20.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              Icon(Icons.arrow_forward_ios, size: 16.sp),
            ],
          ),
        ),
      ),
    );
  }
}
