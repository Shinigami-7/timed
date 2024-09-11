import 'package:flutter/material.dart';

class LoignScreen extends StatefulWidget {
  const LoignScreen({super.key});

  @override
  State<LoignScreen> createState() => _LoignScreenState();
}

class _LoignScreenState extends State<LoignScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _isObscure = true;
  final _formKey = GlobalKey<FormState>();

  Future<User?> _signIn(
    BuildContext context, String email, String password) async{
      try{
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          
        )
      }catch(e){}
    }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}