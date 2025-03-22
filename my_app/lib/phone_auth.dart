import 'package:flutter/material.dart';
import 'otp.dart'; // Import the OTP screen


class VerifyMobileApp extends StatelessWidget {
  const VerifyMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VerifyMobileScreen(),
    );
  }
}

class VerifyMobileScreen extends StatefulWidget {
  const VerifyMobileScreen({super.key});

  @override
  State<VerifyMobileScreen> createState() => _VerifyMobileScreenState();
}

class _VerifyMobileScreenState extends State<VerifyMobileScreen> {
  final TextEditingController _mobileController = TextEditingController();
  final int maxLength = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "VERIFY MOBILE",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Verify your mobile number",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Enter the Mobile Number associated with your account",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "MOBILE NUMBER *",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[700]),
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: _mobileController,
              keyboardType: TextInputType.phone,
              maxLength: maxLength,
              decoration: InputDecoration(
                counterText: "${_mobileController.text.length}/$maxLength",
                border: const UnderlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: _mobileController.text.length == maxLength
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OTPVerificationScreen(mobileNumber: _mobileController.text),
                          ),
                        );
                      }
                    : null,
                child: const Text(
                  "GET OTP",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
