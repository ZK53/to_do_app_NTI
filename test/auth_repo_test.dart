import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/core/network/api_helper.dart';
import 'package:to_do_app/features/auth/data/repo/auth_repo.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('saves tokens and clears them on logout', () async {
    SharedPreferences.setMockInitialValues({});

    await AuthRepo.saveTokens(
      accessToken: 'access-token-123',
      refreshToken: 'refresh-token-456',
    );

    expect(accessToken, 'access-token-123');
    expect(refreshToken, 'refresh-token-456');

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('access_token'), 'access-token-123');
    expect(prefs.getString('refresh_token'), 'refresh-token-456');

    await AuthRepo.logout();

    expect(accessToken, isNull);
    expect(refreshToken, isNull);
    expect(prefs.getString('access_token'), isNull);
    expect(prefs.getString('refresh_token'), isNull);
  });
}
