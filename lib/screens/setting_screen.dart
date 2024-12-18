import 'package:flutter/material.dart';
import 'package:timed/screens/changepassword_screen.dart';
import 'package:timed/screens/notification_screen.dart';
import 'package:timed/widgets/build_menu_button.dart';
import 'package:timed/widgets/navigation_bar.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size; // For responsive sizing

    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Setting",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainNavigationBar(),
                    settings: const RouteSettings(arguments: 4),
                  ));
            },
          ),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: media.height * 0.005),
              // Buttons for different actions (using GradientButton widget from another file)
              GradientButton(
                  title: "Change Password",
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChangePasswordScreen()),
                    );
                  }),
              // GradientButton(title: "Sounds and vibration", onPressed: () {}),
              GradientButton(
                  title: "Notification",
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationPage()
                        )
                      );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
