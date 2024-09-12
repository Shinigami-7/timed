import 'package:flutter/material.dart';
import 'package:timed/screens/home%20screen.dart';
import 'package:timed/utils/app_colors.dart';
import 'package:timed/widgets/round_gradient_button.dart';
import 'package:timed/widgets/round_text_field.dart';

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
                        Text("Hey there",
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
                        Text("Welcome Back",
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
                  SizedBox(height: media.width*0.1,),
                  RoundTextField(
                    textEditingController: _emailController,
                    hintText: "Email", 
                    icon: Icons.email, 
                    textInputType: TextInputType.emailAddress,
                    validator: (value){
                      if (value ==null || value.isEmpty){
                        return "Please enter your emali";
                      }
                      return null;
                    },
                  ),
                                    SizedBox(height: media.width*0.1,),
                  RoundTextField(
                    textEditingController: _passController,
                    hintText: "Password", 
                    icon: Icons.lock, 
                    textInputType: TextInputType.text,
                    isObsecureText: _isObscure,
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
                          _isObscure = !_isObscure;
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 20,
                        width: 20,
                        child: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: (){},
                      child: Text("Forgot your password?",
                      style: TextStyle(
                        color: AppColors.primaryColor1,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),),
                    ),
                  ),
                  SizedBox(
                    height: media.width*0.1,
                  ),

                  //temporary
                  ElevatedButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Homescreen()));
                  }, child: Text("Loign")),


                  // RoundGradientButton(title: "Login", 
                  // onPressed: (){
                  //   if(_formKey.currentState!.validate()){
                  //     _signIn(context,_emailController.text, _passController.text);
                  //   }
                  // }),
                  SizedBox(
                    height: media.width*0.1,
                  ),
                  Row(
                    children: [
                      Expanded(child: Container(
                        width: double.maxFinite,
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
                  TextButton(onPressed: (){}, 
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                        TextSpan(text: "Don't have an account?"),
                        TextSpan(
                          text: "Register",
                          style: TextStyle(
                            color: AppColors.secondaryColor1,
                            fontSize: 14,
                            fontWeight: FontWeight.w500
                          )
                        )
                      ]
                    ),
                  ))

                ],
              ),
            ),
          ),
        ),
        ),
    );
  }
}