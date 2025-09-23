import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:lottie/lottie.dart';

class FaceVerificationScreen extends StatefulWidget {
  const FaceVerificationScreen({Key? key}) : super(key: key);

  @override
  _FaceVerificationScreenState createState() => _FaceVerificationScreenState();
}

class _FaceVerificationScreenState extends State<FaceVerificationScreen>
    with SingleTickerProviderStateMixin {
  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  bool _isCameraInitialized = false;
  bool _isProcessing = false;
  String _statusMessage = "Position your face in the frame";
  File? _aadharImage;
  final ImagePicker _picker = ImagePicker();
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

  // final String apiUrl =
  //     "https://3e9a-2402-a00-405-e1a3-4900-1065-4a70-db1d.ngrok-free.app/";

  // Animation controllers
  late AnimationController _animationController;
  late Animation<double> _scanAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _scanAnimation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      _cameraController = CameraController(
        _cameras[1], // Front camera
        ResolutionPreset.high,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _cameraController.initialize();
      setState(() => _isCameraInitialized = true);
    } catch (e) {
      setState(() => _statusMessage = "Camera initialization failed: $e");
    }
  }

  Future<void> _captureAndVerify() async {
    if (_aadharImage == null) {
      setState(() => _statusMessage = "Please select Aadhaar image first");
      return;
    }

    setState(() {
      _isProcessing = true;
      _statusMessage = "Capturing image...";
    });

    try {
      // Capture face image
      XFile imageFile = await _cameraController.takePicture();
      File faceImage = File(imageFile.path);

      setState(() => _statusMessage = "Verifying identity...");

      // Upload images directly without face centering check
      await _uploadImages(faceImage);
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _statusMessage = "Error: $e";
      });
    }
  }

  Future<void> _uploadImages(File faceImage) async {
    try {
      String? ngrokUrl = await _fetchNgrokUrl();
    if (ngrokUrl == null) {
      throw Exception("Ngrok URL not available");
    }

    // Construct the vehicle API URL
    // String apiUrl = '$ngrokUrl/fetch_ev';

      var dio = Dio();
      FormData formData = FormData.fromMap({
        "test_image": await MultipartFile.fromFile(
          faceImage.path,
          filename: "face.jpg",
          contentType: MediaType("image", "jpeg"),
        ),
        "image": await MultipartFile.fromFile(
          _aadharImage!.path,
          filename: "aadhar.jpg",
          contentType: MediaType("image", "jpeg"),
        ),
      });

      final response = await dio.post("$ngrokUrl/vvffaa", data: formData);

      setState(() {
        _isProcessing = false;
      });
      print(response);
      if (response.statusCode == 200) {
        setState(() => _statusMessage = "Verification successful!");
        // Show success animation or navigate to next screen
      } else {
        setState(
          () => _statusMessage = "Verification failed: ${response.statusCode}",
        );
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _statusMessage = "Upload failed: $e";
      });
    }
  }

  Future<void> _pickAadharImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _aadharImage = File(image.path);
        _statusMessage = "Aadhaar image selected. Ready for verification.";
      });
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Biometric Verification'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child:
                _isCameraInitialized
                    ? Stack(
                      alignment: Alignment.center,
                      children: [
                        // Camera preview
                        CameraPreview(_cameraController),

                        // Overlay with futuristic elements
                        _buildFuturisticOverlay(),

                        // Processing indicator
                        if (_isProcessing)
                          Container(
                            color: Colors.white.withOpacity(0.6),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const CircularProgressIndicator(
                                    color: Colors.green,
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    _statusMessage,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    )
                    : const Center(
                      child: CircularProgressIndicator(color: Colors.green),
                    ),
          ),
          _buildControlPanel(),
        ],
      ),
    );
  }

  Widget _buildFuturisticOverlay() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Animated face outline
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: 250,
                height: 320,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 2),
                  borderRadius: BorderRadius.circular(150),
                ),
              ),
            );
          },
        ),

        // Scanning effect
        AnimatedBuilder(
          animation: _scanAnimation,
          builder: (context, child) {
            return Positioned(
              top:
                  MediaQuery.of(context).size.height *
                  0.5 *
                  (1 + _scanAnimation.value) *
                  0.5,
              child: Container(
                width: 270,
                height: 3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.green.withOpacity(0.8),
                      Colors.green,
                      Colors.green.withOpacity(0.8),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                  ),
                ),
              ),
            );
          },
        ),

        // Corner markers for futuristic feel
        Positioned(top: 80, left: 60, child: _buildCornerMarker()),
        Positioned(top: 80, right: 60, child: _buildCornerMarker(flipX: true)),
        Positioned(
          bottom: 80,
          left: 60,
          child: _buildCornerMarker(flipY: true),
        ),
        Positioned(
          bottom: 80,
          right: 60,
          child: _buildCornerMarker(flipX: true, flipY: true),
        ),

        // Status text
        Positioned(
          bottom: 30,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _statusMessage,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCornerMarker({bool flipX = false, bool flipY = false}) {
    return Transform(
      alignment: Alignment.center,
      transform:
          Matrix4.identity()..scale(flipX ? -1.0 : 1.0, flipY ? -1.0 : 1.0),
      child: SizedBox(
        width: 20,
        height: 20,
        child: CustomPaint(painter: CornerPainter(color: Colors.green)),
      ),
    );
  }

  Widget _buildControlPanel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.green, width: 1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                icon: Icons.insert_drive_file,
                label: "Select Aadhaar",
                onPressed: _pickAadharImage,
              ),
              _buildActionButton(
                icon: Icons.camera_alt,
                label: "Capture & Verify",
                onPressed: _captureAndVerify,
                isPrimary: true,
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (_aadharImage != null)
            Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Aadhaar image selected",
                    style: TextStyle(
                      color: Colors.green.shade300,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isPrimary = false,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: isPrimary ? Colors.green : Colors.white,
            foregroundColor: Colors.black,
            side: BorderSide(color: Colors.green, width: isPrimary ? 0 : 1),
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon),
              const SizedBox(height: 4),
              Text(label, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom painter for corner markers
class CornerPainter extends CustomPainter {
  final Color color;

  CornerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

    // Draw an L shape
    final path =
        Path()
          ..moveTo(0, size.height * 0.4)
          ..lineTo(0, 0)
          ..lineTo(size.width * 0.4, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
