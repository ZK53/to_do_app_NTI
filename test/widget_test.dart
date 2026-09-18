import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_app/features/home/presentation/views/home_screen.dart';
import 'package:to_do_app/features/profile/presentation/views/change_password_screen.dart';
import 'package:to_do_app/features/profile/presentation/views/profile_screen.dart';
import 'package:to_do_app/features/profile/presentation/views/update_profile_screen.dart';
import 'package:to_do_app/features/tasks/data/models/task_model.dart';
import 'package:to_do_app/features/tasks/data/repo/tasks_repo.dart';

class _FakeTasksRepo extends TasksRepo {
  @override
  Future<Map<String, dynamic>> getMyTasks() async {
    return {
      'status': 'success',
      'data': [
        TaskModel(
          id: '1',
          title: 'My First Task',
          description: 'Improve my English skills by trying to speak',
          date: '11/03/2025',
          time: '05:00 PM',
        ).toJson(),
      ],
    };
  }
}

void main() {
  testWidgets('change password item opens the change password screen', (
    tester,
  ) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, _) => const MaterialApp(home: ProfileScreen()),
      ),
    );

    await tester.tap(find.text('Change Password'));
    await tester.pumpAndSettle();
    expect(find.byType(ChangePasswordScreen), findsOneWidget);
  });

  testWidgets('profile item opens the update profile screen', (tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, _) => const MaterialApp(home: ProfileScreen()),
      ),
    );

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.byType(UpdateProfile), findsOneWidget);
  });

  testWidgets('home screen shows tasks and opens profile from avatar', (
    tester,
  ) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, _) =>
            MaterialApp(home: HomeScreen(tasksRepo: _FakeTasksRepo())),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('My First Task'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('profile_avatar')));
    await tester.pumpAndSettle();
    expect(find.byType(ProfileScreen), findsOneWidget);
  });
}
