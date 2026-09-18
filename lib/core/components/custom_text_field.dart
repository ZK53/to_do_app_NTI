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
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(22.r),
      borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
    );

    return SizedBox(
      height: 63.h,
      width: 331.w,
      child: TextFormField(
        controller: controller,
        obscureText: obsecure,
        obscuringCharacter: "*",
        decoration: InputDecoration(
          hintText: text,

          hintStyle: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w300,
            color: const Color(0xff8D879B),
          ),

          // Border في الحالة العادية
          border: border,

          // Border لما يكون الحقل مش Focused
          enabledBorder: border,

          // Border لما المستخدم يدوس على الحقل
          focusedBorder: border,

          // Border لو فيه Error
          errorBorder: border,

          // Border أثناء وجود Error + Focus
          focusedErrorBorder: border,

          prefixIcon: prefixIcon == null
              ? null
              : Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 16.h,
                    horizontal: 16.w,
                  ),
                  child: prefixIcon,
                ),

          suffixIcon: suffixIcon == null
              ? null
              : IconButton(
                  onPressed: onPressed,
                  icon: SvgPicture.asset(suffixIcon!),
                ),

          fillColor: Colors.white,
          filled: true,

          // مسافات داخلية
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 18.h,
          ),
        ),

        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w300,
          color: const Color(0xff292D32),
        ),
      ),
    );
  }
}
