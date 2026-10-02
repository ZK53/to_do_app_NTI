class EndPoints {
  static final String baseUrl =
      "https://ntitodo-production-8a7f.up.railway.app/api/";

  // Auth endpoints
  static final String login = "login";
  static final String register = "register";
  static final String changePassword = "change_password";
  static final String refreshToken = "refresh_token";

  // Profile endpoints
  static final String updateProfile = "update_profile";
  static final String getUserData = "get_user_data";
  static final String deleteUser = "delete_user";

  // Task endpoints
  static final String newTask = "new_task";
  static final String tasks = "tasks";
  static final String myTasks = "my_tasks";
}
