import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/services/auth_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('saves tokens and clears them on logout', () async {
    SharedPreferences.setMockInitialValues({});

    await AuthService.logout();

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('access_token'), isNull);
    expect(prefs.getString('refresh_token'), isNull);
    expect(AuthService.isLoggedIn(), false);
  });
}
