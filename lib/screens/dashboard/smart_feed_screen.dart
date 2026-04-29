import 'package:flutter/material.dart';

class SmartFeedScreen extends StatelessWidget {
  const SmartFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Smart Feed: AI Job Matches Will Appear Here', 
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
    );
  }
}