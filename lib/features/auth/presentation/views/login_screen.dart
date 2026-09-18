import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:to_do_app/core/components/custom_button.dart';
import 'package:to_do_app/core/components/custom_text_field.dart';
import 'package:to_do_app/core/helper/navigation.dart';
import 'package:to_do_app/core/utils/colors.dart';
import 'package:to_do_app/features/auth/data/repo/auth_repo.dart';
import 'package:to_do_app/features/auth/presentation/views/register_screen.dart';
import 'package:to_do_app/features/home/presentation/views/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isShowen = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  final AuthRepo _authRepo = AuthRepo();

  /// Handle login with authentication
  /// Navigates to HomeScreen on successful login
  Future<void> _login() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter username and password')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final result = await _authRepo.login(
        username: _usernameController.text,
        password: _passwordController.text,
      );

      if (mounted) {
        setState(() => isLoading = false);

        if (result['status'] == 'success') {
          // Navigate to home screen after successful login
          CustomNavigation.navigateAndRemoveAll(context, const HomeScreen());
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'] ?? 'Login failed')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              child: Image.asset(
                "assets/images/flag.png",
                height: 293.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
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
                controller: _usernameController,
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
                controller: _passwordController,
              ),
            ),
            SizedBox(height: 23.h),
            CustomButton(
              onPressed: isLoading ? null : _login,
              text: isLoading ? "Loading..." : "Login",
            ),
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
                  onPressed: () => CustomNavigation.navigationPushReplacement(
                    context,
                    const RegisterScreen(),
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
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
