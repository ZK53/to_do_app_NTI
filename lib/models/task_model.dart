class TaskModel {
  final String id;
  final String title;
  final String description;
  final String? date;
  final String? time;
  final String? image;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    this.date,
    this.time,
    this.image,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: (json['id'] ?? json['_id'] ?? json['task_id'] ?? '').toString(),
      title: (json['title'] ?? 'Untitled Task').toString(),
      description:
          (json['description'] ?? json['details'] ?? json['message'] ?? '')
              .toString(),
      date: _normalizeDate(
        json['date'] ?? json['created_at'] ?? json['due_date'],
      ),
      time: _normalizeTime(
        json['time'] ?? json['created_time'] ?? json['due_time'],
      ),
      image: json['image']?.toString(),
    );
  }

  static String? _normalizeDate(dynamic value) {
    if (value == null || value.toString().trim().isEmpty) return null;
    final text = value.toString();
    if (text.contains('T')) {
      return text.split('T').first;
    }
    return text;
  }

  static String? _normalizeTime(dynamic value) {
    if (value == null || value.toString().trim().isEmpty) return null;
    final text = value.toString();
    if (text.contains('T')) {
      return text.split('T').last.split('.').first;
    }
    return text;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      if (date != null) 'date': date,
      if (time != null) 'time': time,
      if (image != null) 'image': image,
    };
  }
}
