import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'dart:math';

class AddToWalletScreen extends StatefulWidget {
  const AddToWalletScreen({Key? key}) : super(key: key);

  @override
  _AddToWalletScreenState createState() => _AddToWalletScreenState();
}

class _AddToWalletScreenState extends State<AddToWalletScreen> {
  final TextEditingController _amountController = TextEditingController();
  bool _isProcessing = false;
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

  /// Step 1: Make a POST request to get `checkout_url`
  Future<void> _createPayment() async {
    final String amount = _amountController.text.trim();
    if (amount.isEmpty ||
        double.tryParse(amount) == null ||
        double.parse(amount) <= 0) {
      _showStatusDialog(0, "Please enter a valid amount.");
      return;
    }

    setState(() => _isProcessing = true);

 String? ngrokUrl = await _fetchNgrokUrl();
    if (ngrokUrl == null) {
      throw Exception("Ngrok URL not available");
    }

    // Construct the vehicle API URL
    String apiUrl = '$ngrokUrl/cpayment';


    final Map<String, dynamic> requestData = {
      "user_id": "123456",
      "amount": amount,
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
        _openCheckout(checkoutUrl);
      } else {
        _showStatusDialog(response.statusCode, "Failed to create payment");
      }
    } catch (e) {
      _showStatusDialog(0, "Error: $e");
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  /// Step 2: Open `checkout_url`
  Future<void> _openCheckout(String url) async {
    final Uri checkoutUri = Uri.parse(url);

    if (await canLaunchUrl(checkoutUri)) {
      await launchUrl(checkoutUri, mode: LaunchMode.inAppWebView);
      Timer(const Duration(seconds: 2), _confirmPayment);
    } else {
      _showStatusDialog(0, "Could not open checkout URL");
    }
  }

  /// Step 3: Confirm Payment
  Future<void> _confirmPayment() async {
    String? ngrokUrl = await _fetchNgrokUrl();
    if (ngrokUrl == null) {
      throw Exception("Ngrok URL not available");
    }

    // Construct the vehicle API URL
    String apiUrl = '$ngrokUrl/create_rental';

    final String? userId = await _getUserIdFromLocalStorage();
    if (userId == null) {
      _showStatusDialog(0, "Error: User ID not found");
      return;
    }
    final String startTime = DateTime.now().toIso8601String();

    final String paymentId = _generateRandomPaymentId();
    final Map<String, dynamic> postData = {
      "user_email": userId,
      "ev_id": "1",
      "amount": _amountController.text.trim(),
      "start_time": startTime,
      "payment_id": "1",
      "status": "success",
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

  /// Retrieve user ID from local storage
  Future<String?> _getUserIdFromLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('user_email');
    } catch (e) {
      return null;
    }
  }

  /// Generate random payment ID
  String _generateRandomPaymentId() {
    final Random random = Random();
    return "PAY${random.nextInt(999999).toString().padLeft(6, '0')}";
  }

  /// Show AlertDialog with status message
  void _showStatusDialog(int statusCode, String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Payment Response"),
            content: Text("Status Code: $statusCode\n\nMessage: $message"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add to Wallet")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Enter Amount",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isProcessing ? null : _createPayment,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 40,
                ),
              ),
              child:
                  _isProcessing
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Add to Wallet"),
            ),
          ],
        ),
      ),
    );
  }
}
