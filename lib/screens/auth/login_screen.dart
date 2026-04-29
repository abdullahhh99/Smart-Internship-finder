import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../services/auth_service.dart';
import '../dashboard/student_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  // This is the function that actually calls our new AuthService
  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true; // Start the loading spinner
    });

    final authService = AuthService();
    final userCred = await authService.signInWithGoogle();

    setState(() {
      _isLoading = false; // Stop the loading spinner
    });

    // If login is successful, navigate to the Student Dashboard
    if (userCred != null && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const StudentDashboard()),
      );
    } else if (mounted) {
      // If the user closes the popup or an error occurs
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign-in canceled or failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.travel_explore_rounded,
                size: 80,
                color: AppTheme.primaryBlue,
              ),
              const SizedBox(height: 32),
              const Text(
                'InternSeek',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your AI-Driven Internship Finder',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: size.height * 0.15),
              
              // Here is where we swap between the button and the loading spinner
              _isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryBlue))
                  : OutlinedButton.icon(
                      onPressed: _handleGoogleSignIn, // Now points to our actual logic
                      icon: const Icon(Icons.g_mobiledata, size: 32),
                      label: const Text(
                        'Continue with Google',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.textDark,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}