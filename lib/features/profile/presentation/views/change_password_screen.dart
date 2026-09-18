import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:to_do_app/core/components/custom_button.dart';
import 'package:to_do_app/core/components/custom_text_field.dart';
import 'package:to_do_app/core/utils/colors.dart';
import 'package:to_do_app/features/profile/data/repo/profile_repo.dart';

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
  final ProfileRepo _profileRepo = ProfileRepo();
  bool _isLoading = false;

  Future<void> _savePassword() async {
    final currentPassword = _oldPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      _showMessage('Please fill all password fields');
      return;
    }

    if (newPassword != confirmPassword) {
      _showMessage('New password and confirm password must match');
      return;
    }

    setState(() => _isLoading = true);

    final result = await _profileRepo.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (result['status'] == 'success') {
      _showMessage(result['message'] ?? 'Password changed successfully');
      Navigator.of(context).pop();
      return;
    }

    _showMessage(result['message'] ?? 'Failed to change password');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipRRect(
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
                obsecure: true,
                text: "Old Password",
                controller: _oldPasswordController,
              ),
            ),
            SizedBox(height: 23.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 23.w),
              child: CustomTextField(
                obsecure: true,
                text: "New Password",
                controller: _newPasswordController,
              ),
            ),
            SizedBox(height: 23.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 23.w),
              child: CustomTextField(
                obsecure: true,
                text: "Confirm Password",
                controller: _confirmPasswordController,
              ),
            ),
            SizedBox(height: 23.h),
            CustomButton(
              onPressed: _isLoading ? null : _savePassword,
              text: _isLoading ? 'Loading...' : 'Save',
            ),
          ],
        ),
      ),
    );
  }
}
