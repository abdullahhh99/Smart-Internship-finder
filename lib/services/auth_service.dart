import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance; // v7 Singleton

  // Handle Google Sign-In
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // 1. Initialize Google Sign-In
      await _googleSignIn.initialize();

      // 2. Trigger the flow (authenticate() throws an exception if the user cancels)
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      
      // 3. Obtain the auth details (This is SYNCHRONOUS in v7+, drop the 'await'!)
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // 4. Create a new credential for Firebase
      // Firebase ONLY needs the idToken to verify identity. 
      // We do not need an accessToken unless we are interacting with Google APIs.
      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // 5. Sign in to Firebase with the generated credential
      return await _auth.signInWithCredential(credential);
      
    } on GoogleSignInException catch (e) {
      // Handles cases where the user closes the popup or initialization fails
      print("Google Sign-In Exception: ${e.code.name}");
      return null;
    } catch (e) {
      // Fallback error handling
      print("Unexpected error during Google Sign-In: $e");
      return null;
    }
  }

  // Handle Sign-Out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}