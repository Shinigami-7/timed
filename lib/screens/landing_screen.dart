import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top Image and Text
          SizedBox(
            height: 300,
            child: Stack(
              children: [
                // The image
                Positioned.fill(
                  child: Image.asset(
                    'assets/icons/me.png',
                    fit: BoxFit.cover,
                  ),
                ),
                // Text overlay
                const Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Text(
                    'Monitor your\nHealth Condition timely',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          
          // Welcome Text
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Welcome!\nLet\'s Start Your Healthy Medication Journey.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
          ),

          // Buttons (Login and Signup)
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Implement login functionality
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50), backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ), // Login Button Color
                  ),
                  child: const Text('Login'),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Implement signup functionality
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50), backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ), // Signup Button Color
                  ),
                  child: const Text('Signup'),
                ),
              ),
              const SizedBox(height: 40), // Add some bottom padding
            ],
          ),
        ],
      ),
    );
  }
}