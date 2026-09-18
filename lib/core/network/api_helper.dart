import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/core/network/end_points.dart';

const String _accessTokenKey = "access_token";
const String _refreshTokenKey = "refresh_token";

String? accessToken;
String? refreshToken;

class ApiHelper {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: EndPoints.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
    ),
  );

  ApiHelper() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          final isRefreshRequest =
              error.requestOptions.extra['isRefreshRequest'] == true;

          if (error.response?.statusCode == 401 && !isRefreshRequest) {
            final refreshed = await ensureValidToken();
            if (refreshed) {
              final retryResponse = await _dio.request(
                error.requestOptions.path,
                data: error.requestOptions.data,
                queryParameters: error.requestOptions.queryParameters,
                options: Options(
                  method: error.requestOptions.method,
                  headers: {
                    ...error.requestOptions.headers,
                    if (accessToken != null && accessToken!.isNotEmpty)
                      'Authorization': 'Bearer $accessToken',
                  },
                  responseType: error.requestOptions.responseType,
                  contentType: error.requestOptions.contentType,
                  validateStatus: error.requestOptions.validateStatus,
                  receiveDataWhenStatusError:
                      error.requestOptions.receiveDataWhenStatusError,
                  followRedirects: error.requestOptions.followRedirects,
                  sendTimeout: error.requestOptions.sendTimeout,
                  receiveTimeout: error.requestOptions.receiveTimeout,
                ),
              );
              return handler.resolve(retryResponse);
            }
          }

          return handler.next(error);
        },
      ),
    );
  }

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

  Future<bool> ensureValidToken() async {
    await _loadSavedTokens();

    if (accessToken == null || accessToken!.isEmpty) {
      await clearTokens();
      return false;
    }

    if (refreshToken == null || refreshToken!.isEmpty) {
      await clearTokens();
      return false;
    }

    try {
      final response = await _dio.post(
        EndPoints.refreshToken,
        data: {'refresh_token': refreshToken},
        options: Options(
          extra: {'isRefreshRequest': true},
          headers: {
            'Authorization': 'Bearer $accessToken',
            'X-Refresh-Token': refreshToken!,
          },
        ),
      );

      final dynamic payload = response.data;
      final map = payload is Map
          ? Map<String, dynamic>.from(payload)
          : <String, dynamic>{};
      final newAccess = map['access_token'] ?? map['accessToken'];
      final newRefresh = map['refresh_token'] ?? map['refreshToken'];

      if (newAccess == null || newAccess.toString().isEmpty) {
        return false;
      }

      await saveTokens(
        newAccessToken: newAccess.toString(),
        newRefreshToken: (newRefresh ?? refreshToken!).toString(),
      );
      return true;
    } catch (_) {
      await clearTokens();
      return false;
    }
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
      if (isPrivate && !isRefresh) {
        final refreshed = await ensureValidToken();
        if (!refreshed && accessToken == null) {
          throw DioException(
            requestOptions: RequestOptions(path: endpoint),
            error: 'Unable to refresh expired token',
            type: DioExceptionType.unknown,
          );
        }
      }
    }

    return _dio.post(
      endpoint,
      data: data != null ? (isFormData ? FormData.fromMap(data) : data) : null,
      options: Options(
        extra: {'isRefreshRequest': isRefresh},
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
      final refreshed = await ensureValidToken();
      if (!refreshed && accessToken == null) {
        throw DioException(
          requestOptions: RequestOptions(path: endpoint),
          error: 'Unable to refresh expired token',
          type: DioExceptionType.unknown,
        );
      }
    }

    return _dio.get(
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
      final refreshed = await ensureValidToken();
      if (!refreshed && accessToken == null) {
        throw DioException(
          requestOptions: RequestOptions(path: endpoint),
          error: 'Unable to refresh expired token',
          type: DioExceptionType.unknown,
        );
      }
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
      if (isPrivate && !isRefresh) {
        final refreshed = await ensureValidToken();
        if (!refreshed && accessToken == null) {
          throw DioException(
            requestOptions: RequestOptions(path: endpoint),
            error: 'Unable to refresh expired token',
            type: DioExceptionType.unknown,
          );
        }
      }
    }

    return _dio.put(
      endpoint,
      data: data != null ? (isFormData ? FormData.fromMap(data) : data) : null,
      options: Options(
        extra: {'isRefreshRequest': isRefresh},
        headers: {if (isPrivate) "Authorization": "Bearer $accessToken"},
      ),
    );
  }

  String handleException(Object e) {
    String errorMsg;

    if (e is DioException) {
      final responseData = e.response?.data;
      if (responseData is Map<String, dynamic>) {
        errorMsg = responseData['message'] ?? "Network error happened";
      } else if (responseData is Map) {
        errorMsg = responseData['message'] ?? "Network error happened";
      } else {
        errorMsg = "Network error happened, try again later";
      }
    } else {
      errorMsg = "Error happened, try again later";
    }
    return errorMsg;
  }
}
