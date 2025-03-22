import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WebLauncherPage extends StatelessWidget {
  const WebLauncherPage({super.key});

  // Function to open URL in the browser
  Future<void> _launchInBrowser() async {
    final Uri url = Uri.parse('https://www.google.com');

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.inAppWebView, // Opens in in-app web view
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Open Google')),
      body: Center(
        child: ElevatedButton(
          onPressed: _launchInBrowser,
          child: const Text('Open Google'),
        ),
      ),
    );
  }
}
