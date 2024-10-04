import 'package:flutter/material.dart';
import 'package:timed/screens/login_screen.dart';
import 'package:timed/screens/signup_screen.dart';
import 'package:timed/widgets/round_gradient_button.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: screenHeight * 0.5, 
            child: Stack(
              children: [
                // The image
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/medications.jpg',
                    fit: BoxFit.contain,
                  ),
                ),
                // Text overlay
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Text(
                    'Monitor your\nHealth Condition timely',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: media.height * 0.03, // Scaled font size
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          // Welcome Text
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05, // 5% of screen width
            ),
            child: Text(
              'Welcome!\nLet\'s Start Your Healthy Medication Journey.',
              style: TextStyle(
                fontSize: screenHeight * 0.02, // Scaled font size
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          Padding(
            padding: EdgeInsets.only(
              bottom: screenHeight * 0.05, // 5% bottom padding
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: 
                  RoundGradientButton(
                      title: 'Login',
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      },

                  )
                  
                ),
                SizedBox(height: screenHeight * 0.02), // Spacing between buttons
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: RoundGradientButton(
                      title: 'SignUp',
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignupScreen()));
                      },

                  )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
