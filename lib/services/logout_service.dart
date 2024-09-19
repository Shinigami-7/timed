import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timed/screens/login_screen.dart';

class LogoutService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method to log out the user with confirmation dialog
  Future<void> logout(BuildContext context) async {
    // Show a confirmation dialog
    bool shouldLogout = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User cancels the logout
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User confirms the logout
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    // If the user confirms, proceed with logout
    if (shouldLogout == true) {
      try {
        await _auth.signOut();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false, // Remove all routes and go back to login screen
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error logging out: $e')),
        );
      }
    }
  }
}
