import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/session/session_service.dart';
import 'screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SessionService.init();
  runApp(const AdminProjectManagementApp());
}

class AdminProjectManagementApp extends StatelessWidget {
  const AdminProjectManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Project Management',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
