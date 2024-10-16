import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timed/firebase_options.dart';
import 'package:timed/screens/landing_screen.dart';
import 'package:timed/widgets/navigation_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Timed",
      debugShowCheckedModeBanner: false,
      home: _auth.currentUser != null
          ? const MainNavigationBar()
          : const LandingScreen(),
    );
  }
}