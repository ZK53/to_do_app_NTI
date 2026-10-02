import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/core/network/end_points.dart';
import 'package:to_do_app/models/user_model.dart';

class AuthService {
  static const String _accessTokenKey = "access_token";
  static const String _refreshTokenKey = "refresh_token";

  static String? _accessToken;
  static String? _refreshToken;

  late final Dio _dio;

  AuthService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: EndPoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
      ),
    );
  }

  static String? get accessToken => _accessToken;
  static String? get refreshToken => _refreshToken;

  /// Load tokens from SharedPreferences on app start
  static Future<void> loadTokens() async {
    final prefs = await SharedPreferences.getInstance();

    _accessToken = prefs.getString(_accessTokenKey);
    _refreshToken = prefs.getString(_refreshTokenKey);
  }

  /// Save tokens to SharedPreferences
  static Future<void> _saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);

    _accessToken = accessToken;
    _refreshToken = refreshToken;
  }

  /// Clear tokens on logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);

    _accessToken = null;
    _refreshToken = null;
  }

  /// Login user
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      print('=== LOGIN API CALL ===');
      print('URL: ${EndPoints.baseUrl}${EndPoints.login}');
      print('Username: $username');
      print('Password: ${password.replaceAll(RegExp(r'.'), '*')}');

      final formData = FormData.fromMap({
        "username": username,
        "password": password,
      });

      final response = await _dio.post(EndPoints.login, data: formData);

      print('Response Status: ${response.statusCode}');
      print('Response Data: ${response.data}');
      print('========================');

      final jsonResponse = response.data as Map<String, dynamic>;

      await _saveTokens(
        accessToken: jsonResponse['access_token'] ?? '',
        refreshToken: jsonResponse['refresh_token'] ?? '',
      );

      return {
        "status": "success",
        "data": UserModel.fromJson(jsonResponse['user'] ?? {}),
      };
    } catch (e) {
      print('=== LOGIN API ERROR ===');
      print('Error Type: ${e.runtimeType}');
      print('Error: $e');
      print('=======================');
      return {"status": "failed", "message": _handleException(e)};
    }
  }

  /// Register user
  Future<Map<String, dynamic>> register({
    required String username,
    required String password,
    String? imagePath,
  }) async {
    try {
      print('=== REGISTER API CALL ===');
      print('URL: ${EndPoints.baseUrl}${EndPoints.register}');
      print('Username: $username');
      print('Password: ${password.replaceAll(RegExp(r'.'), '*')}');
      print('Image Path: $imagePath');

      final formData = FormData.fromMap({
        "username": username,
        "password": password,
        if (imagePath != null) "image": await MultipartFile.fromFile(imagePath),
      });

      final response = await _dio.post(EndPoints.register, data: formData);

      print('Response Status: ${response.statusCode}');
      print('Response Data: ${response.data}');
      print('========================');

      final jsonResponse = response.data as Map<String, dynamic>;

      return {
        "status": "success",
        "message": jsonResponse['message'] ?? 'Registration successful',
      };
    } catch (e) {
      print('=== REGISTER API ERROR ===');
      print('Error Type: ${e.runtimeType}');
      print('Error: $e');
      print('===========================');

      return {"status": "failed", "message": _handleException(e)};
    }
  }

  /// Refresh access token
  Future<Map<String, dynamic>> refreshAccessToken() async {
    try {
      print('=== REFRESH TOKEN API CALL ===');
      print('URL: ${EndPoints.baseUrl}${EndPoints.refreshToken}');

      final response = await _dio.post(
        EndPoints.refreshToken,
        data: {'refresh_token': _refreshToken ?? ''},
      );

      print('Response Status: ${response.statusCode}');
      print('Response Data: ${response.data}');
      print('================================');

      final jsonResponse = response.data as Map<String, dynamic>;

      await _saveTokens(
        accessToken: jsonResponse['access_token'] ?? '',
        refreshToken: jsonResponse['refresh_token'] ?? _refreshToken ?? '',
      );

      return {"status": "success"};
    } catch (e) {
      return {"status": "failed", "message": _handleException(e)};
    }
  }

  /// Check if user is logged in
  static bool isLoggedIn() {
    return _accessToken != null && _accessToken!.isNotEmpty;
  }

  /// Handle exceptions
  String _handleException(dynamic exception) {
    if (exception is DioException) {
      print('DioException Details:');
      print('Status Code: ${exception.response?.statusCode}');
      print('Response Data: ${exception.response?.data}');

      if (exception.response != null) {
        final data = exception.response?.data;

        if (data is Map) {
          // Try different possible error message fields
          return data['message']?.toString() ??
              data['error']?.toString() ??
              data['msg']?.toString() ??
              'Error occurred';
        }

        if (data is String) {
          return data;
        }

        return 'Error occurred';
      }

      return exception.message ?? 'Network error';
    }

    return exception.toString();
  }
}
