import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:timed/widgets/navigation_bar.dart';
import 'dart:io';

import 'package:timed/widgets/round_gradient_button.dart'; // For mobile platforms only (iOS, Android)

class UploadPrescriptionScreen extends StatefulWidget {
  @override
  _UploadPrescriptionScreenState createState() => _UploadPrescriptionScreenState();
}

class _UploadPrescriptionScreenState extends State<UploadPrescriptionScreen> {
  dynamic _image; // This will store the image (either File or Uint8List)

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    ImagePicker _picker = ImagePicker();
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        if (kIsWeb) {
          // If we're on the web, read the image as bytes
          Uint8List webImage = await pickedFile.readAsBytes();
          setState(() {
            _image = webImage;
          });
        } else {
          // On mobile, use the File class
          File mobileImage = File(pickedFile.path);
          setState(() {
            _image = mobileImage;
          });
        }
      } else {
        print("No image selected.");
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size and orientation
    var screenSize = MediaQuery.of(context).size;
    var orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Prescription'),
        backgroundColor: Colors.blue,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Use LayoutBuilder constraints to determine different screen sizes
          double maxWidth = constraints.maxWidth;
          bool isWideScreen = maxWidth > 600;

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(screenSize.width * 0.05),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    
                    // Adjust image upload icon size based on screen width
                    Image.asset(
                      'assets/icons/upload_icon.png', // Replace with your asset
                      height: orientation == Orientation.portrait
                          ? screenSize.height * 0.15 // Adjust height for portrait
                          : screenSize.height * 0.25, // Adjust height for landscape
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Button to upload an image with responsive padding
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text('Pick Image'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: screenSize.height * 0.02,
                          horizontal: screenSize.width * (isWideScreen ? 0.15 : 0.1),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Display selected image or message with responsive height
                    _image != null
                        ? (kIsWeb
                            ? Image.memory(
                                _image as Uint8List, // Display web image
                                height: screenSize.height * (isWideScreen ? 0.4 : 0.3), // More height for wider screens
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                _image as File, // Display mobile image
                                height: screenSize.height * (isWideScreen ? 0.4 : 0.3), // More height for wider screens
                                fit: BoxFit.cover,
                              ))
                        : const Text(
                            'No image selected',
                            style: TextStyle(color: Colors.grey),
                          ),
                    
                    const SizedBox(height: 20),
                    RoundGradientButton(title: 'Next', onPressed: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainNavigationBar(),
                                  settings: RouteSettings(arguments: 0)));
                    })
                 
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
