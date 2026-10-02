import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/core/components/custom_button.dart';
import 'package:to_do_app/core/components/custom_date_time_picker.dart';
import 'package:to_do_app/core/components/custom_text_field.dart';
import 'package:to_do_app/core/utils/colors.dart';
import 'package:to_do_app/services/task_service.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDateTime;
  String? _selectedGroup = 'Home';
  bool _isLoading = false;

  final _taskService = TaskService();

  final List<Map<String, String>> _groups = const [
    {'name': 'Home', 'image': 'assets/images/home.png'},
    {'name': 'Personal', 'image': 'assets/images/personal.png'},
    {'name': 'Work', 'image': 'assets/images/work.png'},
  ];

  Future<void> _addTask() async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty) {
      _showSnackBar('Please enter a task title');
      return;
    }

    setState(() => _isLoading = true);

    final result = await _taskService.createTask(
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
    setState(() => _isLoading = false);

    if (result['status'] == 'success') {
      _showSnackBar('Task added successfully');
      Navigator.pop(context, true);
    } else {
      _showSnackBar(result['message'] ?? 'Failed to add task');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Add Task"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: Image.asset(
                  "assets/images/flag.png",
                  height: 150.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 30.h),
              CustomTextField(
                text: "Title",
                obsecure: false,
                controller: _titleController,
              ),
              SizedBox(height: 15.h),
              CustomTextField(
                text: "Description",
                obsecure: false,
                controller: _descriptionController,
              ),
              SizedBox(height: 15.h),
              DropdownButtonFormField<String>(
                initialValue: _selectedGroup,
                decoration: InputDecoration(
                  hintText: 'Group',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 18.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22.r),
                    borderSide: const BorderSide(color: Color(0xffD0D0D0)),
                  ),
                ),
                items: _groups
                    .map(
                      (item) => DropdownMenuItem<String>(
                        value: item['name'],
                        child: Row(
                          children: [
                            Image.asset(
                              item['image']!,
                              height: 24,
                              width: 24,
                            ),
                            SizedBox(width: 10.w),
                            Text(item['name']!),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() => _selectedGroup = value);
                },
              ),
              SizedBox(height: 15.h),
              CustomDateTimeField(
                onChanged: (dateTime) {
                  setState(() => _selectedDateTime = dateTime);
                },
              ),
              SizedBox(height: 30.h),
              CustomButton(
                onPressed: _isLoading ? null : _addTask,
                text: _isLoading ? "Adding..." : "Add Task",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
