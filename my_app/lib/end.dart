import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class Idk2 extends StatefulWidget {
  const Idk2({super.key});

  @override
  State<Idk2> createState() => _Idk2State();
}

class _Idk2State extends State<Idk2> {
  final TextEditingController _amountController = TextEditingController();
  bool _isLoading = false;

  Future<void> _createPayment(String amount) async {
    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('http://192.168.224.115:5000/pym'), // Flask backend URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'amount': amount}),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (!data.containsKey('checkout_url')) {
          _showError('Invalid response from server');
          return;
        }

        final String checkoutUrl = data['checkout_url'];

        // Open checkout page in browser
        _launchPaymentUrl(checkoutUrl);
      } else {
        _showError(jsonDecode(response.body)['error'] ?? 'Payment failed');
      }
    } catch (e) {
      _showError('Payment failed: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _launchPaymentUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      _showError("Could not open payment page.");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Your Ticket'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter Amount to Pay',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Amount (USD)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isLoading || _amountController.text.trim().isEmpty
                          ? null
                          : () => _createPayment(_amountController.text.trim()),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Pay Now'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
