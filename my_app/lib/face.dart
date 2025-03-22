import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class FaceVerificationScreen extends StatefulWidget {
  const FaceVerificationScreen({Key? key}) : super(key: key);

  @override
  _FaceVerificationScreenState createState() => _FaceVerificationScreenState();
}

class _FaceVerificationScreenState extends State<FaceVerificationScreen> {
  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  bool _isCameraInitialized = false;
  bool _isVerifying = false;
  String _statusMessage = "Ready to verify";
  String _verificationResult = "";
  File? _aadharImage;
  final ImagePicker _picker = ImagePicker();
  
  // Your API endpoint (replace with your actual backend URL)
  final String apiUrl = "http://192.168.208.115:5000/upload_aadhardetails";

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      _cameraController = CameraController(
        _cameras[1], // Using front camera (index 1)
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await _cameraController.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      setState(() {
        _statusMessage = "Camera initialization failed: $e";
      });
    }
  }

  Future<void> _pickAadharImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _aadharImage = File(image.path);
          _statusMessage = "Aadhaar image selected";
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = "Error selecting image: $e";
      });
    }
  }

  Future<void> _startVerification() async {
    if (_aadharImage == null) {
      setState(() {
        _statusMessage = "Please select Aadhaar image first";
      });
      return;
    }

    setState(() {
      _isVerifying = true;
      _statusMessage = "Processing...";
    });

    try {
      // Upload Aadhaar image to backend
      final result = await _uploadAadharImage();
      
      if (result == true) {
        setState(() {
          _verificationResult = "Verification successful";
          _statusMessage = "Face verified! Blink detection started";
        });
        // Start blink detection process here
        _startBlinkDetection();
      } else {
        setState(() {
          _verificationResult = "Verification Passed";
          _statusMessage = "Face verification failed. Please try again.";
          _isVerifying = false;
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = "Error: $e";
        _isVerifying = false;
      });
    }
  }

  Future<Map<String, dynamic>> _uploadAadharImage() async {
    if (_aadharImage == null) {
      throw Exception("No Aadhaar image selected");
    }

    try {
      // Create multipart request
      var dio = Dio();
      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(
          _aadharImage!.path,
          filename: "aadhaar.jpg",
          contentType: MediaType("image", "jpeg"),
        ),
      });

      // Send request to backend
      final response = await dio.post(apiUrl, data: formData);
      
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to upload image: $e");
    }
  }

  int _blinkCount = 0;
  bool _isBlinked = false;
  int _totalFrames = 0;
  double _threshold = 0.23; // Same as your Python EAR threshold

  void _startBlinkDetection() {
    // We're simulating blink detection here
    // In a real implementation, you would either:
    // 1. Use a Flutter package like google_ml_kit for on-device processing
    // 2. Send camera frames to your backend for processing
    
    setState(() {
      _blinkCount = 0;
      _statusMessage = "Blink 3 times to verify";
    });
    
    // For demonstration purposes, we'll simply detect face and simulate blinks
    // In a real implementation, you would send frames to your backend or use ML Kit
    _processCameraFrame();
  }

  Future<void> _processCameraFrame() async {
    if (!_isCameraInitialized || !mounted) return;

    if (_blinkCount >= 3) {
      setState(() {
        _statusMessage = "Verification complete! All steps passed.";
        _verificationResult = "User verified successfully";
        _isVerifying = false;
      });
      return;
    }

    try {
      // Take a picture
      XFile image = await _cameraController.takePicture();
      
      // Simulate blink detection
      // In reality, you would either:
      // 1. Use ML Kit to detect face landmarks and calculate EAR
      // 2. Send this image to your backend for processing
      
      _totalFrames++;
      
      // Simulate random blinks (for demo only)
      // In production, use actual eye detection algorithms
      if (_totalFrames % 20 == 0 && !_isBlinked) {
        _blinkCount++;
        _isBlinked = true;
        setState(() {
          _statusMessage = "Blink detected! Count: $_blinkCount/3";
        });
      } else if (_totalFrames % 20 != 0) {
        _isBlinked = false;
      }
      
      // Continue processing frames
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) _processCameraFrame();
      });
    } catch (e) {
      setState(() {
        _statusMessage = "Error processing frame: $e";
        _isVerifying = false;
      });
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Verification'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isCameraInitialized
                ? CameraPreview(_cameraController)
                : const Center(child: CircularProgressIndicator()),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  _statusMessage,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _verificationResult,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _verificationResult.contains("successful")
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _isVerifying ? null : _pickAadharImage,
                      child: const Text('Select Aadhaar'),
                    ),
                    ElevatedButton(
                      onPressed: _isVerifying ? null : _startVerification,
                      child: const Text('Start Verification'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}