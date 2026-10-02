import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:to_do_app/core/components/custom_button.dart';
import 'package:to_do_app/core/components/custom_text_field.dart';
import 'package:to_do_app/core/utils/colors.dart';
import 'package:to_do_app/services/profile_service.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();

  final ProfileService _profileService = ProfileService();
  final ImagePicker _imagePicker = ImagePicker();

  String? _selectedImagePath;

  bool _isLoading = false;
  bool _isLoadingUser = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  // ============================================================
  // LOAD CURRENT USERNAME
  // ============================================================

  Future<void> _loadCurrentUser() async {
    final result = await _profileService.getUserData();

    if (!mounted) return;

    if (result['status'] == 'success') {
      final user = result['data'];

      setState(() {
        _usernameController.text = user.username ?? '';
        _isLoadingUser = false;
      });
    } else {
      setState(() {
        _isLoadingUser = false;
      });

      _showSnackBar(result['message'] ?? 'Failed to load user data');
    }
  }

  // ============================================================
  // PICK IMAGE
  // ============================================================

  Future<void> _pickImage() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImagePath = pickedFile.path;
      });
    }
  }

  // ============================================================
  // UPDATE PROFILE
  // ============================================================

  Future<void> _updateProfile() async {
    final username = _usernameController.text.trim();

    if (username.isEmpty) {
      _showSnackBar('Please enter a username');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await _profileService.updateProfile(
      username: username,
      image: _selectedImagePath,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (result['status'] == 'success') {
      _showSnackBar('Profile updated successfully');

      // Go back to ProfileScreen.
      // ProfileScreen will call get_user_data again.
      Navigator.pop(context);
    } else {
      _showSnackBar(result['message'] ?? 'Failed to update profile');
    }
  }

  // ============================================================
  // SNACKBAR
  // ============================================================

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(title: const Text("Update Profile"), centerTitle: true),

      body: _isLoadingUser
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20.w),

                child: Column(
                  children: [
                    // ================= IMAGE =================

                    GestureDetector(
                      onTap: _pickImage,

                      child: CircleAvatar(
                        radius: 70.r,

                        backgroundImage: _selectedImagePath != null
                            ? FileImage(File(_selectedImagePath!))
                            : const AssetImage("assets/images/flag.png"),

                        child: _selectedImagePath == null
                            ? Align(
                                alignment: Alignment.bottomRight,

                                child: Container(
                                  padding: EdgeInsets.all(8.w),

                                  decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                  ),

                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              )
                            : null,
                      ),
                    ),

                    SizedBox(height: 10.h),

                    Text(
                      "Tap to change profile picture",
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),

                    SizedBox(height: 40.h),

                    // ================= USERNAME =================
                    CustomTextField(
                      text: "Username",
                      obsecure: false,
                      controller: _usernameController,
                    ),

                    SizedBox(height: 40.h),

                    // ================= BUTTON =================
                    CustomButton(
                      onPressed: _isLoading ? null : _updateProfile,
                      text: _isLoading ? "Updating..." : "Update Profile",
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
