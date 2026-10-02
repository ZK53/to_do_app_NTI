import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:to_do_app/core/components/custom_button.dart';
import 'package:to_do_app/core/components/custom_text_field.dart';
import 'package:to_do_app/core/utils/colors.dart';
import 'package:to_do_app/services/profile_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;

  final _profileService = ProfileService();

  Future<void> _changePassword() async {
    final currentPassword = _oldPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      _showSnackBar('Please fill all password fields');
      return;
    }

    if (newPassword != confirmPassword) {
      _showSnackBar('Passwords do not match');
      return;
    }

    if (newPassword.length < 6) {
      _showSnackBar('Password must be at least 6 characters');
      return;
    }

    setState(() => _isLoading = true);

    final result = await _profileService.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result['status'] == 'success') {
      _showSnackBar('Password changed successfully');
      Navigator.pop(context);
    } else {
      _showSnackBar(result['message'] ?? 'Failed to change password');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Change Password"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: Image.asset(
                  "assets/images/flag.png",
                  height: 200.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 40.h),
              CustomTextField(
                obsecure: true,
                text: "Current Password",
                controller: _oldPasswordController,
              ),
              SizedBox(height: 20.h),
              CustomTextField(
                obsecure: true,
                text: "New Password",
                controller: _newPasswordController,
              ),
              SizedBox(height: 20.h),
              CustomTextField(
                obsecure: true,
                text: "Confirm Password",
                controller: _confirmPasswordController,
              ),
              SizedBox(height: 40.h),
              CustomButton(
                onPressed: _isLoading ? null : _changePassword,
                text: _isLoading ? "Changing..." : "Change Password",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
