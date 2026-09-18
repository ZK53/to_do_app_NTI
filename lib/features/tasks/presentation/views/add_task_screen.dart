import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/core/components/custom_button.dart';
import 'package:to_do_app/core/components/custom_date_time_picker.dart';
import 'package:to_do_app/core/components/custom_text_field.dart';
import 'package:to_do_app/core/utils/colors.dart';
import 'package:to_do_app/features/tasks/data/repo/tasks_repo.dart';

class AddTaskScreen extends StatefulWidget {
  final TasksRepo? tasksRepo;

  const AddTaskScreen({super.key, this.tasksRepo});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TasksRepo _tasksRepo = TasksRepo();
  DateTime? _selectedDateTime;
  String? group;

  final List<Map<String, String>> items = const [
    {'name': 'Home', 'image': 'assets/images/home.png'},
    {'name': 'Personal', 'image': 'assets/images/personal.png'},
    {'name': 'Work', 'image': 'assets/images/work.png'},
  ];

  Future<void> _addTask() async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a task title')),
      );
      return;
    }

    final repo = widget.tasksRepo ?? _tasksRepo;
    final result = await repo.newTask(
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
        SnackBar(content: Text(result['message'] ?? 'Task added successfully')),
      );
      Navigator.of(context).pop();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result['message'] ?? 'Failed to add task')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text("Add Task"), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 57.w, vertical: 30.h),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: Image.asset("assets/images/flag.png"),
              ),
            ),

            CustomTextField(
              text: "Title",
              obsecure: false,
              controller: _titleController,
            ),

            CustomTextField(
              text: "Description",
              obsecure: false,
              controller: _descriptionController,
            ),

            SizedBox(
              width: 331.w,
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
                  color: Color(0xff8D879B),
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

            CustomDateTimeField(
              onChanged: (dateTime) {
                setState(() {
                  _selectedDateTime = dateTime;
                });
              },
            ),

            SizedBox(height: 15.h),

            CustomButton(onPressed: _addTask, text: "Add Task"),
          ],
        ),
      ),
    );
  }
}
