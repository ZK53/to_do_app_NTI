import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:to_do_app/core/components/custom_button.dart';
import 'package:to_do_app/core/components/custom_text_field.dart';
import 'package:to_do_app/core/helper/navigation.dart';
import 'package:to_do_app/core/utils/colors.dart';
import 'package:to_do_app/screens/home_screen.dart';
import 'package:to_do_app/screens/register_screen.dart';
import 'package:to_do_app/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPasswordVisible = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  final _authService = AuthService();

  Future<void> _login() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      _showSnackBar('Please enter username and password');
      return;
    }

    setState(() => isLoading = true);

    try {
      final result = await _authService.login(
        username: _usernameController.text,
        password: _passwordController.text,
      );

      if (!mounted) return;
      setState(() => isLoading = false);

      if (result['status'] == 'success') {
        CustomNavigation.navigateAndRemoveAll(context, const HomeScreen());
      } else {
        _showSnackBar(result['message'] ?? 'Login failed');
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        _showSnackBar('Error: $e');
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
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
              padding: EdgeInsets.symmetric(horizontal: 23.w),
              child: CustomTextField(
                obsecure: !isPasswordVisible,
                text: "Password",
                prefixIcon: SvgPicture.asset(
                  "assets/images/auth/login_password_icon.svg",
                ),
                suffixIcon: isPasswordVisible
                    ? "assets/images/auth/login_username_icon_showen.svg"
                    : "assets/images/auth/login_username_icon_hidden.svg",
                onPressed: () {
                  setState(() => isPasswordVisible = !isPasswordVisible);
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
                  "Don't have account?",
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
}
