// lib/services/gemini_service.dart
import 'dart:convert';
import 'package:firebase_ai/firebase_ai.dart';

class GeminiService {
  // 1. Define the strict JSON schema we want the AI to return
  static final _resumeSchema = Schema(
    SchemaType.object,
    properties: {
      'skills': Schema(
        SchemaType.array, 
        items: Schema(SchemaType.string),
        description: 'A list of all technical skills, programming languages, and frameworks found in the text.'
      ),
      'education_level': Schema(
        SchemaType.string, 
        description: 'The highest degree or certification mentioned (e.g., Bachelors in Software Engineering).'
      ),
      'years_of_experience': Schema(
        SchemaType.integer, 
        description: 'Total years of professional experience. Return 0 if it is a fresh graduate or intern.'
      ),
    },
    // FIX: Removed 'requiredProperties' entirely because firebase_ai 
    // strictly requires all properties by default!
  );

  // 2. Initialize the Gemini model via Firebase AI Logic (Developer API)
  // FIX: Changed .vertexAI() to .googleAI()
  final GenerativeModel _model = FirebaseAI.googleAI().generativeModel(
    model: 'gemini-2.5-flash', // The fastest model for text parsing
    generationConfig: GenerationConfig(
      responseMimeType: 'application/json', // Force JSON output
      responseSchema: _resumeSchema,        // Enforce our specific structure
    ),
  );

  // 3. The function to parse the raw text
  Future<Map<String, dynamic>?> parseResume(String rawText) async {
    try {
      final prompt = '''
        You are an expert technical recruiter system. 
        Analyze the following resume text and extract the candidate's core data.
        
        Resume Text:
        $rawText
      ''';

      final response = await _model.generateContent([Content.text(prompt)]);
      
      if (response.text != null) {
        // Safely decode the guaranteed JSON response into a Dart Map
        return jsonDecode(response.text!);
      }
      return null;
    } catch (e) {
      print("Gemini API Error: $e");
      return null;
    }
  }
}