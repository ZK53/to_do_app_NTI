import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:to_do_app/core/utils/colors.dart';

class ChangeLanguageScreen extends StatefulWidget {
  const ChangeLanguageScreen({super.key});

  @override
  State<ChangeLanguageScreen> createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  String selectedLanguage = "AR";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Settings"),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Transform.rotate(
            angle: pi,
            child: SvgPicture.asset(
              "assets/images/profile/arrow_icon.svg",
              height: 21.h,
              width: 21.w,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: ListTile(
        title: Text("Language"),
        trailing: SegmentedButton(
          segments: [
            ButtonSegment(
              value: "AR",
              label: Text(
                "AR",
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w300),
              ),
            ),
            ButtonSegment(
              value: "EN",
              label: Text(
                "EN",
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w300),
              ),
            ),
          ],
          selected: {selectedLanguage},
          onSelectionChanged: (selected) {
            setState(() {
              selectedLanguage = selected.first;
            });
          },
          showSelectedIcon: false,
          style: ButtonStyle(
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            ),
            backgroundColor: WidgetStateProperty.resolveWith((state) {
              if (state.contains(WidgetState.selected)) {
                return AppColors.button;
              } else {
                return Colors.white;
              }
            }),
            foregroundColor: WidgetStateProperty.resolveWith((state) {
              if (state.contains(WidgetState.selected)) {
                return Colors.white;
              } else {
                return Colors.black;
              }
            }),
          ),
        ),
      ),
    );
  }
}
