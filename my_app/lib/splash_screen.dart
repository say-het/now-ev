import 'package:flutter/material.dart';
import 'package:my_app/login_signup.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Add a delay and navigate to AuthScreen after 3 seconds
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthScreen()),
      );
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Replaced FlutterLogo with Image.network
            Image.network(
  "https://raw.githubusercontent.com/Jay-1409/Storage/refs/heads/main/image-removebg-preview.png",
  height: 200, // Increased height
  width: 200,  // Increased width
  fit: BoxFit.contain, // Ensures the image fits within the size
  errorBuilder: (context, error, stackTrace) {
    return Icon(Icons.error, size: 100, color: Colors.red);
  },
),
            const SizedBox(height: 20),
            const Text(
              'Welcome to nowEV',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
