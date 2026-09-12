import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:to_do_app/core/utils/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        shape: CircleBorder(),
        backgroundColor: Colors.transparent,
        elevation: 0,
        highlightElevation: 0,
        child: Container(
          height: 50.h,
          width: 50.w,
          decoration: BoxDecoration(
            color: AppColors.button,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 4),
                spreadRadius: 0,
                blurRadius: 4,
                color: Color(0xff00000040),
              ),
            ],
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(13),
            child: SvgPicture.asset("assets/images/add_todo_icon.svg"),
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            _headerBuilder(),
            Expanded(child: _todoListBulder()),
          ],
        ),
      ),
    );
  }

  Widget _headerBuilder() {
    return Padding(
      padding: EdgeInsets.only(top: 20.h, left: 20.w),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage("assets/images/flag.png"),
            radius: 30,
          ),
          SizedBox(width: 16.w),
          Column(
            children: [
              Text(
                "Hello!",
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w300),
              ),
              SizedBox(height: 4.h),
              Text(
                "Ahmed Saber",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _noTodoBuilder() {
    return Padding(
      padding: EdgeInsets.only(top: 143.h),
      child: Column(
        children: [
          Text(
            "There are no tasks yet,\nPress the button\nTo add New Task ",
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w300),
            textAlign: TextAlign.center,
          ),
          SvgPicture.asset(
            "assets/images/home_no_todo.svg",
            height: 268.h,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _todoListBulder() {
    return Padding(
      padding: EdgeInsets.only(top: 43.h, left: 20.w, right: 20.w),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Tasks",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w300,
                  color: Color(0xFF24252C),
                ),
              ),
              SizedBox(width: 20.w),
              Container(
                height: 15.h,
                width: 14.w,
                decoration: BoxDecoration(
                  color: Color(0xFFCEEBDC),
                  borderRadius: BorderRadius.circular(5),
                ),
                alignment: Alignment.center,
                child: Text(
                  "4",
                  style: TextStyle(
                    color: Color(0xFF149954),
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          SizedBox(height: 31.h),
          Expanded(
            child: ListView(
              children: [
                _todoCardBuilder(),
                _todoCardBuilder(),
                _todoCardBuilder(),
                _todoCardBuilder(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _todoCardBuilder() {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(13),
      decoration: BoxDecoration(
        // color: Color.fromARGB(154, 196, 225, 134),
        color: Color(0xFFCEEBDC),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            offset: Offset(0, 4),
            color: Color.fromRGBO(0, 0, 0, 0.25),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 15,
            children: [
              Text(
                "My First Task",
                style: TextStyle(color: Color.fromRGBO(110, 106, 124, 1)),
              ),
              Text(
                "Improve my English skills\nby trying to speak",
                style: TextStyle(color: Color.fromRGBO(36, 37, 44, 1)),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "11/03/2025",
                  style: TextStyle(color: Color.fromRGBO(110, 106, 124, 1)),
                ),
                Text(
                  "05:00 PM",
                  style: TextStyle(color: Color.fromRGBO(110, 106, 124, 1)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
