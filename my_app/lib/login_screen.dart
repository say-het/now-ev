import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'phone_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Check if platform is web
      if (kIsWeb) {
        // Web implementation
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        return await FirebaseAuth.instance.signInWithPopup(googleProvider);
      } else {
        // Android/iOS implementation
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        
        if (googleUser == null) {
          // User canceled the sign-in flow
          return null;
        }

        // Obtain the auth details from the request
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in with Firebase
        return await FirebaseAuth.instance.signInWithCredential(credential);
      }
    } catch (e) {
      print('Error signing in with Google: $e');
      rethrow;
    }
  }

  void _handleGoogleSignIn() async {
    UserCredential? userCredential = await signInWithGoogle();
    if (userCredential != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WelcomeScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleGoogleSignIn,
              child: Text('Sign in with Google'),
            ),
          ],
        ),
      ),
    );
  }
}