import 'dart:convert';
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
  int _selectedHours = 1; // Default 1 hour
  int get _totalAmount => _selectedHours * 5; // Calculate total amount ($5 per hour)
  DateTime? _startTime;

  /// Step 1: Make POST request to `/cpayment` to get `checkout_url`
  Future<void> _createPayment() async {
    const String apiUrl = "https://31f5-2402-a00-405-e1a3-4900-1065-4a70-db1d.ngrok-free.app/cpayment";

    final Map<String, dynamic> requestData = {
      "user_id": "123456",
      "ev_id": "EV001",
      "amount": _totalAmount.toString(), // Dynamically calculated amount
      "hours": _selectedHours.toString() // Send selected hours too
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        String checkoutUrl = responseData["checkout_url"];

        _startTime = DateTime.now();
        _openCheckout(checkoutUrl);
      } else {
        _showStatusDialog(response.statusCode, "Failed to create payment");
      }
    } catch (e) {
      _showStatusDialog(0, "Error creating payment: $e");
    }
  }

  /// Step 2: Open the `checkout_url` in an in-app browser
  Future<void> _openCheckout(String url) async {
    final Uri checkoutUri = Uri.parse(url);

    if (await canLaunchUrl(checkoutUri)) {
      await launchUrl(
        checkoutUri,
        mode: LaunchMode.inAppWebView, // Opens in the app
      );

      // After returning from checkout, proceed to final payment confirmation
      Timer(const Duration(seconds: 2), () => _confirmPayment());
    } else {
      _showStatusDialog(0, "Could not open checkout URL");
    }
  }

  /// Step 3: Make a POST request to `/payment` after returning
  Future<void> _confirmPayment() async {
    const String apiUrl = "https://31f5-2402-a00-405-e1a3-4900-1065-4a70-db1d.ngrok-free.app/payment";
    final DateTime endTime = DateTime.now();

    final Map<String, dynamic> postData = {
      "user_id": "123456",
      "ev_id": "EV001",
      "start_time": _startTime?.toIso8601String() ?? "",
      "amount": _totalAmount.toString(), // Send calculated amount
      "payment_id": "PAY123",
      "status": "fail"
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(postData),
      );

      _showStatusDialog(response.statusCode, response.body);
    } catch (e) {
      _showStatusDialog(0, "Error confirming payment: $e");
    }
  }

  /// Show AlertDialog with status code and message
  void _showStatusDialog(int statusCode, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Payment Response"),
          content: Text("Status Code: $statusCode\n\nMessage: $message"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close the dialog
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
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
            Padding(
              padding: const EdgeInsets.all(20),
              child: Image.network(widget.image, height: 200, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.image_not_supported, size: 100, color: Colors.grey);
              }),
            ),

            const Text(
              "Pricing",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              "\$5 per hour",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 20),

            /// Select Hours Dropdown
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Select Hours:", style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 10),
                  DropdownButton<int>(
                    value: _selectedHours,
                    items: List.generate(10, (index) => index + 1)
                        .map((hour) => DropdownMenuItem<int>(
                              value: hour,
                              child: Text("$hour hour${hour > 1 ? 's' : ''}"),
                            ))
                        .toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedHours = newValue!;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            /// Total Price Display
            Text(
              "Total: \$$_totalAmount",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
              ),
              onPressed: _createPayment, // Initiate payment
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
