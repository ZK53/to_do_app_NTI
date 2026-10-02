import 'package:dio/dio.dart';
import 'package:to_do_app/core/network/end_points.dart';
import 'package:to_do_app/models/user_model.dart';

import 'auth_service.dart';

class ProfileService {
  late final Dio _dio;

  ProfileService() {
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

  // ============================================================
  // GET USER DATA
  // ============================================================

  Future<Map<String, dynamic>> getUserData() async {
    try {
      print('=== GET USER DATA API CALL ===');
      print('URL: ${EndPoints.baseUrl}${EndPoints.getUserData}');

      final response = await _dio.get(EndPoints.getUserData);

      print('Response Status: ${response.statusCode}');
      print('Response Data: ${response.data}');
      print('================================');

      final dynamic responseData = response.data;

      Map<String, dynamic> jsonResponse = {};

      if (responseData is Map) {
        jsonResponse = Map<String, dynamic>.from(responseData);
      }

      // Try different possible response structures
      Map<String, dynamic> userData = {};

      if (jsonResponse['user'] is Map) {
        userData = Map<String, dynamic>.from(jsonResponse['user']);
      } else if (jsonResponse['data'] is Map) {
        userData = Map<String, dynamic>.from(jsonResponse['data']);
      } else {
        userData = jsonResponse;
      }

      final user = UserModel.fromJson(userData);

      return {'status': 'success', 'data': user};
    } catch (e) {
      print('=== GET USER DATA API ERROR ===');
      print('Error: $e');
      print('================================');

      return {'status': 'failed', 'message': _handleException(e)};
    }
  }

  // ============================================================
  // CHANGE PASSWORD
  // ============================================================

  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      print('=== CHANGE PASSWORD API CALL ===');
      print('URL: ${EndPoints.baseUrl}${EndPoints.changePassword}');

      // IMPORTANT:
      // Backend expects form-data
      final formData = FormData.fromMap({
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirm': confirmPassword,
      });

      final response = await _dio.post(
        EndPoints.changePassword,
        data: formData,
      );

      print('Response Status: ${response.statusCode}');
      print('Response Data: ${response.data}');
      print('==================================');

      final dynamic responseData = response.data;

      Map<String, dynamic> jsonResponse = {};

      if (responseData is Map) {
        jsonResponse = Map<String, dynamic>.from(responseData);
      }

      return {
        'status': 'success',
        'message': jsonResponse['message'] ?? 'Password changed successfully',
      };
    } catch (e) {
      print('=== CHANGE PASSWORD API ERROR ===');
      print('Error: $e');
      print('==================================');

      return {'status': 'failed', 'message': _handleException(e)};
    }
  }

  // ============================================================
  // UPDATE PROFILE
  // ============================================================

  Future<Map<String, dynamic>> updateProfile({
    required String username,
    String? image,
  }) async {
    try {
      print('=== UPDATE PROFILE API CALL ===');
      print('URL: ${EndPoints.baseUrl}${EndPoints.updateProfile}');
      print('Username: $username');

      final data = <String, dynamic>{'username': username};

      if (image != null && image.isNotEmpty) {
        data['image'] = await MultipartFile.fromFile(image);
      }

      final formData = FormData.fromMap(data);

      // IMPORTANT:
      // Postman shows PUT, not POST
      final response = await _dio.put(EndPoints.updateProfile, data: formData);

      print('Response Status: ${response.statusCode}');
      print('Response Data: ${response.data}');
      print('=================================');

      final dynamic responseData = response.data;

      Map<String, dynamic> jsonResponse = {};

      if (responseData is Map) {
        jsonResponse = Map<String, dynamic>.from(responseData);
      }

      return {
        'status': 'success',
        'message': jsonResponse['message'] ?? 'Profile updated successfully',
      };
    } catch (e) {
      print('=== UPDATE PROFILE API ERROR ===');
      print('Error: $e');
      print('================================');

      return {'status': 'failed', 'message': _handleException(e)};
    }
  }

  // ============================================================
  // EXCEPTION HANDLER
  // ============================================================

  String _handleException(dynamic exception) {
    if (exception is DioException) {
      print('DioException Status: ${exception.response?.statusCode}');
      print('DioException Data: ${exception.response?.data}');

      final data = exception.response?.data;

      if (data is Map) {
        return data['message']?.toString() ??
            data['error']?.toString() ??
            data['msg']?.toString() ??
            'Error occurred';
      }

      if (data is String && data.isNotEmpty) {
        return data;
      }

      return exception.message ?? 'Network error';
    }

    return exception.toString();
  }
}
