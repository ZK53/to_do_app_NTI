import 'package:dio/dio.dart';
import 'package:to_do_app/core/network/end_points.dart';
import 'package:to_do_app/models/task_model.dart';

import 'auth_service.dart';

class TaskService {
  late final Dio _dio;

  TaskService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: EndPoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
      ),
    );
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = AuthService.accessToken;
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  /// Get all user tasks
  Future<Map<String, dynamic>> getMyTasks() async {
    try {
      print('=== GET TASKS API CALL ===');
      print('URL: ${EndPoints.baseUrl}${EndPoints.myTasks}');
      final response = await _dio.get(EndPoints.myTasks);
      print('Response Status: ${response.statusCode}');
      print('========================');

      List<dynamic> rawTasks = [];
      final dynamic jsonResponse = response.data;

      if (jsonResponse is List) {
        rawTasks = jsonResponse;
      } else if (jsonResponse is Map<String, dynamic>) {
        if (jsonResponse['data'] is List) {
          rawTasks = jsonResponse['data'];
        } else if (jsonResponse['tasks'] is List) {
          rawTasks = jsonResponse['tasks'];
        } else if (jsonResponse['my_tasks'] is List) {
          rawTasks = jsonResponse['my_tasks'];
        }
      }

      final tasks = rawTasks
          .map((item) => TaskModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();

      return {"status": "success", "data": tasks};
    } catch (e) {
      print('=== GET TASKS API ERROR ===');
      print('Error: $e');
      print('===========================');
      return {"status": "failed", "message": _handleException(e)};
    }
  }

  /// Create new task
  Future<Map<String, dynamic>> createTask({
    required String title,
    String? description,
    String? image,
    String? date,
    String? time,
  }) async {
    try {
      print('=== CREATE TASK API CALL ===');
      print('URL: ${EndPoints.baseUrl}${EndPoints.newTask}');
      print('Title: $title');

      final data = <String, dynamic>{
        'title': title,
        if (description != null && description.trim().isNotEmpty)
          'description': description,
        if (date != null && date.isNotEmpty) 'date': date,
        if (time != null && time.isNotEmpty) 'time': time,
      };

      if (image != null && image.isNotEmpty) {
        data['image'] = await MultipartFile.fromFile(image);
      }

      final formData = FormData.fromMap(data);
      final response = await _dio.post(EndPoints.newTask, data: formData);
      print('Response Status: ${response.statusCode}');
      print('============================');

      final jsonResponse = response.data as Map<String, dynamic>;
      return {
        "status": "success",
        "message": jsonResponse['message'] ?? 'Task created',
      };
    } catch (e) {
      print('=== CREATE TASK API ERROR ===');
      print('Error: $e');
      print('=============================');
      return {"status": "failed", "message": _handleException(e)};
    }
  }

  /// Update task
  Future<Map<String, dynamic>> updateTask({
    required String taskId,
    String? title,
    String? description,
    String? image,
    String? date,
    String? time,
  }) async {
    try {
      print('=== UPDATE TASK API CALL ===');
      print('URL: ${EndPoints.baseUrl}${EndPoints.tasks}/$taskId');
      print('Task ID: $taskId');

      final data = <String, dynamic>{
        if (title != null && title.trim().isNotEmpty) 'title': title,
        if (description != null && description.trim().isNotEmpty)
          'description': description,
        if (date != null && date.isNotEmpty) 'date': date,
        if (time != null && time.isNotEmpty) 'time': time,
      };

      if (image != null && image.isNotEmpty) {
        data['image'] = await MultipartFile.fromFile(image);
      }

      final formData = FormData.fromMap(data);
      final response = await _dio.put(
        "${EndPoints.tasks}/$taskId",
        data: formData,
      );
      print('Response Status: ${response.statusCode}');
      print('=============================');

      final jsonResponse = response.data as Map<String, dynamic>;
      return {
        "status": "success",
        "message": jsonResponse['message'] ?? 'Task updated',
      };
    } catch (e) {
      print('=== UPDATE TASK API ERROR ===');
      print('Error: $e');
      print('============================');
      return {"status": "failed", "message": _handleException(e)};
    }
  }

  /// Delete task
  Future<Map<String, dynamic>> deleteTask({required String taskId}) async {
    try {
      print('=== DELETE TASK API CALL ===');
      print('URL: ${EndPoints.baseUrl}${EndPoints.tasks}/$taskId');
      print('Task ID: $taskId');

      final response = await _dio.delete("${EndPoints.tasks}/$taskId");
      print('Response Status: ${response.statusCode}');
      print('=============================');

      final jsonResponse = response.data as Map<String, dynamic>;
      return {
        "status": "success",
        "message": jsonResponse['message'] ?? 'Task deleted',
      };
    } catch (e) {
      print('=== DELETE TASK API ERROR ===');
      print('Error: $e');
      print('============================');
      return {"status": "failed", "message": _handleException(e)};
    }
  }

  /// Handle exceptions
  String _handleException(dynamic exception) {
    if (exception is DioException) {
      if (exception.response != null) {
        final errorMessage =
            exception.response?.data['message'] ?? 'Error occurred';
        return errorMessage.toString();
      }
      return exception.message ?? 'Network error';
    }
    return exception.toString();
  }
}
