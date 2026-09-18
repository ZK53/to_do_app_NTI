import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/core/network/end_points.dart';

const String _accessTokenKey = "access_token";
const String _refreshTokenKey = "refresh_token";

String? accessToken;
String? refreshToken;

class ApiHelper {
  final Dio _dio = Dio(BaseOptions(baseUrl: EndPoints.baseUrl));

  Future<void> _loadSavedTokens() async {
    if (accessToken != null && refreshToken != null) return;

    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString(_accessTokenKey);
    refreshToken = prefs.getString(_refreshTokenKey);
  }

  Future<void> saveTokens({
    required String newAccessToken,
    required String newRefreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = newAccessToken;
    refreshToken = newRefreshToken;
    await prefs.setString(_accessTokenKey, newAccessToken);
    await prefs.setString(_refreshTokenKey, newRefreshToken);
  }

  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = null;
    refreshToken = null;
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
  }

  Future<Response> postRequest({
    required String endpoint,
    Map<String, dynamic>? data,
    bool isFormData = true,
    bool isPrivate = false,
    bool isRefresh = false,
  }) async {
    if (isPrivate || isRefresh) {
      await _loadSavedTokens();
    }

    return _dio.post(
      endpoint,
      data: data != null ? (isFormData ? FormData.fromMap(data) : data) : null,
      options: Options(
        headers: {if (isPrivate) "Authorization": "Bearer $accessToken"},
      ),
    );
  }

  Future<Response> getRequest({
    required String endpoint,
    Map<String, dynamic>? queryParams,
    bool isPrivate = false,
  }) async {
    if (isPrivate) {
      await _loadSavedTokens();
    }

    return _dio.post(
      endpoint,
      queryParameters: queryParams,
      options: Options(
        headers: {if (isPrivate) "Authorization": "Bearer $accessToken"},
      ),
    );
  }

  Future<Response> deleteRequest({
    required String endpoint,
    bool isPrivate = false,
  }) async {
    if (isPrivate) {
      await _loadSavedTokens();
    }

    return _dio.delete(
      endpoint,
      options: Options(
        headers: {if (isPrivate) "Authorization": "Bearer $accessToken"},
      ),
    );
  }

  Future<Response> putRequest({
    required String endpoint,
    Map<String, dynamic>? data,
    bool isFormData = true,
    bool isPrivate = false,
    bool isRefresh = false,
  }) async {
    if (isPrivate || isRefresh) {
      await _loadSavedTokens();
    }

    return _dio.put(
      endpoint,
      data: data != null ? (isFormData ? FormData.fromMap(data) : data) : null,
      options: Options(
        headers: {if (isPrivate) "Authorization": "Bearer $accessToken"},
      ),
    );
  }

  String handleException(Object e) {
    String errorMsg;

    if (e is DioException) {
      if (e.response!.data != null) {
        var errorResponse = e.response!.data as Map<String, dynamic>;
        errorMsg = errorResponse['message'];
      } else {
        errorMsg = "Network error happened, try again later";
      }
    } else {
      errorMsg = "Error happened, try again later";
    }
    return errorMsg;
  }
}
