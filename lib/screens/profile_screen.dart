import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:timed/services/logout_service.dart';
import 'package:timed/screens/aboutus_screen.dart';
import 'package:timed/screens/privacy_screen.dart';
import 'package:timed/screens/setting_screen.dart';
import 'package:timed/widgets/build_menu_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timed/utils/pick_image.dart';


class ProfileScreen extends StatefulWidget {
   ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Uint8List? _image;

  void selectImage() async{
     Uint8List? img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img ;
    });

  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size; // For responsive sizing

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: media.height * 0.05), // Space from the top
            const Text(
              "Profile",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: media.height * 0.03),
            // Profile Picture
            Stack(
              children: [
                _image!= null? CircleAvatar(
                  radius: 60,
                  backgroundImage: MemoryImage(_image!),
                ):
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: NetworkImage("https://w7.pngwing.com/pngs/205/731/png-transparent-default-avatar-thumbnail.png"),
                ),
                Positioned(
                  child: IconButton(onPressed: selectImage, 
                  icon: Icon(Icons.add_a_photo)),
                  bottom: -10,
                  left: 80,
                )
              ],
            ),
            SizedBox(height: media.height * 0.02),
            // Name
            const Text(
              "Reezan Shrestha",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: media.height * 0.01),
            // Gender and Age
            const Text(
              "Male(21)",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: media.height * 0.005),
            // Edit Info
            TextButton(
              onPressed: () {},
              child: const Text(
                "Edit Info",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: media.height * 0.03),
            // Buttons for different actions (using GradientButton widget from another file)
            GradientButton(title: "My Medicines", onPressed: () {}),

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
