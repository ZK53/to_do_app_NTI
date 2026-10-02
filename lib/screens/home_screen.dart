import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:to_do_app/core/helper/navigation.dart';
import 'package:to_do_app/core/utils/colors.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:to_do_app/screens/add_task_screen.dart';
import 'package:to_do_app/screens/edit_task_screen.dart';
import 'package:to_do_app/screens/profile_screen.dart';
import 'package:to_do_app/services/task_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TaskService _taskService;
  List<TaskModel> _tasks = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _taskService = TaskService();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() => _isLoading = true);

    try {
      final result = await _taskService.getMyTasks().timeout(
        const Duration(seconds: 15),
        onTimeout: () => {'status': 'failed', 'message': 'Request timed out'},
      );

      if (!mounted) return;

      if (result['status'] == 'success') {
        final data = result['data'] as List<TaskModel>;
        setState(() {
          _tasks = data;
          _isLoading = false;
        });
      } else {
        setState(() {
          _tasks = [];
          _isLoading = false;
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _tasks = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );
          if (result == true) {
            _loadTasks();
          }
        },
        shape: const CircleBorder(),
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
                offset: const Offset(0, 4),
                spreadRadius: 0,
                blurRadius: 4,
                color: const Color(0x40000000),
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
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  _buildHeader(context),
                  Expanded(
                    child: _tasks.isEmpty
                        ? _buildEmptyState()
                        : _buildTaskList(),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h, left: 20.w),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              CustomNavigation.navigationPush(context, const ProfileScreen());
            },
            child: CircleAvatar(
              backgroundImage: const AssetImage("assets/images/flag.png"),
              radius: 30,
            ),
          ),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello!",
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w300),
              ),
              SizedBox(height: 4.h),
              Text(
                "User",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: EdgeInsets.only(top: 143.h),
      child: Column(
        children: [
          Text(
            "There are no tasks yet,\nPress the button\nTo add New Task",
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

  Widget _buildTaskList() {
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
                  color: const Color(0xFF24252C),
                ),
              ),
              SizedBox(width: 20.w),
              Container(
                height: 15.h,
                width: 14.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFCEEBDC),
                  borderRadius: BorderRadius.circular(5),
                ),
                alignment: Alignment.center,
                child: Text(
                  _tasks.length.toString(),
                  style: TextStyle(
                    color: const Color(0xFF149954),
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
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return GestureDetector(
                  onTap: () async {
                    final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            EditTaskScreen(taskId: task.id, taskModel: task),
                      ),
                    );
                    if (result == true) {
                      _loadTasks();
                    }
                  },
                  child: _buildTaskCard(task),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(TaskModel task) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFCEEBDC),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            offset: const Offset(0, 4),
            color: const Color.fromRGBO(0, 0, 0, 0.25),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(
                    color: Color.fromRGBO(110, 106, 124, 1),
                  ),
                ),
                SizedBox(height: 15.h),
                Text(
                  task.description,
                  style: const TextStyle(color: Color.fromRGBO(36, 37, 44, 1)),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  task.date ?? 'No date',
                  style: const TextStyle(
                    color: Color.fromRGBO(110, 106, 124, 1),
                  ),
                ),
                Text(
                  task.time ?? 'No time',
                  style: const TextStyle(
                    color: Color.fromRGBO(110, 106, 124, 1),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
