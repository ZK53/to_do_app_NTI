import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/core/components/custom_button.dart';
import 'package:to_do_app/core/components/custom_date_time_picker.dart';
import 'package:to_do_app/core/components/custom_text_field.dart';
import 'package:to_do_app/core/utils/colors.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:to_do_app/services/task_service.dart';

class EditTaskScreen extends StatefulWidget {
  final String taskId;
  final TaskModel taskModel;

  const EditTaskScreen({
    super.key,
    required this.taskId,
    required this.taskModel,
  });

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  DateTime? _selectedDateTime;
  String? _selectedGroup = 'Home';
  bool _isLoading = false;

  final _taskService = TaskService();

  final List<Map<String, String>> _groups = const [
    {'name': 'Home', 'image': 'assets/images/home.png'},
    {'name': 'Personal', 'image': 'assets/images/personal.png'},
    {'name': 'Work', 'image': 'assets/images/work.png'},
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.taskModel.title);
    _descriptionController =
        TextEditingController(text: widget.taskModel.description);
  }

  Future<void> _updateTask() async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty) {
      _showSnackBar('Please enter a task title');
      return;
    }

    setState(() => _isLoading = true);

    final result = await _taskService.updateTask(
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
    setState(() => _isLoading = false);

    if (result['status'] == 'success') {
      _showSnackBar('Task updated successfully');
      Navigator.pop(context, true);
    } else {
      _showSnackBar(result['message'] ?? 'Failed to update task');
    }
  }

  Future<void> _deleteTask() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);

    final result = await _taskService.deleteTask(taskId: widget.taskId);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result['status'] == 'success') {
      _showSnackBar('Task deleted successfully');
      Navigator.pop(context, true);
    } else {
      _showSnackBar(result['message'] ?? 'Failed to delete task');
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
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        ),
        title: const Text('Edit Task'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
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
                onPressed: _isLoading ? null : _updateTask,
                text: _isLoading ? "Updating..." : "Update Task",
              ),
              SizedBox(height: 15.h),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _deleteTask,
                icon: const Icon(Icons.delete),
                label: const Text('Delete Task'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50.h),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
