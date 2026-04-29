import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'screens/auth/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  // Ensures all binding are initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(const InternSeekApp());
}

class InternSeekApp extends StatelessWidget {
  const InternSeekApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InternSeek',
      debugShowCheckedModeBanner: false, // Removes the red debug banner
      theme: AppTheme.lightTheme,
      home: const LoginScreen(), // We will build this next
    );
  }
}