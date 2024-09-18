import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PasswordService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> changePassword(String newPassword) async {
    User? user = _auth.currentUser;

    if (user != null) {
      // Update password in Firebase Authentication
      await user.updatePassword(newPassword);

      // Update the password in Firestore
      await _firestore.collection('user').doc(user.uid).update({
        'password': newPassword, // Assuming you store passwords in Firestore, which is not recommended for security reasons
      });

      // Reauthenticate the user after password update (optional)
      await user.reload();
    } else {
      throw Exception("No user logged in");
    }
  }
}
