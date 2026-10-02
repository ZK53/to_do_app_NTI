import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:to_do_app/core/components/custom_button.dart';
import 'package:to_do_app/core/components/custom_text_field.dart';
import 'package:to_do_app/core/helper/navigation.dart';
import 'package:to_do_app/core/utils/colors.dart';
import 'package:to_do_app/screens/login_screen.dart';
import 'package:to_do_app/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;
  bool isLoading = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final _authService = AuthService();

  Future<void> _register() async {
    // Validation
    if (_usernameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _showSnackBar('Please fill all fields');
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showSnackBar('Passwords do not match');
      return;
    }

    if (_passwordController.text.length < 6) {
      _showSnackBar('Password must be at least 6 characters');
      return;
    }

    setState(() => isLoading = true);

    try {
      final result = await _authService.register(
        username: _usernameController.text,
        password: _passwordController.text,
      );

      // DEBUG: Print full response
      print('=== REGISTER RESPONSE ===');
      print('Full Response: $result');
      print('Status: ${result['status']}');
      print('Message: ${result['message']}');
      print('Data: ${result['data']}');
      print('========================');

      if (!mounted) return;
      setState(() => isLoading = false);

      if (result['status'] == 'success') {
        _showSnackBar('Registration successful! Please login.');
        if (mounted) {
          CustomNavigation.navigationPushReplacement(
            context,
            const LoginScreen(),
          );
        }
      } else {
        _showSnackBar(result['message'] ?? 'Registration failed');
      }
    } catch (e) {
      // DEBUG: Print exception
      print('=== REGISTER ERROR ===');
      print('Exception: $e');
      print('Exception Type: ${e.runtimeType}');
      print('=======================');

      if (mounted) {
        setState(() => isLoading = false);
        _showSnackBar('Error: $e');
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                obsecure: !passwordVisible,
                text: "Password",
                prefixIcon: SvgPicture.asset(
                  "assets/images/auth/login_password_icon.svg",
                ),
                suffixIcon: passwordVisible
                    ? "assets/images/auth/login_username_icon_showen.svg"
                    : "assets/images/auth/login_username_icon_hidden.svg",
                onPressed: () {
                  setState(() => passwordVisible = !passwordVisible);
                },
                controller: _passwordController,
              ),
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 23.w),
              child: CustomTextField(
                obsecure: !confirmPasswordVisible,
                text: "Confirm Password",
                prefixIcon: SvgPicture.asset(
                  "assets/images/auth/login_password_icon.svg",
                ),
                suffixIcon: confirmPasswordVisible
                    ? "assets/images/auth/login_username_icon_showen.svg"
                    : "assets/images/auth/login_username_icon_hidden.svg",
                onPressed: () {
                  setState(
                    () => confirmPasswordVisible = !confirmPasswordVisible,
                  );
                },
                controller: _confirmPasswordController,
              ),
            ),
            SizedBox(height: 23.h),
            CustomButton(
              onPressed: isLoading ? null : _register,
              text: isLoading ? "Registering..." : "Register",
            ),
            SizedBox(height: 41.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have account?",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                  ),
                ),
                TextButton(
                  onPressed: () => CustomNavigation.navigationPushReplacement(
                    context,
                    const LoginScreen(),
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
