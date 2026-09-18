import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class CustomDateTimeField extends StatefulWidget {
  final String hint;
  final DateTime? initialDate;
  final ValueChanged<DateTime>? onChanged;

  const CustomDateTimeField({
    super.key,
    this.hint = 'Select date and time',
    this.initialDate,
    this.onChanged,
  });

  @override
  State<CustomDateTimeField> createState() => _CustomDateTimeFieldState();
}

class _CustomDateTimeFieldState extends State<CustomDateTimeField> {
  DateTime? selectedDateTime;

  @override
  void initState() {
    super.initState();
    selectedDateTime = widget.initialDate;
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();

    // 1. Pick Date
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null || !mounted) return;

    // 2. Pick Time
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedDateTime != null
          ? TimeOfDay.fromDateTime(selectedDateTime!)
          : TimeOfDay.now(),
    );

    if (pickedTime == null || !mounted) return;

    final result = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    setState(() {
      selectedDateTime = result;
    });

    widget.onChanged?.call(result);
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = selectedDateTime != null;

    return SizedBox(
      height: 63.h,
      width: 331.w,
      child: GestureDetector(
        onTap: _pickDateTime,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 15.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Icon(
                Icons.calendar_month,
                color: const Color(0xff16A05D),
                size: 30,
              ),

              const SizedBox(width: 24),

              Expanded(
                child: Text(
                  hasValue
                      ? DateFormat(
                          'd MMMM, yyyy   h:mm a',
                        ).format(selectedDateTime!)
                      : widget.hint,
                  style: TextStyle(
                    fontSize: 20,
                    color: hasValue
                        ? const Color(0xff292D32)
                        : const Color(0xff8D879B),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
