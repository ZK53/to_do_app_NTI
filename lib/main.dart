import 'package:flutter/material.dart' hide RootWidget;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:to_do_app/core/helper/root_widget.dart';
import 'package:to_do_app/features/auth/data/repo/auth_repo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthRepo.loadTokens();
  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, _) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: "LexendDeca"),
      home: const RootWidget(),
    );
  }
}
