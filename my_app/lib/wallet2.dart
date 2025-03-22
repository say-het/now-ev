import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentLandingPage extends StatefulWidget {
  const PaymentLandingPage({super.key});

  @override
  State<PaymentLandingPage> createState() => _PaymentLandingPageState();
}

class _PaymentLandingPageState extends State<PaymentLandingPage> {
  final TextEditingController _amountController = TextEditingController();
  bool _isLoading = false;
  String? _checkoutUrl;
  String? _qrCodeBase64;

  Future<void> _createPayment(String amount) async {
    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('http://192.168.224.115:5000/pym'), // Use your backend URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'amount': amount}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _checkoutUrl = data['checkout_url'];
          _qrCodeBase64 = data['qr_code_base64'];
        });

        // Automatically open the payment URL
        if (_checkoutUrl != null) {
          _launchPaymentUrl(_checkoutUrl!);
        }
      } else {
        _showError(jsonDecode(response.body)['error']);
      }
    } catch (e) {
      _showError('Payment failed: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _launchPaymentUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
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
              'Welcome to Ticket Booking',
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
                      onPressed: _isLoading || _amountController.text.isEmpty
                          ? null
                          : () => _createPayment(_amountController.text),
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
            if (_checkoutUrl != null && _qrCodeBase64 != null) ...[
              const SizedBox(height: 20),
              const Text(
                'Scan QR Code to Pay',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Image.memory(
                base64Decode(_qrCodeBase64!),
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => _launchPaymentUrl(_checkoutUrl!),
                child: Text(
                  'Or click here to pay',
                  style: const TextStyle(color: Colors.blue, fontSize: 16),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
