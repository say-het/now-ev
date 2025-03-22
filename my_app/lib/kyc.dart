import 'package:http/http.dart' as http;

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:image_cropper/image_cropper.dart';

// Define enum outside the class
enum DocumentType { aadhar, license }

class KycDocumentScreen extends StatefulWidget {
  @override
  _KycDocumentScreenState createState() => _KycDocumentScreenState();
}

class _KycDocumentScreenState extends State<KycDocumentScreen> {
  final ImagePicker _picker = ImagePicker();
  File? aadharImage;
  File? licenseImage;
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Colors.grey[900]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("KYC VERIFICATION",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info card
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[300]!, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "KYC Document Verification",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Please upload clear images of your documents for verification. This helps us ensure the security of your account.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue[800],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Document Upload Section
            Text(
              "DOCUMENTS UPLOAD",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            
            _buildUploadTile(
              "AADHAR CARD", 
              aadharImage, 
              () => _pickImage(DocumentType.aadhar)
            ),
            
            _buildUploadTile(
              "DRIVING LICENCE", 
              licenseImage, 
              () => _pickImage(DocumentType.license)
            ),
            
            SizedBox(height: 30),

            // Submit Button with animation
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: (aadharImage != null && licenseImage != null) 
                      ? Colors.green[700] 
                      : Colors.grey[400],
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 6,
                  shadowColor: Colors.green[300],
                ),
                onPressed: (aadharImage != null && licenseImage != null && !isUploading) 
                    ? () => _submitDocuments(context)
                    : null,
                child: isUploading 
                    ? SizedBox(
                        width: 20, 
                        height: 20, 
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        "SUBMIT DOCUMENTS",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Custom Upload Button with Material Design and Preview
 Widget _buildUploadTile(String title, File? image, VoidCallback onTap) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    margin: EdgeInsets.symmetric(vertical: 6),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          blurRadius: 6,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
              ),
              onPressed: onTap,
              child: Text(
                image == null ? "UPLOAD" : "CHANGE",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        
        // Show preview if image exists
        if (image != null) ...[
          SizedBox(height: 12),
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                image,
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ],
    ),
  );
}
  // Pick image from gallery or camera
 Future<void> _pickImage(DocumentType type) async {
  final source = await showModalBottomSheet<ImageSource>(
    context: context,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      // Keep your existing bottom sheet UI
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Select Image Source",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSourceOption(
                    context,
                    Icons.camera_alt,
                    "Camera",
                    ImageSource.camera,
                  ),
                  _buildSourceOption(
                    context,
                    Icons.photo_library,
                    "Gallery",
                    ImageSource.gallery,
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      );
    },
  );

  if (source == null) return;

  try {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 80,  // Optional compression to improve performance
      maxWidth: 1200,    // Optional dimension limits
      maxHeight: 1200
    );
    
    if (pickedFile == null) return;
    
    // Use the picked image directly without cropping
    File imageFile = File(pickedFile.path);
    
    setState(() {
      if (type == DocumentType.aadhar) {
        aadharImage = imageFile;
      } else {
        licenseImage = imageFile;
      }
    });
  } catch (e) {
    print("Error picking image: $e");
    // Show error message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error selecting image. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
} // Build bottom sheet option
  Widget _buildSourceOption(
    BuildContext context, 
    IconData icon, 
    String label, 
    ImageSource source
  ) {
    return GestureDetector(
      onTap: () => Navigator.pop(context, source),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.blue[700],
              size: 32,
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Crop selected image
 
  // Handle submission of documents
Future<void> _submitDocuments(BuildContext context) async {
  // Set loading state
  setState(() {
    isUploading = true;
  });

  try {
    // Check if aadharImage is available
    if (aadharImage == null) {
      throw Exception("Aadhar card image is not selected");
    }

    // Upload the Aadhar card image
    final aadharResponse = await _uploadAadharToServer(aadharImage!);
    
    // If you want to upload license image too, you can add that here
    // if (licenseImage != null) {
    //   await _uploadDocumentToServer(licenseImage!, 'license');
    // }

    // Reset loading state
    setState(() {
      isUploading = false;
    });

    // Show success dialog
    _showVerificationSubmittedDialog(context);
  } catch (e) {
    // Handle error
    setState(() {
      isUploading = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error uploading documents: ${e.toString()}'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

// Add this new method to handle the Aadhar card upload
Future<http.Response> _uploadAadharToServer(File imageFile) async {
  // Create a multipart request
  var request = http.MultipartRequest(
    'POST', 
    Uri.parse('http://192.168.224.115:5000/upload_aadhardetails')
  );
  
  // Add the file to the request
  request.files.add(
    await http.MultipartFile.fromPath(
      'image', // This is the field name your server expects
      imageFile.path,
    )
  );
  
  // Send the request
  var streamedResponse = await request.send();
  
  // Convert to a regular response
  var response = await http.Response.fromStream(streamedResponse);
  
  // Check if the request was successful
  if (response.statusCode != 200) {
    throw Exception('Failed to upload Aadhar card. Status: ${response.statusCode}, Response: ${response.body}');
  }
  
  print('Aadhar card uploaded successfully: ${response.body}');
  return response;
}
  // Show success dialog after submission
  void _showVerificationSubmittedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Column(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 60,
              ),
              SizedBox(height: 16),
              Text(
                "Documents Submitted!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            "Your documents have been submitted successfully. We will review them shortly. You will be notified once the verification is complete.",
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              child: Text(
                "OK",
                style: TextStyle(
                  color: Colors.green[700],
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Return to previous page
              },
            ),
          ],
        );
      },
    );
  }
}