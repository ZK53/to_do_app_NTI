import 'package:dio/dio.dart';
import 'package:to_do_app/core/network/end_points.dart';

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

  /// Change password
  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      print('=== CHANGE PASSWORD API CALL ===');
      print('URL: ${EndPoints.baseUrl}${EndPoints.changePassword}');

      final response = await _dio.post(
        EndPoints.changePassword,
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
          'new_password_confirm': confirmPassword,
        },
      );
      print('Response Status: ${response.statusCode}');
      print('==================================');

      final jsonResponse = response.data as Map<String, dynamic>;
      return {
        "status": "success",
        "message": jsonResponse['message'] ?? 'Password changed',
      };
    } catch (e) {
      print('=== CHANGE PASSWORD API ERROR ===');
      print('Error: $e');
      print('==================================');
      return {"status": "failed", "message": _handleException(e)};
    }
  }

  /// Update profile
  Future<Map<String, dynamic>> updateProfile({
    required String username,
    String? image,
  }) async {
    try {
      print('=== UPDATE PROFILE API CALL ===');
      print('URL: ${EndPoints.baseUrl}${EndPoints.updateProfile}');
      print('Username: $username');

      final data = <String, dynamic>{"username": username};
      if (image != null && image.isNotEmpty) {
        data['image'] = await MultipartFile.fromFile(image);
      }

      final formData = FormData.fromMap(data);
      final response = await _dio.post(EndPoints.updateProfile, data: formData);
      print('Response Status: ${response.statusCode}');
      print('=================================');

      final jsonResponse = response.data as Map<String, dynamic>;
      return {
        "status": "success",
        "message": jsonResponse['message'] ?? 'Profile updated',
      };
    } catch (e) {
      print('=== UPDATE PROFILE API ERROR ===');
      print('Error: $e');
      print('================================');
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
