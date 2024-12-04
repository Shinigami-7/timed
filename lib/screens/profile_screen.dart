import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:timed/services/logout_service.dart';
import 'package:timed/screens/aboutus_screen.dart';
import 'package:timed/screens/privacy_screen.dart';
import 'package:timed/screens/setting_screen.dart';
import 'package:timed/widgets/build_menu_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timed/utils/pick_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Uint8List? _image;
  String? _fullName;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('user').doc(userId).get();

      setState(() {
        _fullName = userDoc.get('fullname') as String?;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void selectImage() async {
    Uint8List? img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: media.height * 0.05),
                  const Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: media.height * 0.03),
                  Stack(
                    children: [
                      _image != null
                          ? CircleAvatar(
                              radius: 60,
                              backgroundImage: MemoryImage(_image!),
                            )
                          : CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.grey.shade200,
                              backgroundImage: NetworkImage(
                                  "https://w7.pngwing.com/pngs/205/731/png-transparent-default-avatar-thumbnail.png"),
                            ),
                      Positioned(
                        child: IconButton(
                            onPressed: selectImage,
                            icon: Icon(Icons.add_a_photo)),
                        bottom: -10,
                        left: 80,
                      )
                    ],
                  ),
                  SizedBox(height: media.height * 0.02),
                  Text(
                    _fullName ?? "Name not available",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  SizedBox(height: media.height * 0.03),
                  

                  GradientButton(
                      title: "Settings",
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SettingScreen()),
                        );
                      }),
                  GradientButton(
                      title: "Privacy Policy",
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PrivacyScreen()),
                        );
                      }),
                  GradientButton(
                      title: "About Us",
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AboutUsScreen()),
                        );
                      }),
                  GradientButton(
                      title: "Logout",
                      onPressed: () {
                        LogoutService().logout(context);
                      }),
                ],
              ),
            ),
    );
  }
}
