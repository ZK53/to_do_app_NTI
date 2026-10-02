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
  String? _selectedImagePath;
  bool _isLoading = false;

  final _profileService = ProfileService();
  final _imagePicker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() => _selectedImagePath = pickedFile.path);
    }
  }

  Future<void> _updateProfile() async {
    final username = _usernameController.text.trim();

    if (username.isEmpty) {
      _showSnackBar('Please enter a username');
      return;
    }

    setState(() => _isLoading = true);

    final result = await _profileService.updateProfile(
      username: username,
      image: _selectedImagePath,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result['status'] == 'success') {
      _showSnackBar('Profile updated successfully');
      Navigator.pop(context);
    } else {
      _showSnackBar(result['message'] ?? 'Failed to update profile');
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Update Profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 70.r,
                  backgroundImage: _selectedImagePath != null
                      ? FileImage(
                          // ignore: unnecessary_cast
                          _selectedImagePath as dynamic,
                        )
                      : const AssetImage("assets/images/flag.png")
                          as ImageProvider,
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
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 40.h),
              CustomTextField(
                text: "Username",
                obsecure: false,
                controller: _usernameController,
              ),
              SizedBox(height: 40.h),
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
