import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTextField extends StatelessWidget {
  final String text;
  final Widget? prefixIcon;
  final String? suffixIcon;
  final bool obsecure;
  final void Function()? onPressed;
  final TextEditingController controller;

  const CustomTextField({
    super.key,
    required this.text,
    this.prefixIcon,
    this.suffixIcon,
    required this.obsecure,
    this.onPressed,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obsecure,
      obscuringCharacter: "*",
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        hintText: text,
        hintStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w200),
        prefixIcon: prefixIcon == null
            ? null
            : Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
                child: prefixIcon,
              ),
        suffixIcon: IconButton(
          onPressed: onPressed,
          icon: SvgPicture.asset(suffixIcon ?? ''),
        ),
      ),
      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w300),
    );
  }
}
