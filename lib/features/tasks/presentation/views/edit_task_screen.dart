import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/core/components/custom_date_time_picker.dart';
import 'package:to_do_app/core/components/custom_text_field.dart';
import 'package:to_do_app/core/utils/colors.dart';
import 'package:to_do_app/features/tasks/data/repo/tasks_repo.dart';

class EditTaskScreen extends StatefulWidget {
  final TasksRepo? tasksRepo;
  final String taskId;
  final String? initialTitle;
  final String? initialDescription;
  final String? initialGroup;

  const EditTaskScreen({
    super.key,
    this.tasksRepo,
    required this.taskId,
    this.initialTitle,
    this.initialDescription,
    this.initialGroup,
  });

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TasksRepo _tasksRepo = TasksRepo();

  String? group;
  bool isDone = false;
  DateTime? _selectedDateTime;

  final List<Map<String, String>> items = const [
    {'name': 'Home', 'image': 'assets/images/home.png'},
    {'name': 'Personal', 'image': 'assets/images/personal.png'},
    {'name': 'Work', 'image': 'assets/images/work.png'},
  ];

  @override
  void initState() {
    super.initState();
    group = widget.initialGroup ?? 'Home';
    _titleController.text = widget.initialTitle ?? 'Grocery Shopping App';
    _descriptionController.text =
        widget.initialDescription ??
        'Go for grocery to buy some products. Go for grocery to buy some products.';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _deleteTask() async {
    final repo = widget.tasksRepo ?? _tasksRepo;
    final result = await repo.deleteTask(taskId: widget.taskId);

    if (!mounted) return;

    if (result['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Task deleted successfully'),
        ),
      );
      Navigator.pop(context);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result['message'] ?? 'Failed to delete task')),
    );
  }

  void _markAsDone() {
    setState(() {
      isDone = !isDone;
    });
  }

  Future<void> _updateTask() async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a task title')),
      );
      return;
    }

    final repo = widget.tasksRepo ?? _tasksRepo;
    final result = await repo.updateTask(
      taskId: widget.taskId,
      title: title,
      description: description.isEmpty ? null : description,
      date: _selectedDateTime != null
          ? DateFormat('yyyy-MM-dd').format(_selectedDateTime!)
          : null,
      time: _selectedDateTime != null
          ? DateFormat('HH:mm').format(_selectedDateTime!)
          : null,
    );

    if (!mounted) return;

    if (result['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Task updated successfully'),
        ),
      );
      Navigator.pop(context);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result['message'] ?? 'Failed to update task')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: Colors.black,
          ),
        ),
        title: const Text(
          'Edit Task',
          style: TextStyle(
            color: Color(0xff292D32),
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: TextButton.icon(
              onPressed: _deleteTask,
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xffEF3030),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
              icon: Icon(Icons.delete_outline, size: 18.sp),
              label: Text('Delete', style: TextStyle(fontSize: 12.sp)),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: Image.asset(
                              'assets/images/flag.png',
                              width: 70.w,
                              height: 70.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 14.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isDone ? 'Done' : 'In Progress',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: const Color(0xff292D32),
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  isDone
                                      ? 'Congrats!'
                                      : 'Believe you can, and you\'re halfway there.',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: const Color(0xff292D32),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      SizedBox(
                        width: double.infinity,
                        height: 63.h,
                        child: DropdownButtonFormField<String>(
                          initialValue: group,
                          borderRadius: BorderRadius.circular(20.r),
                          decoration: InputDecoration(
                            hintText: 'Group',
                            hintStyle: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w300,
                              color: const Color(0xff8D879B),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 18.h,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22.r),
                              borderSide: const BorderSide(
                                color: Color(0xffD0D0D0),
                                width: 1.2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22.r),
                              borderSide: const BorderSide(
                                color: Color(0xffD0D0D0),
                                width: 1.2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22.r),
                              borderSide: const BorderSide(
                                color: Color(0xffD0D0D0),
                                width: 1.2,
                              ),
                            ),
                          ),
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Color(0xff292D32),
                          ),
                          items: items
                              .map(
                                (item) => DropdownMenuItem<String>(
                                  value: item['name'],
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        item['image']!,
                                        height: 24,
                                        width: 24,
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(width: 10.w),
                                      Text(
                                        item['name']!,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w300,
                                          color: const Color(0xff292D32),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              group = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 16.h),
                      CustomTextField(
                        text: 'Title',
                        obsecure: false,
                        controller: _titleController,
                      ),
                      SizedBox(height: 16.h),
                      _DescriptionField(controller: _descriptionController),
                      SizedBox(height: 16.h),
                      CustomDateTimeField(
                        onChanged: (dateTime) {
                          setState(() {
                            _selectedDateTime = dateTime;
                          });
                        },
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: ElevatedButton(
                        onPressed: _markAsDone,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff16A05D),
                          foregroundColor: Colors.white,
                          elevation: 4,
                          shadowColor: const Color(0xff16A05D),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        child: Text(
                          isDone ? 'Mark as Undone' : 'Mark as Done',
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: OutlinedButton(
                        onPressed: _updateTask,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xff16A05D),
                          side: const BorderSide(
                            color: Color(0xff16A05D),
                            width: 1.2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        child: Text(
                          'Update',
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DescriptionField extends StatelessWidget {
  final TextEditingController controller;

  const _DescriptionField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 123.h,
      child: TextFormField(
        controller: controller,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        decoration: InputDecoration(
          hintText: 'Description',
          hintStyle: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w300,
            color: const Color(0xff8D879B),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.all(16.w),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.r),
            borderSide: BorderSide.none,
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
