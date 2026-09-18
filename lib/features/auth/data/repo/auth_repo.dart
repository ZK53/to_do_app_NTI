import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/core/helper/navigation.dart';
import 'package:to_do_app/core/network/api_helper.dart' as api_helper;
import 'package:to_do_app/core/network/end_points.dart';
import 'package:to_do_app/features/auth/data/models/user_model.dart';
import 'package:to_do_app/features/auth/presentation/views/login_screen.dart';

class AuthRepo {
  final api_helper.ApiHelper _apiHelper = api_helper.ApiHelper();

  static const String _accessTokenKey = "access_token";
  static const String _refreshTokenKey = "refresh_token";

  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
    api_helper.accessToken = accessToken;
    api_helper.refreshToken = refreshToken;
  }

  static Future<void> loadTokens() async {
    final prefs = await SharedPreferences.getInstance();
    api_helper.accessToken = prefs.getString(_accessTokenKey);
    api_helper.refreshToken = prefs.getString(_refreshTokenKey);
  }

  static Future<void> logout({BuildContext? context}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    api_helper.accessToken = null;
    api_helper.refreshToken = null;

    if (context != null && context.mounted) {
      CustomNavigation.navigateAndRemoveAll(context, const LoginScreen());
    }
  }

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      var response = await _apiHelper.postRequest(
        endpoint: EndPoints.login,
        data: {"username": username, "password": password},
      );

      var jsonResponse = response.data as Map<String, dynamic>;
      await saveTokens(
        accessToken: jsonResponse['access_token'],
        refreshToken: jsonResponse['refresh_token'],
      );
      return {
        "status": "success",
        "data": UserModel.fromJson(jsonResponse['user']),
      };
    } catch (e) {
      return {"status": "failed", "message": _apiHelper.handleException(e)};
    }
  }

  Future<Map<String, dynamic>> register({
    required String username,
    required String password,
    String? imagePath,
  }) async {
    try {
      var response = await _apiHelper.postRequest(
        endpoint: EndPoints.register,
        data: {
          "username": username,
          "password": password,
          "image_path": imagePath != null
              ? await MultipartFile.fromFile(imagePath)
              : null,
        },
      );

      var jsonResponse = response.data as Map<String, dynamic>;
      return {"status": "success", "message": jsonResponse['message']};
    } catch (e) {
      return {"status": "failed", "message": _apiHelper.handleException(e)};
    }
  }

  Future<Map<String, dynamic>> refreshToken() async {
    try {
      var response = await _apiHelper.postRequest(
        endpoint: "endpoint",
        isRefresh: true,
      );

      var jsonResponse = response.data as Map<String, dynamic>;
      return {"status": "success", "message": jsonResponse['message']};
    } catch (e) {
      return {"status": "failed", "message": _apiHelper.handleException(e)};
    }
  }

  Future<Map<String, dynamic>> getUserData() async {
    try {
      var response = await _apiHelper.getRequest(
        endpoint: EndPoints.getUserData,
        isPrivate: true,
      );
      var jsonResponse = response.data as Map<String, dynamic>;
      return {"status": "success", "message": jsonResponse['message']};
    } catch (e) {
      return {"status": "failed", "message": _apiHelper.handleException(e)};
    }
  }

  Future<Map<String, dynamic>> deleteUser() async {
    try {
      var response = await _apiHelper.deleteRequest(
        endpoint: EndPoints.deleteUser,
        isPrivate: true,
      );
      var jsonResponse = response.data as Map<String, dynamic>;
      return {"status": "success", "message": jsonResponse['message']};
    } catch (e) {
      return {"status": "failed", "message": _apiHelper.handleException(e)};
    }
  }
}
