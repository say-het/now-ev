import 'dart:convert'; // <-- Add this line for jsonEncode

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class AtherScooterScreen extends StatefulWidget {
  final String brand;
  final String model;
  final String image;
  final String buttonText;

  const AtherScooterScreen({
    Key? key,
    required this.brand,
    required this.model,
    required this.image,
    required this.buttonText,
  }) : super(key: key);

  @override
  _AtherScooterScreenState createState() => _AtherScooterScreenState();
}

class _AtherScooterScreenState extends State<AtherScooterScreen> {
  DateTime? _startTime; // Track when user leaves the app

  /// Open Google in WebView and start timer
  Future<void> _launchBookingURL() async {
    final Uri url = Uri.parse('https://www.google.com');

    if (await canLaunchUrl(url)) {
      _startTime = DateTime.now(); // Save time when user leaves
      await launchUrl(
        url,
        mode: LaunchMode.inAppWebView, // Open in in-app browser
      );

      // Start a delayed check to send POST request when returning
      Timer(const Duration(seconds: 2), () => _sendPostRequest());
    } else {
      throw 'Could not launch $url';
    }
  }

  /// Send POST request with dummy data
  Future<void> _sendPostRequest() async {
    const String apiUrl = "http://192.168.208.149:5000/payment"; // Dummy API URL
    final DateTime endTime = DateTime.now(); // Capture return time

    final Map<String, dynamic> postData = {
      "user_id": "123456",   // Dummy User ID
      "ev_id": "EV001",      // Dummy EV ID
      "start_time": _startTime?.toIso8601String() ?? "", // Start time
      "amount": "5499",      // Dummy amount
      "payment_id": "PAY123", // Dummy payment ID
      "status": "success"    // Dummy status
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(postData),
      );

      if (response.statusCode == 200) {
        print("POST request successful: ${response.body}");
      } else {
        print("Failed to send POST request: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending POST request: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "${widget.brand} ${widget.model}",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Vehicle Image
            Padding(
              padding: const EdgeInsets.all(20),
              child: Image.network(widget.image, height: 200, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.image_not_supported, size: 100, color: Colors.grey);
              }),
            ),

            /// Subscription Price
            const Text(
              "SUBSCRIBE AT",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black54),
            ),
            const SizedBox(height: 5),
            const Text(
              "₹ 5,499/month",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            /// Info Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _infoColumn("Range", "100 km"),
                  _infoColumn("Top Speed", "90 km/h"),
                  _infoColumn("Charging Time", "5 hours 20 mins"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            /// Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Experience the future with the ${widget.brand} ${widget.model}. With a real-world range of 100km, advanced features, and a stylish design, this electric scooter is built for tomorrow!",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 30),

            /// "BOOK NOW" Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
              ),
              onPressed: _launchBookingURL, // Open Google, then send POST request
              child: Text(
                widget.buttonText,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Helper Widget for Info Columns
  Widget _infoColumn(String title, String value) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 5),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
      ],
    );
  }
}
