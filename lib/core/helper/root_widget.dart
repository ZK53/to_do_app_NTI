import 'package:flutter/material.dart';
import 'package:to_do_app/core/helper/app_initialization.dart';
import 'package:to_do_app/features/auth/presentation/views/lets_start_screen.dart';
import 'package:to_do_app/features/auth/presentation/views/login_screen.dart';
import 'package:to_do_app/features/auth/presentation/views/splash_screen.dart';
import 'package:to_do_app/features/home/presentation/views/home_screen.dart';

class RootWidget extends StatefulWidget {
  const RootWidget({super.key});

  @override
  State<RootWidget> createState() => _RootWidgetState();
}

class _RootWidgetState extends State<RootWidget> {
  late Future<Widget> _navigationFuture;

  @override
  void initState() {
    super.initState();
    _navigationFuture = _determineInitialScreen();
  }

  /// Determine which screen to show based on app state
  Future<Widget> _determineInitialScreen() async {
    // Show splash screen while checking app state
    await Future.delayed(const Duration(milliseconds: 500));

    final initialRoute = await AppInitialization.getInitialRoute();

    switch (initialRoute) {
      case 'lets_start':
        return const LetsStartScreen();
      case 'home':
        return const HomeScreen();
      case 'login':
      default:
        return const LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _navigationFuture,
      builder: (context, snapshot) {
        // Show splash screen while loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        // If there's an error, show login screen as fallback
        if (snapshot.hasError) {
          return const LoginScreen();
        }

        // Show the determined screen
        return snapshot.data ?? const LoginScreen();
      },
    );
  }
}
