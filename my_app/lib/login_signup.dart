import 'package:shared_preferences/shared_preferences.dart'; // Add this import
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_app/phone_auth.dart';
import 'package:my_app/vehicles.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  int _selectedTabIndex = 0; // 0 -> Login, 1 -> Sign-Up
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController =
      TextEditingController();
  final TextEditingController _signUpFullNameController =
      TextEditingController();
  final TextEditingController _signUpEmailController = TextEditingController();
  final TextEditingController _signUpPasswordController =
      TextEditingController();
  final TextEditingController _signUpConfirmPasswordController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  Future<SharedPreferences?> _getPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      print('SharedPreferences initialized successfully');
      return prefs;
    } catch (e) {
      print('Error initializing SharedPreferences: $e');
      return null; // Fallback to alternative storage if needed
    }
  }

  Future<void> _saveEmailToLocalStorage(String email) async {
    int retries = 3;
    while (retries > 0) {
      try {
        final prefs = await _getPrefs();
        if (prefs != null) {
          await prefs.setString('user_email', email);
          print('Email saved successfully: $email');
          return;
        } else {
          throw Exception('SharedPreferences unavailable');
        }
      } catch (e) {
        print('Error saving email (attempt ${4 - retries}/3): $e');
        retries--;
        if (retries == 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save email after retries: $e')),
          );
          // Fallback: Store in memory or alternative storage
          _fallbackEmailStorage(email);
        }
        await Future.delayed(Duration(milliseconds: 500)); // Wait before retry
      }
    }
  }

  // Fallback storage (in-memory)
  String? _fallbackEmail;
  void _fallbackEmailStorage(String email) {
    _fallbackEmail = email;
    print('Using fallback storage: $email');
  }

  Future<String?> _getEmailFromLocalStorage() async {
    try {
      final prefs = await _getPrefs();
      if (prefs != null) {
        return prefs.getString('user_email');
      } else if (_fallbackEmail != null) {
        return _fallbackEmail;
      }
      return null;
    } catch (e) {
      print('Error retrieving email: $e');
      return _fallbackEmail; // Return fallback if available
    }
  }

  // Google Sign-In Function
  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        return await FirebaseAuth.instance.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) return null;

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        return await FirebaseAuth.instance.signInWithCredential(credential);
      }
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }

  void _handleGoogleSignIn() async {
    try {
      UserCredential? userCredential = await signInWithGoogle();
      if (userCredential != null) {
        final user = userCredential.user;
        if (user?.email != null) {
          // Save email to local storage
          await _saveEmailToLocalStorage(user!.email!);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login Successful: ${user.displayName}')),
          );

          // Send user data to your API endpoint
          if (user.displayName != null && user.email != null) {
            await _sendUserDataToServer(user.displayName!, user.email!);
          }

          // Navigate to next screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => VerifyMobileApp()),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Sign in failed: $e')));
    }
  }

  // Example of how to use the stored email anywhere in your app
  Future<void> _useStoredEmail() async {
    String? storedEmail = await _getEmailFromLocalStorage();
    if (storedEmail != null) {
      // Use the email here
      print('Retrieved email: $storedEmail');
      // Example: Display it in a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Current user email: $storedEmail')),
      );
    }
  }
Future<String?> _fetchNgrokUrl() async {
  try {
    final response = await http.get(Uri.parse('https://middleman-server.vercel.app/ngrok-url'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['ngrokUrl']; // Assuming response format: { "ngrokUrl": "https://your-ngrok-url" }
    } else {
      print('Failed to fetch ngrok URL');
      return null;
    }
  } catch (e) {
    print('Error fetching ngrok URL: $e');
    return null;
  }
}
  Future<void> _sendUserDataToServer(String name, String email) async {
    try {
          String? ngrokUrl = await _fetchNgrokUrl();
if (ngrokUrl == null) {
      throw Exception("Ngrok URL not available");
    }

    // Construct the vehicle API URL
    String apiUrl = '$ngrokUrl/create_user';

      final response = await http.post(
        Uri.parse(
          apiUrl
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{'name': name, 'email': email}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Successfully created user
        print('User data sent successfully');
      } else {
        // Failed to create user
        print('Failed to send user data: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error sending user data: $e');
    }
  }

  Future<void> _clearStoredEmail() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_email');
  }

  void _handleEmailPasswordSignIn() async {
    try {
      if (_loginEmailController.text.isEmpty ||
          _loginPasswordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter both email and password')),
        );
        return;
      }

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: _loginEmailController.text.trim(),
            password: _loginPasswordController.text,
          );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login Successful')));

      // Navigate to VehiclesScreen after login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => VehiclesScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found with this email';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Incorrect password';
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Sign in failed: $e')));
    }
  }

  void _handleEmailPasswordSignUp() async {
    try {
      if (_signUpFullNameController.text.isEmpty ||
          _signUpEmailController.text.isEmpty ||
          _signUpPasswordController.text.isEmpty ||
          _addressController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill all required fields')),
        );
        return;
      }

      if (_signUpPasswordController.text !=
          _signUpConfirmPasswordController.text) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Passwords do not match')));
        return;
      }

      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _signUpEmailController.text.trim(),
            password: _signUpPasswordController.text,
          );

      // Update display name
      await userCredential.user?.updateDisplayName(
        _signUpFullNameController.text,
      );

      // Here you could save additional user data like address to Firestore/Database

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Sign Up Successful')));

      // Navigate to VehiclesScreen after sign up
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => VehiclesScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred';
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'An account already exists for this email';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email format';
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Sign up failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          _selectedTabIndex == 1 ? "SIGN UP" : "LOGIN",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  _buildTabButton("LOGIN", 0),
                  _buildTabButton("SIGN UP", 1),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child:
                    _selectedTabIndex == 1
                        ? _buildSignUpForm()
                        : _buildLoginForm(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, int index) {
    bool isActive = _selectedTabIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? Colors.green[700] : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Column(
      children: [
        _buildTextField("FULL NAME *", _signUpFullNameController, false),
        _buildTextField("EMAIL *", _signUpEmailController, false),
        _buildTextField("ADDRESS *", _addressController, false),
        _buildTextField("PASSWORD *", _signUpPasswordController, true),
        _buildTextField(
          "CONFIRM PASSWORD *",
          _signUpConfirmPasswordController,
          true,
        ),
        SizedBox(height: 30),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[700],
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: _handleEmailPasswordSignUp,
          child: Text(
            "SIGN UP",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        SizedBox(height: 20),
        _buildTextField("EMAIL *", _loginEmailController, false),
        _buildTextField("PASSWORD *", _loginPasswordController, true),
        SizedBox(height: 30),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[700],
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: _handleEmailPasswordSignIn,
          child: Text(
            "LOGIN",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 20),
        Center(child: Text("OR", style: TextStyle(color: Colors.black87))),
        SizedBox(height: 20),
        Center(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              side: BorderSide(color: Colors.black),
            ),
            onPressed: _handleGoogleSignIn,
            icon: Image.network(
              "https://static.vecteezy.com/system/resources/previews/011/598/471/original/google-logo-icon-illustration-free-vector.jpg", // Online image URL
              height: 24,
              width: 24,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.error,
                  color: Colors.red,
                ); // Fallback in case of an error
              },
            ),
            label: Text(
              "Login with Google",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    bool isPassword,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
            ),
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }

  @override
  void dispose() {
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _signUpFullNameController.dispose();
    _signUpEmailController.dispose();
    _signUpPasswordController.dispose();
    _signUpConfirmPasswordController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
