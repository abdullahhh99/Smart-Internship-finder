import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import 'smart_feed_screen.dart';
import '../resume/resume_upload_screen.dart';
import '../profile/profile_screen.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _selectedIndex = 0;

  // The list of screens that the navigation bar will cycle through
  final List<Widget> _screens = const [
    SmartFeedScreen(),
    ResumeUploadScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getAppBarTitle(_selectedIndex),
          style: const TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          // A little notification bell placeholder
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _screens[_selectedIndex],
      
      // Material 3 Navigation Bar
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: AppTheme.surfaceWhite,
        indicatorColor: AppTheme.primaryBlue.withOpacity(0.15),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.work_outline_rounded),
            selectedIcon: Icon(Icons.work_rounded, color: AppTheme.primaryBlue),
            label: 'Smart Feed',
          ),
          NavigationDestination(
            icon: Icon(Icons.upload_file_outlined),
            selectedIcon: Icon(Icons.upload_file_rounded, color: AppTheme.primaryBlue),
            label: 'Upload CV',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded, color: AppTheme.primaryBlue),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // Dynamic AppBar title based on the selected tab
  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return 'InternSeek';
      case 1:
        return 'AI Resume Analyzer';
      case 2:
        return 'My Profile';
      default:
        return 'InternSeek';
    }
  }
}