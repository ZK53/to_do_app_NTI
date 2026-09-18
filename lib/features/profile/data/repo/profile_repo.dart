import 'package:dio/dio.dart';
import 'package:to_do_app/core/network/api_helper.dart';
import 'package:to_do_app/core/network/end_points.dart';

class ProfileRepo {
  final ApiHelper _apiHelper = ApiHelper();

  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await _apiHelper.postRequest(
        endpoint: EndPoints.changePassword,
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
          'new_password_confirm': confirmPassword,
        },
        isPrivate: true,
      );

      final jsonResponse = response.data as Map<String, dynamic>;
      return {"status": "success", "message": jsonResponse['message']};
    } catch (e) {
      return {"status": "failed", "message": _apiHelper.handleException(e)};
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    required String username,
    String? image,
  }) async {
    try {
      final data = <String, dynamic>{"username": username};
      if (image != null && image.isNotEmpty) {
        data['image'] = await MultipartFile.fromFile(image);
      }

      final response = await _apiHelper.postRequest(
        endpoint: EndPoints.updateProfile,
        data: data,
        isPrivate: true,
      );

      final jsonResponse = response.data as Map<String, dynamic>;
      return {"status": "success", "message": jsonResponse['message']};
    } catch (e) {
      return {"status": "failed", "message": _apiHelper.handleException(e)};
    }
  }
}
