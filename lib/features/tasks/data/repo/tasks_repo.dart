import 'package:dio/dio.dart';
import 'package:to_do_app/core/network/api_helper.dart';
import 'package:to_do_app/core/network/end_points.dart';
import 'package:to_do_app/features/tasks/data/models/task_model.dart';

class TasksRepo {
  final ApiHelper _apiHelper = ApiHelper();

  Future<Map<String, dynamic>> newTask({
    required String title,
    String? description,
    String? image,
    String? date,
    String? time,
  }) async {
    try {
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

      final response = await _apiHelper.postRequest(
        endpoint: EndPoints.newTask,
        data: data,
        isPrivate: true,
      );
      final jsonResponse = response.data as Map<String, dynamic>;
      return {"status": "success", "message": jsonResponse['message']};
    } catch (e) {
      return {"status": "failed", "message": _apiHelper.handleException(e)};
    }
  }

  Future<Map<String, dynamic>> updateTask({
    required String taskId,
    String? title,
    String? description,
    String? image,
    String? date,
    String? time,
  }) async {
    try {
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

      final response = await _apiHelper.putRequest(
        endpoint: "${EndPoints.tasks}/$taskId",
        data: data,
        isPrivate: true,
      );
      final jsonResponse = response.data as Map<String, dynamic>;
      return {"status": "success", "message": jsonResponse['message']};
    } catch (e) {
      return {"status": "failed", "message": _apiHelper.handleException(e)};
    }
  }

  Future<Map<String, dynamic>> getMyTasks() async {
    try {
      final response = await _apiHelper.getRequest(
        endpoint: EndPoints.myTasks,
        isPrivate: true,
      );

      final dynamic jsonResponse = response.data;
      List<dynamic> rawTasks = [];

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

      return {
        "status": "success",
        "data": tasks.map((task) => task.toJson()).toList(),
      };
    } catch (e) {
      return {"status": "failed", "message": _apiHelper.handleException(e)};
    }
  }

  Future<Map<String, dynamic>> deleteTask({required String taskId}) async {
    try {
      final response = await _apiHelper.deleteRequest(
        endpoint: "${EndPoints.tasks}/$taskId",
        isPrivate: true,
      );
      final jsonResponse = response.data as Map<String, dynamic>;
      return {"status": "success", "message": jsonResponse['message']};
    } catch (e) {
      return {"status": "failed", "message": _apiHelper.handleException(e)};
    }
  }
}
