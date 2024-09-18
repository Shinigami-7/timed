import 'package:flutter/material.dart';
// Assuming you have AppColors defined
import 'package:timed/widgets/build_menu_button.dart';

class ChangepasswordScreen extends StatelessWidget {
  const ChangepasswordScreen({super.key});

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
              "change Password",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: media.height * 0.03),
            // Profile Picture (from separate file)
            SizedBox(height: media.height * 0.005),
            // Edit Info
            SizedBox(height: media.height * 0.03),
            // Buttons for different actions (using GradientButton widget from another file)
            GradientButton(title: "Change Password", onPressed: () {}),
            GradientButton(title: "Sounds and vibration", onPressed: () {}),
            GradientButton(title: "Notification", onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
