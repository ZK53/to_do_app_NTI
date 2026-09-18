import 'package:shared_preferences/shared_preferences.dart';

class AppInitialization {
  static const String _firstLaunchKey = "is_first_launch";
  static const String _accessTokenKey = "access_token";

  /// Check if user is authenticated by verifying if access token exists
  static Future<bool> isUserAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString(_accessTokenKey);
    return accessToken != null && accessToken.isNotEmpty;
  }

  /// Check if this is the first time the app is being launched
  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool(_firstLaunchKey) ?? true;
    return isFirstLaunch;
  }

  /// Mark the app as launched (not first launch anymore)
  static Future<void> markAppAsLaunched() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstLaunchKey, false);
  }

  /// Determine the initial route based on authentication and first launch
  /// Returns:
  /// - 'lets_start' if first launch
  /// - 'home' if authenticated
  /// - 'login' if not authenticated
  static Future<String> getInitialRoute() async {
    final firstLaunch = await isFirstLaunch();
    if (firstLaunch) {
      return 'lets_start';
    }

    final authenticated = await isUserAuthenticated();
    if (authenticated) {
      return 'home';
    }

    return 'login';
  }
}
