import 'package:flutter/material.dart';
// Assuming you have AppColors defined
import 'package:timed/widgets/build_menu_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
            // Profile Picture (from separate file)
             CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: const AssetImage('assets/icons/me.jpg'),
              child: ClipOval(
                child: Image.asset(
                  "assets/icons/me.jpg",
                  fit: BoxFit.cover,
                  width: 190,
                  height: 190,
                ),
              ),
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
            GradientButton(title: "Settings", onPressed: () {}),
            GradientButton(title: "Privacy Policy", onPressed: () {}),
            GradientButton(title: "About Us", onPressed: () {}),
            GradientButton(title: "Logout", onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
