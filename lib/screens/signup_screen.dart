
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timed/screens/login_screen.dart';
import 'package:timed/utils/app_colors.dart';
import 'package:timed/widgets/round_gradient_button.dart';
import 'package:timed/widgets/round_text_field.dart';
import 'package:timed/services/notification_logic.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _users = FirebaseFirestore.instance.collection("user");

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  bool _isObscurepass = true;
  bool _isObscureconfirm = true;
  bool _isCheck = false;
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordStrong = false;

  Future<void> _signUp(BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        // Initialize notifications after user signs up successfully
        await NotificationLogic.init(context, user.uid);

        await _users.doc(user.uid).set({
          'fullname': _fullnameController.text,
          'email': _emailController.text,
          'password': _passController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account created")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  void dispose() {
    _fullnameController.clear();
    _emailController.clear();
    _passController.clear();
    _confirmPassController.clear();
    _fullnameController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  bool validateEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return emailRegex.hasMatch(email);
  }

  bool isPasswordStrong(String password) {
    return RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
        .hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/timed.png',
                    fit: BoxFit.contain,
                    width: media.width * 0.7,
                    height: media.height * 0.2,
                  ),
                  SizedBox(height: media.height * 0.03),
                  const Text(
                    "Create an Account",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: media.width * 0.02),
                  RoundTextField(
                    textEditingController: _fullnameController,
                    hintText: "Full Name",
                    icon: Icons.person,
                    textInputType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your Full Name";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: media.width * 0.02),
                  RoundTextField(
                    textEditingController: _emailController,
                    hintText: "Email",
                    icon: Icons.email,
                    textInputType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your Email";
                      } else if (!validateEmail(value)) {
                        return "Invalid email address!";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: media.width * 0.02),
                  // Password Field
                  RoundTextField(
                    textEditingController: _passController,
                    hintText: "Password",
                    icon: Icons.lock,
                    textInputType: TextInputType.text,
                    isObscureText: _isObscurepass,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your Password";
                      } else if (!isPasswordStrong(value)) {
                        return "Weak password, please enter a strong password";
                      }
                      return null;
                    },
                    rightIcon: TextButton(
                      onPressed: () {
                        setState(() {
                          _isObscurepass = !_isObscurepass;
                        });
                      },
                      child: Icon(
                        _isObscurepass ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                  SizedBox(height: media.width * 0.02),

// Confirm Password Field
                  RoundTextField(
                    textEditingController: _confirmPassController,
                    hintText: "Confirm Password",
                    icon: Icons.lock,
                    textInputType: TextInputType.text,
                    isObscureText: _isObscureconfirm,
                    // enabled: isPasswordStrong(_passController.text), // Disable if password is weak
                    validator: (value) {
                      if (!isPasswordStrong(_passController.text)) {
                        return "Please enter a strong password first.";
                      }
                      if (value == null || value.isEmpty) {
                        return "Please confirm your Password";
                      } else if (value != _passController.text) {
                        return "Passwords don't match";
                      }
                      return null;
                    },
                    rightIcon: TextButton(
                      onPressed: () {
                        setState(() {
                          _isObscureconfirm = !_isObscureconfirm;
                        });
                      },
                      child: Icon(
                        _isObscureconfirm ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),


                  SizedBox(height: media.width * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _isCheck = !_isCheck;
                          });
                        },
                        icon: Icon(
                          _isCheck
                              ? Icons.check_box_outlined
                              : Icons.check_box_outline_blank,
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          "By continuing you accept our Privacy Policy and Terms of Use",
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: media.width * 0.1),
                  RoundGradientButton(
                    title: "Create Account",
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (_isCheck) {
                          _signUp(context, _emailController.text,
                              _passController.text);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Please accept the Terms and Conditions")),
                          );
                        }
                      }
                    },
                  ),
                  SizedBox(height: media.width * 0.1),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          height: 1,
                          color: AppColors.grayColor.withOpacity(0.5),
                        ),
                      ),
                      const Text(
                        " Or ",
                        style: TextStyle(
                          color: AppColors.grayColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          height: 1,
                          color: AppColors.grayColor.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: media.width * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 50,
                          width: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: AppColors.primaryColor1.withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                          child: Image.asset(
                            "assets/icons/google.png",
                            height: 20,
                            width: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: media.width * 0.05),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        children: [
                          TextSpan(text: "Already have an account? "),
                          TextSpan(
                            text: "Login",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryColor1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
