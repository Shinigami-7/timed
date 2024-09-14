import 'package:flutter/material.dart';
import 'package:timed/screens/home%20screen.dart';
import 'package:timed/screens/login%20screen.dart';
import 'package:timed/utils/app_colors.dart';
import 'package:timed/widgets/round_gradient_button.dart';
import 'package:timed/widgets/round_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  bool _isObscurepass= true;
  bool _isObscureconfirm= true;
  bool _isCheck = false;
  final _formKey = GlobalKey<FormState>();

  // Future<User?> _signIn(
  //   BuildContext context, String email, String password) async{
  //     try{
  //       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
  //         email: email, password: password
  //       );
  //       User? user = userCredential.user;
  //       Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen(),
  //       ));
  //       return user;
  //     }catch(e){
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text("Login Failed, Please check your email and password")
  //       ),
  //       );
  //       return null;
  //     }
  //   }
  @override
  void dispose() {
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

   String errorText = '';

  void signUp() {
    if (_formKey.currentState!.validate() && _isCheck) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoignScreen()),
      );
    } else {
      if (!_isCheck) {
        setState(() {
          errorText = 'Please accept the Terms and Conditions';
        });
      }
    }
  }
  
  @override
  void initState(){
    //TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical:15, horizontal: 25),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: media.height*0.1,),
                  SizedBox(
                    width: media.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: media.height*0.03,
                        ),
                        Text("Yo",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400
                        ),
                        ),
                        SizedBox(
                          height: media.height*0.03,
                        ),
                        Text("Create an Account",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w700
                        ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: media.width*0.02,),
                  RoundTextField(
                    textEditingController: _fullnameController,
                    hintText: "Full Name", 
                    icon: Icons.person, 
                    textInputType: TextInputType.name,
                    validator: (value){
                      if (value ==null || value.isEmpty){
                        return "Please enter your Full Name";
                      }
                      return null;
                    },
                  ),
                 
                  SizedBox(height: media.width*0.02,),
                  RoundTextField(
                    textEditingController: _emailController,
                    hintText: "Email", 
                    icon: Icons.email, 
                    textInputType: TextInputType.emailAddress,
                    validator: (value){
                      if (value ==null || value.isEmpty){
                        return "Please enter your Email";
                      }else if (!validateEmail(value)) {
                        return "Invalid email address!";
                      }
                    },
                  ),
                  SizedBox(height: media.width*0.02,),
                  RoundTextField(
                    textEditingController: _passController,
                    hintText: "Password", 
                    icon: Icons.lock, 
                    textInputType: TextInputType.text,
                    isObsecureText: _isObscurepass,
                    validator: (value){
                      if (value ==null || value.isEmpty){
                        return "Please enter your Password";
                      }
                      else if(value.length < 6){
                        return "Password must be atleast 6 character long";
                      }
                      return null;
                    },
                    rightIcon: TextButton(
                      onPressed: (){
                        setState(() {
                          _isObscurepass = !_isObscurepass;
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 20,
                        width: 20,
                        child: Icon(_isObscurepass? Icons.visibility : Icons.visibility_off),
                      ),
                    ),
                  ),
                  SizedBox(height: media.width*0.02,),
                  RoundTextField(
                    textEditingController: _confirmPassController,
                    hintText: "Confirm Password", 
                    icon: Icons.lock, 
                    textInputType: TextInputType.text,
                    isObsecureText: _isObscureconfirm,
                    validator: (value){
                      if (value ==null || value.isEmpty){
                        return "Please enter your Password";
                      }
                      else if(value!=_passController.text){
                        return "Password doesn't match";
                      }
                      else if(value.length < 6){
                        return "Password must be atleast 6 character long";
                      }
                      return null;
                    },
                    rightIcon: TextButton(
                      onPressed: (){
                        setState(() {
                          _isObscureconfirm = !_isObscureconfirm;
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 20,
                        width: 20,
                        child: Icon(_isObscureconfirm ? Icons.visibility : Icons.visibility_off),
                      ),
                    ),
                  ),
                  SizedBox(height:media.width*0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(onPressed: (){
                        setState(() {
                          _isCheck = !_isCheck;
                        });
                      }, 
                      icon: Icon(_isCheck ? Icons.check_box_outlined : Icons.check_box_outline_blank)
                      ),
                      Expanded(
                        child: Text("By continuing you accept our Privacy and Policy and term of use"),
                      ),
                      
                    ],
                  ),
                 
                  SizedBox(
                    height: media.width*0.1,
                  ),

                  //temporary
                  ElevatedButton(onPressed:signUp
                  , child: Text("Create Account")),


                  // RoundGradientButton(title: "Create Account", 
                  // onPressed: (){
                  //   if(_formKey.currentState!.validate()){
                  // if(_isCheck){
                  //   try{
                  //     UserCredential userCredential = _auth.createUserWithEmailAndPassword(
                  //       email: _emailController.text,
                  //       password: _passController.text,
                  //       confirmPassword: _confirmPassController.text,
                  //     );
                  //   }catch(e){}
                  // }
                  //   }
                  // }),
                  SizedBox(
                    height: media.width*0.1,
                  ),
                  Row(
                    children: [
                      Expanded(child: Container(
                        width: double.infinity,
                        height: 1,
                        color: AppColors.grayColor.withOpacity(0.5),
                      )),
                      Text(" Or ",
                      style: TextStyle(
                        color: AppColors.grayColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w400
                      ),
                      ),
                      Expanded(child: Container(
                        width: double.maxFinite,
                        height: 1,
                        color: AppColors.grayColor.withOpacity(0.5),
                      )),
                    ],
                  ),
                  SizedBox(
                    width: media.width*0.05,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: (){},
                        child: Container(
                          height: 50,
                          width: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: AppColors.primaryColor1.withOpacity(0.5),
                              width: 1,
                            )
                          ),
                          child: Image.asset("assets/icons/google.png",
                          height: 20, width: 20,),
                        ),
                      ),
                    SizedBox(
                    width: 30,
                  ),
                  GestureDetector(
                        onTap: (){},
                        child: Container(
                          height: 50,
                          width: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: AppColors.primaryColor1.withOpacity(0.5),
                              width: 1,
                            )
                          ),
                          child: Image.asset("assets/icons/facebook.png",
                          height: 20, width: 20,),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: media.width*0.05,
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