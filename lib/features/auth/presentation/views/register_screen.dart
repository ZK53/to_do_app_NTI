import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:to_do_app/core/components/custom_button.dart';
import 'package:to_do_app/core/components/custom_text_field.dart';
import 'package:to_do_app/core/helper/navigation.dart';
import 'package:to_do_app/core/utils/colors.dart';
import 'package:to_do_app/features/auth/data/repo/auth_repo.dart';
import 'package:to_do_app/features/auth/presentation/views/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool passwordShowen = false;
  bool confirmPasswordShowen = false;
  bool isLoading = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confrimPasswordController =
      TextEditingController();
  final AuthRepo _authRepo = AuthRepo();

  /// Handle registration with validation
  /// Navigates to LoginScreen after successful registration
  Future<void> _register() async {
    // Validation
    if (_usernameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confrimPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    if (_passwordController.text != _confrimPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    if (_passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final result = await _authRepo.register(
        username: _usernameController.text,
        password: _passwordController.text,
      );

      if (mounted) {
        setState(() => isLoading = false);

        if (result['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration successful! Please login.'),
            ),
          );
          // Navigate to login screen after successful registration
          if (mounted) {
            CustomNavigation.navigationPushReplacement(
              context,
              const LoginScreen(),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'] ?? 'Registration failed')),
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
                controller: _passwordController,
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
                controller: _confrimPasswordController,
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
                  "Already have an aacount?",
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

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confrimPasswordController.dispose();
    super.dispose();
  }
}
