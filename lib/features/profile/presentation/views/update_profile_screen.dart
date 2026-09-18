import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:to_do_app/core/components/custom_button.dart';
import 'package:to_do_app/core/components/custom_text_field.dart';
import 'package:to_do_app/core/utils/colors.dart';
import 'package:to_do_app/features/profile/data/repo/profile_repo.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final TextEditingController _usernameController = TextEditingController();
  final ProfileRepo _profileRepo = ProfileRepo();
  bool _isLoading = false;

  Future<void> _saveProfile() async {
    final username = _usernameController.text.trim();

    if (username.isEmpty) {
      _showMessage('Username is required');
      return;
    }

    setState(() => _isLoading = true);

    final result = await _profileRepo.updateProfile(username: username);

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (result['status'] == 'success') {
      _showMessage(result['message'] ?? 'Profile updated successfully');
      Navigator.of(context).pop();
      return;
    }

    _showMessage(result['message'] ?? 'Failed to update profile');
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
                controller: _usernameController,
              ),
            ),
            SizedBox(height: 23.h),
            CustomButton(
              onPressed: _isLoading ? null : _saveProfile,
              text: _isLoading ? 'Loading...' : 'Save',
            ),
          ],
        ),
      ),
    );
  }
}
