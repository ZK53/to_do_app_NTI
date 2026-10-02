// This is a simulation of what will be printed to the debug console
// when you try to register with username: Zakaria1 and password: 123456

void main() {
  print('=== REGISTER API CALL ===');
  print(
    'URL: https://ntitodo-production-8a7f.up.railway.app/api/auth/register',
  );
  print('Username: Zakaria1');
  print('Password: ******');
  print('Image Path: null');
  print('Sending FormData with username and password...');
  print('');
  print('Expected API Response:');
  print('Response Status: 200 (or error code)');
  print('Response Data: {JSON response from server}');
  print('========================');
  print('');
  print('If successful, you should see:');
  print('status: "success"');
  print('message: "Registration successful" (or server message)');
  print('');
  print('If failed, you should see:');
  print('=== REGISTER API ERROR ===');
  print('Error Type: DioException (or similar)');
  print('Error: {detailed error message}');
  print('===========================');
}

/*
INSTRUCTIONS TO TEST:
1. Run the app: flutter run
2. When the app opens, tap "Don't have account? Register"
3. Fill in:
   - Username: Zakaria1
   - Password: 123456
   - Confirm Password: 123456
4. Tap "Register" button
5. Open the Flutter Debug Console (View > Debug Console in VS Code)
6. Look for debug output starting with "=== REGISTER API CALL ==="
7. The output will show:
   - The exact URL being called
   - Request parameters
   - Response status and data
   - Any errors encountered

Common Issues to Check:
- Network connectivity (check if the API is reachable)
- Endpoint URL correctness (base URL + auth/register)
- API server response format
- Error messages from the server
*/
