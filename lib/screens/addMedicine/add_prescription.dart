import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class UploadPrescriptionScreen extends StatefulWidget {
  @override
  _UploadPrescriptionScreenState createState() =>
      _UploadPrescriptionScreenState();
}

class _UploadPrescriptionScreenState extends State<UploadPrescriptionScreen> {
  dynamic _image;
  bool _isUploading = false;
  String? _downloadUrl;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        if (kIsWeb) {
          Uint8List webImage = await pickedFile.readAsBytes();
          setState(() {
            _image = webImage;
          });
        } else {
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
      FirebaseStorage storage = FirebaseStorage.instance;
      String fileName = 'prescriptions/${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference ref = storage.ref().child(fileName);

      UploadTask uploadTask;
      if (kIsWeb) {
        uploadTask = ref.putData(_image as Uint8List);
      } else {
        uploadTask = ref.putFile(_image as File);
      }

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Storing metadata in Firestore
      await FirebaseFirestore.instance.collection('prescriptions').add({
        'imageUrl': downloadUrl,
        'uploadedAt': FieldValue.serverTimestamp(),
      });

      setState(() {
        _downloadUrl = downloadUrl;
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image uploaded and saved successfully!')),
      );
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      print("Error uploading image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Prescription'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenSize.width * 0.05),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Upload your Prescription',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => _pickImage(ImageSource.camera),
                      child: const Text('Take Photo'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      child: const Text('Pick from Gallery'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _image != null
                    ? (kIsWeb
                    ? Image.memory(
                  _image as Uint8List,
                  height: screenSize.height * 0.4,
                  fit: BoxFit.cover,
                )
                    : Image.file(
                  _image as File,
                  height: screenSize.height * 0.4,
                  fit: BoxFit.cover,
                ))
                    : const Text(
                  'No image selected',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),
                _isUploading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _uploadImage,
                  child: const Text('Upload Image'),
                ),
                const SizedBox(height: 20),
                if (_downloadUrl != null)
                  SelectableText(
                    'Download URL: $_downloadUrl',
                    style: const TextStyle(color: Colors.blue),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
