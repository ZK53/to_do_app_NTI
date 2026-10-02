# Debug Guide: Registration Testing with Zakaria1 / 123456

## Expected Debug Console Output

When you register with:

- **Username**: Zakaria1
- **Password**: 123456

You should see these debug prints in the Flutter console:

### 1. From AuthService.register():

```
=== REGISTER API CALL ===
URL: https://ntitodo-production-8a7f.up.railway.app/api/auth/register
Username: Zakaria1
Password: ******
Image Path: null
Response Status: [HTTP Status Code]
Response Data: [Server Response JSON]
========================
```

### 2. From RegisterScreen.\_register():

```
=== REGISTER RESPONSE ===
Full Response: {status: success/failed, message: ..., data: ...}
Status: success or failed
Message: [Server message or error]
Data: [Any additional data from server]
========================
```

## What Each Part Means

### ✅ Successful Response (Status 200)

```
Response Status: 200
Response Data: {
  "message": "User registered successfully",
  "user": {
    "id": 1,
    "username": "Zakaria1",
    "image_path": null
  }
}
```

- The API accepted the registration
- User can now login with credentials

### ❌ Error Responses

#### 1. Username Already Exists (Status 400/422)

```
Response Status: 400
Response Data: {
  "message": "Username already exists",
  "errors": {"username": ["Username is already taken"]}
}
```

#### 2. Invalid Password (Status 400)

```
Response Status: 400
Response Data: {
  "message": "Validation error",
  "errors": {"password": ["Password must be at least 8 characters"]}
}
```

#### 3. Server Error (Status 500)

```
Response Status: 500
Response Data: {
  "message": "Internal server error",
  "error": "Database connection failed"
}
```

#### 4. Network Error

```
=== REGISTER API ERROR ===
Error Type: DioException
Error: Connection timeout
===========================
```

#### 5. Connection Refused

```
=== REGISTER API ERROR ===
Error Type: DioException
Error: Failed to connect to https://ntitodo-production-8a7f.up.railway.app/api/auth/register
===========================
```

## How to View Console Output

### In VS Code:

1. Run: `flutter run`
2. Open **Debug Console** (View → Debug Console)
3. Look for `=== REGISTER API CALL ===` text
4. Read the full output to see what happened

### In Android Studio:

1. Run: `flutter run`
2. Open **Logcat** (View → Tool Windows → Logcat)
3. Filter: `flutter:I`
4. Look for debug messages

### Via Terminal:

```bash
flutter run -v | grep "REGISTER"
```

## Possible Issues and Solutions

| Issue              | Debug Output               | Solution                                                  |
| ------------------ | -------------------------- | --------------------------------------------------------- |
| API not reachable  | Connection refused/timeout | Check internet, verify API URL                            |
| Username taken     | 400 error "already exists" | Try different username                                    |
| Password too short | 400 validation error       | Password must be 6+ chars (currently is 123456 = 6 chars) |
| Wrong endpoint     | 404 Not Found              | Verify URL: `.../auth/register`                           |
| Server down        | 500 Internal error         | Contact API maintainer                                    |
| CORS issue (Web)   | Network error              | Server needs CORS headers                                 |
| SSL Certificate    | Certificate error          | Verify API uses valid SSL                                 |

## Next Steps

1. **Run the app**: `flutter run`
2. **Navigate to Register**: Tap "Register" link on login screen
3. **Fill the form**:
   - Username: `Zakaria1`
   - Password: `123456`
   - Confirm: `123456`
4. **Tap Register button**
5. **Check Debug Console** for the output above
6. **Share the output** to debug further

## Notes

- Password `123456` is exactly 6 characters (minimum requirement)
- Username `Zakaria1` should be unique
- If already registered, try: `Zakaria2`, `Zakaria123`, etc.
- All debug prints will appear in order showing the complete flow
