import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Firebase Storage
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:timed/widgets/navigation_bar.dart';
import 'package:timed/widgets/round_gradient_button.dart';

class UploadPrescriptionScreen extends StatefulWidget {
  @override
  _UploadPrescriptionScreenState createState() =>
      _UploadPrescriptionScreenState();
}

class _UploadPrescriptionScreenState extends State<UploadPrescriptionScreen> {
  dynamic _image; // Holds the selected image (File or Uint8List)
  bool _isUploading = false; // Tracks upload progress
  String? _downloadUrl; // Stores the download URL after upload

  final ImagePicker _picker = ImagePicker();

  // Method to pick or capture an image
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        if (kIsWeb) {
          // On web, read the image as bytes
          Uint8List webImage = await pickedFile.readAsBytes();
          setState(() {
            _image = webImage;
          });
        } else {
          // On mobile, use File class
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

  // Method to upload the image to Firebase
  Future<void> _uploadImage() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image to upload.')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // Reference to Firebase Storage
      FirebaseStorage storage = FirebaseStorage.instance;
      String fileName = 'prescriptions/${DateTime.now().millisecondsSinceEpoch}';

      // Upload the file
      Reference ref = storage.ref().child(fileName);

      UploadTask uploadTask;
      if (kIsWeb) {
        // For web, upload as Uint8List
        uploadTask = ref.putData(_image as Uint8List);
      } else {
        // For mobile, upload the File
        uploadTask = ref.putFile(_image as File);
      }

      // Await the completion of the upload task
      TaskSnapshot snapshot = await uploadTask;

      // Get the download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        _downloadUrl = downloadUrl;
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image uploaded successfully!')),
      );
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      print("Error uploading image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload image.')),
      );
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
                          ? screenSize.height * 0.15
                          : screenSize.height * 0.25,
                    ),

                    const SizedBox(height: 20),

                    // Buttons to capture or pick an image
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () => _pickImage(ImageSource.camera),
                          child: const Text('Take Photo'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical: screenSize.height * 0.02,
                              horizontal:
                              screenSize.width * (isWideScreen ? 0.15 : 0.1),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () => _pickImage(ImageSource.gallery),
                          child: const Text('Pick from Gallery'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical: screenSize.height * 0.02,
                              horizontal:
                              screenSize.width * (isWideScreen ? 0.15 : 0.1),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Display selected image or message
                    _image != null
                        ? (kIsWeb
                        ? Image.memory(
                      _image as Uint8List,
                      height: screenSize.height *
                          (isWideScreen ? 0.4 : 0.3),
                      fit: BoxFit.cover,
                    )
                        : Image.file(
                      _image as File,
                      height: screenSize.height *
                          (isWideScreen ? 0.4 : 0.3),
                      fit: BoxFit.cover,
                    ))
                        : const Text(
                      'No image selected',
                      style: TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 20),

                    // Upload button
                    _isUploading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                      onPressed: _uploadImage,
                      child: const Text('Upload Image'),
                    ),

                    const SizedBox(height: 20),

                    // Show download URL if available
                    if (_downloadUrl != null)
                      SelectableText(
                        'Download URL: $_downloadUrl',
                        style: const TextStyle(color: Colors.blue),
                      ),

                    const SizedBox(height: 20),

                    RoundGradientButton(
                      title: 'Next',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainNavigationBar(),
                            settings: const RouteSettings(arguments: 0),
                          ),
                        );
                      },
                    ),
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
