import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  int _selectedTabIndex = 1; // 0 -> Sign In, 1 -> Sign Up

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "SIGN UP",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Improved Tab Bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300], // Background color of tab bar
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  _buildTabButton("SIGN IN", 0),
                  _buildTabButton("SIGN UP", 1),
                ],
              ),
            ),
          ),

          // Sign-Up Form
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildTextField("FULL NAME *", _fullNameController, 30, false),
                    _buildTextField("MOBILE NUMBER *", _mobileController, 10, false, isNumeric: true),
                    _buildTextField("EMAIL ADDRESS *", _emailController, 40, false),
                    _buildTextField("PASSWORD *", _passwordController, 20, true),
                    _buildTextField("CONFIRM PASSWORD *", _confirmPasswordController, 20, true),

                    SizedBox(height: 30),

                    // SIGN UP Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        // Handle Sign-Up Logic
                      },
                      child: Text(
                        "SIGN UP",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to build improved Tab Buttons
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

  // Function to build a text field
  Widget _buildTextField(String label, TextEditingController controller, int maxLength, bool isPassword,
      {bool isNumeric = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        TextFormField(
          controller: controller,
          obscureText: isPassword
              ? (label.contains("CONFIRM") ? !_isConfirmPasswordVisible : !_isPasswordVisible)
              : false,
          keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
          maxLength: maxLength,
          decoration: InputDecoration(
            counterText: "${controller.text.length}/$maxLength",
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      label.contains("CONFIRM")
                          ? (_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off)
                          : (_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                      color: Colors.black54,
                    ),
                    onPressed: () {
                      setState(() {
                        if (label.contains("CONFIRM")) {
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                        } else {
                          _isPasswordVisible = !_isPasswordVisible;
                        }
                      });
                    },
                  )
                : null,
          ),
          onChanged: (value) {
            setState(() {}); // To update character counter
          },
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
