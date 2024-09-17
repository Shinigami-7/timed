import 'package:flutter/material.dart';
import 'package:timed/utils/app_colors.dart'; // Assuming you have AppColors defined

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
            // Profile Picture
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: AssetImage('assets/icons/me.jpg'), // Your image
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
            // Buttons for different actions
            _buildMenuButton("My Medicines", Colors.green, Colors.blue),
            _buildMenuButton("Settings", Colors.green, Colors.blue),
            _buildMenuButton("Privacy Policy", Colors.green, Colors.blue),
            _buildMenuButton("About Us", Colors.green, Colors.blue),
            _buildMenuButton("Logout", Colors.green, Colors.blue),
          ],
        ),
      ),
    );
  }

  // Helper function to create a button with a gradient background
  Widget _buildMenuButton(String title, Color startColor, Color endColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 40),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [startColor, endColor],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextButton(
          onPressed: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
