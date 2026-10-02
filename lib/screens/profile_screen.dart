import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:to_do_app/core/helper/navigation.dart';
import 'package:to_do_app/core/utils/colors.dart';
import 'package:to_do_app/models/user_model.dart';
import 'package:to_do_app/screens/change_password_screen.dart';
import 'package:to_do_app/screens/login_screen.dart';
import 'package:to_do_app/screens/update_profile_screen.dart';
import 'package:to_do_app/services/auth_service.dart';
import 'package:to_do_app/services/profile_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _profileService = ProfileService();

  UserModel? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // ============================================================
  // LOAD USER DATA
  // ============================================================

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    final result = await _profileService.getUserData();

    if (!mounted) return;

    if (result['status'] == 'success') {
      setState(() {
        _user = result['data'] as UserModel;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Failed to load user data'),
        ),
      );
    }
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Future<void> _logout(BuildContext context) async {
    await AuthService.logout();

    if (!context.mounted) return;

    CustomNavigation.navigateAndRemoveAll(context, const LoginScreen());
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            SizedBox(height: 20.h),

            Expanded(
              child: Column(
                children: [
                  // ================= PROFILE =================

                  _buildMenuItem(
                    context,
                    SvgPicture.asset("assets/images/profile/profile_icon.svg"),
                    "Profile",
                    () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const UpdateProfileScreen(),
                        ),
                      );

                      if (mounted) {
                        _loadUserData();
                      }
                    },
                  ),

                  SizedBox(height: 25.h),

                  // ================= CHANGE PASSWORD =================
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

                  // ================= LOGOUT =================
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

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      child: Row(
        children: [
          // ================= BACK BUTTON =================

          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new, size: 22.sp),
          ),

          SizedBox(width: 5.w),

          CircleAvatar(
            backgroundImage: const AssetImage("assets/images/flag.png"),
            radius: 35,
          ),

          SizedBox(width: 15.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_isLoading)
                  Text(
                    "Loading...",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                else
                  Text(
                    _user?.username ?? "Unknown User",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                SizedBox(height: 5.h),

                Text(
                  _user?.username ?? "",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w300,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MENU ITEM
  // ============================================================

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
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
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
