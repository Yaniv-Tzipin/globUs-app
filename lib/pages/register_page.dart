// ignore_for_file: unnecessary_const, prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:myfirstapp/components/my_button.dart';
import 'package:myfirstapp/components/my_textfield.dart';
import 'package:myfirstapp/components/square_title.dart';
import 'package:myfirstapp/pages/continue_register.dart';
import 'package:myfirstapp/services/auth_service.dart';
import 'package:myfirstapp/services/user_validation.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterState();
}



class _RegisterState extends State<RegisterPage> {
  // text editing controllers
  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void continueRegister() async{

    //validate password
    bool passwordIsValid = ValidateUser().validatePasswords(
      passwordController.text, confirmPasswordController.text);
    if(!passwordIsValid){
      showErrorMessage("passwords don't match");
    }
    else{
    // show sign up circle 
    showDialog(
      context: context,
       builder: (context){
        return const Center(
          child: CircularProgressIndicator(),
        );
       }
      );
    
    // try creating the user
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: mailController.text.trim(),
      password: passwordController.text
      );

    // pop the loading circle
    // ignore: use_build_context_synchronously
    Navigator.pop(context); 

    // navigate to continue register
    Get.to(ContinueRegister());


    //!!!!! DONT FORGET TO ADD USERS' DETAILS!!!!!! use this method:
  //   Future addUserDetails(String email) async{
  //   await FirebaseFirestore.instance.collection('users').add({
  //     'email': email,
  //     'username': userNameController.text.trim(),
  //     // to add fields
  //   }
  //   );
  // }

    }on FirebaseAuthException catch (e){

    //pop the loading circle
    // ignore: use_build_context_synchronously
    Navigator.pop(context);

    //show a FirebaseAuth error
    showErrorMessage(e.code);
    }
    }
  }

    void showErrorMessage(String message){
    showDialog(context: context,
     builder: (context)
     {
      return AlertDialog(
        backgroundColor: Color.fromARGB(255, 110, 138, 100),
        title: Center(
          child: Text(message,
          style: TextStyle(color: Colors.white)
          )
        )
      );

     }
     );
  }

  void signUpWithGoogle() async{
  await AuthService().signInWithGoogle();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Color.fromARGB(225, 220, 232, 220),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  //logo
                  Image.asset('lib/images/globUsLogo1.png', width: 200),

                  //welcome back, you've been missed
                  Text(
                    "Let's create an account for you!",
                    style: TextStyle(
                      color: Color.fromARGB(255, 84, 119, 86),
                      fontSize: 16,
                    ),
                  ),

                  SizedBox(height: 25),

                  //username textfields
                  MyTextField(
                    controller: mailController,
                    hintText: 'Email',
                    obscureText: false, 
                    maximumLines: 1,
                    prefixIcon: Icons.mail,
                  ),
                  SizedBox(height: 10),

                  //password textfields
                  MyTextField(
                    controller: passwordController,
                    hintText: 'password',
                    obscureText: true,
                     maximumLines: 1,
                     prefixIcon: Icons.lock,
                  ),
                  SizedBox(height: 10),

                  //confirm password
                  MyTextField(
                    controller: confirmPasswordController,
                    hintText: 'Confirm password',
                    obscureText: true,
                    maximumLines: 1,
                    prefixIcon: Icons.repeat_on_rounded,
                  ),
                  SizedBox(height: 10),

                  //forgot password

                  SizedBox(height: 25),

                  //sign up button

                  MyButton(onTap: continueRegister, text: 'Sign Up'),

                  SizedBox(height: 50),

                  //or continue with

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      children: [
                        Expanded(
                            child: Divider(
                          thickness: 0.5,
                          color: Color.fromARGB(255, 84, 119, 86),
                        )),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'Or Continue With',
                            style: TextStyle(
                                color: Color.fromARGB(255, 86, 86, 84)),
                          ),
                        ),
                        Expanded(
                            child: Divider(
                          thickness: 0.5,
                          color: Color.fromARGB(255, 84, 119, 86),
                        ))
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // google + apple signin bottons

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // google button
                      SquareTitle(
                          onTap: () => signUpWithGoogle(),
                          imagePath: 'lib/images/google.png'),
                      SizedBox(width: 25),

                      // apple button
                      SquareTitle(
                          onTap: () {}, imagePath: 'lib/images/apple.png')
                    ],
                  ),

                  SizedBox(height: 40),

                  //not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account?',
                          style: TextStyle(
                              color: Color.fromARGB(255, 84, 119, 86),
                              fontSize: 14)),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          'Log-in now',
                          style: TextStyle(
                              color: Color.fromARGB(255, 196, 147, 73),
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        )
        );
  }
}
