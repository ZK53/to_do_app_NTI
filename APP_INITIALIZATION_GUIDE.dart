// ignore_for_file: file_names

// APP OVERVIEW
// ============
// This project is a Flutter task management app built around a simple
// authentication flow and a task dashboard. The app uses SharedPreferences for
// session persistence and a repo-based API layer for login, profile updates,
// and task operations.
//
// The startup flow is:
// 1. Splash screen appears for a short time.
// 2. App checks whether it is the first launch.
// 3. If first launch → user sees the onboarding screen.
// 4. If the user is already logged in → app opens HomeScreen.
// 5. Otherwise → app opens LoginScreen.
//
// WIDGET USAGE
// ============
// 1. RootWidget (lib/core/helper/root_widget.dart)
//    - Chooses the first screen shown when the app opens.
//    - Uses a FutureBuilder to wait briefly, then select the correct route.
//    - Displays SplashScreen while checking login and first-launch state.
//
// 2. SplashScreen (lib/features/auth/presentation/views/splash_screen.dart)
//    - Brand/startup screen shown at app startup.
//    - Keeps the application feeling polished before the real screen loads.
//
// 3. LetsStartScreen (lib/features/auth/presentation/views/lets_start_screen.dart)
//    - Shows onboarding content for first-time users.
//    - When pressed, it marks the app as already launched and sends the user to
//      LoginScreen.
//
// 4. LoginScreen (lib/features/auth/presentation/views/login_screen.dart)
//    - Login form for username and password.
//    - Calls AuthRepo.login() and saves the returned access/refresh tokens.
//    - Redirects the user to HomeScreen after a successful login.
//
// 5. RegisterScreen (lib/features/auth/presentation/views/register_screen.dart)
//    - New account form.
//    - Validates input, calls AuthRepo.register(), and then routes the user to
//      the login screen after success.
//
// 6. HomeScreen (lib/features/home/presentation/views/home_screen.dart)
//    - Main dashboard after sign-in.
//    - Loads the user tasks from TasksRepo, displays them in a list, and lets
//      the user open the add/edit task screens.
//    - The profile avatar opens the ProfileScreen.
//
// 7. ProfileScreen (lib/features/profile/presentation/views/profile_screen.dart)
//    - Displays the user account menu.
//    - Lets the user open update profile, change password, and language settings.
//
// 8. UpdateProfileScreen (lib/features/profile/presentation/views/update_profile_screen.dart)
//    - Updates the current profile information.
//    - Uses ProfileRepo.updateProfile() and shows loading/error feedback.
//
// 9. ChangePasswordScreen (lib/features/profile/presentation/views/change_password_screen.dart)
//    - Lets the user change the account password.
//    - Uses ProfileRepo.changePassword() and displays validation and result
//      messages.
//
// 10. AddTaskScreen (lib/features/tasks/presentation/views/add_task_screen.dart)
//     - Form for creating a new task.
//     - Saves the title, description, and selected date/time through
//       TasksRepo.newTask().
//
// 11. EditTaskScreen (lib/features/tasks/presentation/views/edit_task_screen.dart)
//     - Displays selected task details for editing.
//     - Allows updating and deleting the task by calling TasksRepo.updateTask()
//       and TasksRepo.deleteTask().
//
// 12. AppInitialization (lib/core/helper/app_initialization.dart)
//     - Reads whether this is the first launch and whether a saved token exists.
//     - Decides the app route before the user sees any screen.
//
// 13. ApiHelper (lib/core/network/api_helper.dart)
//     - Central HTTP helper for API calls.
//     - Stores the access token and refresh token.
//     - Automatically retries requests when a 401 Unauthorized response occurs
//       and refreshes the token before retrying.
//
// STORAGE AND AUTH FLOW
// =====================
// - "is_first_launch" keeps track of whether the user has opened the app before.
// - "access_token" and "refresh_token" are stored in SharedPreferences after a
//   successful login.
// - If the access token expires, ApiHelper tries to refresh it using the stored
//   refresh token and then retries the failed request.
// - If refresh fails, the app clears the stored session and routes the user back
//   to LoginScreen.
//
// MAIN APP ENTRY
// ==============
// - main.dart initializes Flutter bindings and loads the stored tokens using
//   AuthRepo.loadTokens().
// - Then it launches the app with RootWidget as the home screen.
//
// BEST PRACTICES
// ==============
// - Always validate fields before sending API requests.
// - Use navigateAndRemoveAll() after login and onboarding to prevent the user
//   from going back to the old screens.
// - Ensure async calls check mounted before navigating after completion.
// - Keep the startup splash visible long enough to show the app branding.
