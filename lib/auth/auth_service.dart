import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:timed/services/notification_logic.dart';
import 'package:timed/widgets/navigation_bar.dart';

class AuthSrevice{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Future<User?> _signIn(BuildContext context, String email, String password) async {

  //   try {
  //     UserCredential userCredential = await _auth.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     User? user = userCredential.user;

  //     if (user != null) {
  //       // Initialize notifications after user logs in successfully
  //       await NotificationLogic.init(context, user.uid);

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Login Successful")),
  //       );

  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => const MainNavigationBar()),
  //       );
  //     }

  //     return user;
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Login Failed, Please check your email and password")),
  //     );
  //     return null;
  //   }
  // }
 
  signInWIthGoogle() async {
    //begin interactive sign in process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    //user cancel
    if(gUser == null) return;  

    //obtain auth details from request
    final GoogleSignInAuthentication gAuth = await gUser.authentication;

    //create a new credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.accessToken,
    );

    //sign in
    return await _auth.signInWithCredential(credential);
  }

  
}