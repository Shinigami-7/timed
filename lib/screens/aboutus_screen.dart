import 'package:flutter/material.dart';
import 'package:timed/widgets/navigation_bar.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size; // For responsive sizing

    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "About Us",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
           leading: IconButton(
            icon: const Icon(Icons.arrow_back), // Back icon
            onPressed: () {
               Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainNavigationBar(),
                settings: const RouteSettings(arguments: 4),            
                )
              );
            },
          ),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: media.height * 0.005), 
              const Text(
                "Our Mission",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "At Timed, our mission is to help individuals, particularly those with chronic conditions, manage their medication schedules effectively. We strive to improve patient adherence to their treatment plans through user-friendly and customizable medication reminders.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                "Who We Are",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Timed is developed by a dedicated team of health and technology professionals who understand the challenges of medication management, especially for elderly and midlife patients. Our aim is to use technology to simplify healthcare and improve health outcomes.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                "What We Do",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "We create tools that empower patients to take control of their health. Timed offers a simple interface with advanced functionality, helping users set reminders for their medication, appointments, and health checkups.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                "Our Vision",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "We envision a future where technology plays a pivotal role in healthcare management, reducing the burden on hospitals while improving patient outcomes through better medication adherence.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                "Contact Us",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "For any inquiries or support, please contact us at info@timedapp.com.",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
