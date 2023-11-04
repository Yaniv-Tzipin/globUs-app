// ignore_for_file: unnecessary_const, prefer_const_constructors, prefer_const_literals_to_create_immutables


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfirstapp/components/my_button.dart';
import 'package:myfirstapp/components/my_textfield.dart';
import 'package:myfirstapp/components/square_title.dart';
import 'package:myfirstapp/services/auth_service.dart';


class RegisterPage extends StatefulWidget{
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

  //sign user up method
  void signUserUp() async{

    // try creating the user

    if(passwordController.text != confirmPasswordController.text){
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
    
    try{
    // check if password is confirmed
    
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: mailController.text,
      password: passwordController.text
      );
    //pop the loading circle
    Navigator.pop(context);
    


    } on FirebaseAuthException catch (e){

    //pop the loading circle
    Navigator.pop(context);
      
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

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Color.fromARGB(225, 220, 232, 220),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                SizedBox(height: 20),
                //logo
                Image.asset('lib/images/globUsLogo1.png',
                width: 200),
          
                //welcome back, you've been missed
                Text("Let's create an account for you!",
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
                ),
                SizedBox(height: 10),
                  
                //password textfields
                MyTextField(
                  controller: passwordController,
                  hintText: 'password',
                  obscureText: true,
                ), 
                SizedBox(height: 10),

                //confirm password
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm password',
                  obscureText: true,
                ), 
                SizedBox(height: 10),
                
                //forgot password
                
          
                SizedBox(height: 25),
                
                //sign in button
          
                MyButton(
                  onTap: signUserUp,
                  text: 'Sign Up'
                ),
          
                SizedBox(height: 50),
          
                  
                //or continue with
          
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(children: [
                    Expanded(child: Divider(
                      thickness: 0.5,
                      color: Color.fromARGB(255, 84, 119, 86),)
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text('Or Continue With',
                      style: TextStyle(color: Color.fromARGB(255, 86, 86, 84)),),
                    ),
                    Expanded(child: Divider(
                      thickness: 0.5,
                      color: Color.fromARGB(255, 84, 119, 86),) 
                    )
                  ],
                  ),
                ),
          
                SizedBox(height:20),
                  
                // google + apple signin bottons 
          
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  // google button
                  SquareTitle(
                  onTap: () => AuthService().signInWithGoogle(),
                  imagePath: 'lib/images/google.png'),
                  SizedBox(width:25),
          
                  // apple button
                  SquareTitle(
                  onTap: (){},
                  imagePath: 'lib/images/apple.png')
                ],
                ),
          
                SizedBox(height:40),
                  
                //not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account?',
                    style: TextStyle(
                      color:Color.fromARGB(255, 84, 119, 86),
                      fontSize: 14
                    )
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text('Log-in now',
                      style: TextStyle(
                        color: Color.fromARGB(255, 196, 147, 73),
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
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
