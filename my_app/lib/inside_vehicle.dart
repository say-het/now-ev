import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
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
  int get _totalAmount => _selectedHours * 5;
  DateTime? _startTime;

  /// Step 1: Create payment and get checkout URL
  Future<void> _createPayment() async {
    const String apiUrl = "http://localhost:5000/cpayment";

    final Map<String, dynamic> requestData = {
      "user_id": "123456",
      "ev_id": "EV001",
      "amount": _totalAmount.toString(),
      "hours": _selectedHours.toString()
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

  /// Step 2: Open WebView for Checkout
  void _openCheckout(String checkoutUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutWebView(
          checkoutUrl: checkoutUrl,
          onCheckoutCompleted: (bool success) {
            _confirmPayment(success);
          },
        ),
      ),
    );
  }

  /// Step 3: Confirm Payment after returning from checkout
  Future<void> _confirmPayment(bool success) async {
    const String apiUrl = "http://192.168.208.149:5000/payment";
    final DateTime endTime = DateTime.now();

    final Map<String, dynamic> postData = {
      "user_id": "123456",
      "ev_id": "EV001",
      "start_time": _startTime?.toIso8601String() ?? "",
      "amount": _totalAmount.toString(),
      "payment_id": "PAY123",
      "status": success ? "success" : "fail"
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
              onPressed: () => Navigator.pop(context),
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const Text("\$5 per hour", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),

          /// Select Hours Dropdown
          Row(
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

          const SizedBox(height: 10),
          Text("Total: \$$_totalAmount", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),

          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15)),
            onPressed: _createPayment,
            child: Text(widget.buttonText, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

/// Checkout WebView with URL Monitoring
class CheckoutWebView extends StatefulWidget {
  final String checkoutUrl;
  final Function(bool success) onCheckoutCompleted;

  const CheckoutWebView({Key? key, required this.checkoutUrl, required this.onCheckoutCompleted}) : super(key: key);

  @override
  _CheckoutWebViewState createState() => _CheckoutWebViewState();
}

class _CheckoutWebViewState extends State<CheckoutWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (String url) {
          if (url != widget.checkoutUrl) {
            widget.onCheckoutCompleted(true); // Payment success
            Navigator.pop(context);
          }
        },
        onWebResourceError: (error) {
          widget.onCheckoutCompleted(false); // Payment failed
          Navigator.pop(context);
        },
      ));
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller..loadRequest(Uri.parse(widget.checkoutUrl)));
  }
}
