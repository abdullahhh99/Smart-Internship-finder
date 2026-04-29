import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../../core/app_theme.dart';
import '../../services/gemini_service.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResumeUploadScreen extends StatefulWidget {
  const ResumeUploadScreen({super.key});

  @override
  State<ResumeUploadScreen> createState() => _ResumeUploadScreenState();
}

class _ResumeUploadScreenState extends State<ResumeUploadScreen> {
  File? _selectedFile;
  String? _fileName;
  bool _isProcessing = false;
  String _extractedText = ""; // We will send this to Gemini later

  // 1. Function to open the file picker
  Future<void> _pickPDF() async {
    // FIX: Removed '.platform' from the call
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'], // Strictly limit to PDFs for resume parsing
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _fileName = result.files.single.name;
        _extractedText = ""; // Reset on new file
      });
    }
  }

  // 2. Function to extract text locally before sending to Gemini
  Future<void> _processResume() async {
    if (_selectedFile == null) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      // 1. Read the PDF document
      final PdfDocument document = PdfDocument(
        inputBytes: await _selectedFile!.readAsBytes(),
      );

      // 2. Extract the raw text locally
      String text = PdfTextExtractor(document).extractText();
      document.dispose();

      // 3. Send the raw text to Gemini for structured JSON extraction
      final geminiService = GeminiService();
      final parsedData = await geminiService.parseResume(text);

      setState(() {
        _extractedText = text;
        _isProcessing = false;
      });
      
      // 4. Verify the AI successfully returned the JSON
      if (parsedData != null && mounted) {
        // Extract the skills array specifically
        final List<dynamic> skillsList = parsedData['skills'] ?? [];
        
// --- NEW FIRESTORE LOGIC ---
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          // Save the extracted data to the 'users' collection
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'name': user.displayName ?? 'Student',
            'email': user.email,
            'role': 'student',
            'skills': skillsList, // Store the array of skills
            'education_level': parsedData['education_level'] ?? '',
            'years_of_experience': parsedData['years_of_experience'] ?? 0,
            'last_updated': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true)); // merge: true ensures we don't overwrite existing data
        }        
        
        // Show success dialogue with the extracted skills
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('AI Analysis Complete'),
            content: Text('Gemini successfully found ${skillsList.length} technical skills in your resume!\n\nSkills: ${skillsList.join(", ")}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context), 
                child: const Text('Awesome')
              )
            ],
          )
        );
      }

    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error reading PDF: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Upload Your Resume',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textDark),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'We will extract your skills to find the perfect internship match.',
            style: TextStyle(fontSize: 16, color: AppTheme.textLight),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),

          // Custom File Dropzone UI
          GestureDetector(
            onTap: _pickPDF,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.05),
                border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.3), width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _selectedFile == null ? Icons.upload_file_rounded : Icons.check_circle_rounded,
                    size: 64,
                    color: _selectedFile == null ? AppTheme.primaryBlue : Colors.green,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _fileName ?? 'Tap to select PDF',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _selectedFile == null ? AppTheme.primaryBlue : Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Conditional Button: Only show if a file is selected
          if (_selectedFile != null)
            _isProcessing
                ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryBlue))
                : ElevatedButton.icon(
                    onPressed: _processResume,
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('Analyze with AI'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
        ],
      ),
    );
  }
}